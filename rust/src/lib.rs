use crate::bip39::generate_mnemonic;
use crate::network::{NetworkEnvironment, NetworkId};
use crate::utils::harden;
use cardano_serialization_lib::{
    address::{BaseAddress, EnterpriseAddress, RewardAddress, StakeCredential},
    crypto::{self, PrivateKey, Vkeywitnesses},
    utils::{hash_transaction, make_vkey_witness},
    Transaction, TransactionWitnessSet,
};

pub mod bip39;
pub mod minwallet;
pub mod network;
pub mod utils;

pub enum AddressType {
    BaseAddress,
    EnterpriseAddress,
}

pub enum WalletType {
    BaseWallet {
        address: String,
        reward_address: String,
        payment_key: String,
        stake_key: String,
    },
    EnterpriseWallet {
        address: String,
        payment_key: String,
    },
}

pub fn create_wallet(
    mnemonic: &str,
    password: &str,
    account_index: u32,
    address_type: AddressType,
    network_environment: NetworkEnvironment,
) -> WalletType {
    let network_id = NetworkId::from_network_environment(&network_environment) as u8;
    let root_key =
        crypto::Bip32PrivateKey::from_bip39_entropy(mnemonic.as_bytes(), password.as_bytes());

    let account_key = root_key
        .derive(harden(1852))
        .derive(harden(1815))
        .derive(account_index);

    let payment_key = account_key.derive(0).derive(0).to_raw_key();

    let payment_key_hash = payment_key.to_public().hash();

    match address_type {
        AddressType::BaseAddress => {
            let stake_key = account_key.derive(2).derive(0).to_raw_key();
            let stake_key_hash = stake_key.to_public().hash();

            let address = BaseAddress::new(
                network_id,
                &StakeCredential::from_keyhash(&payment_key_hash),
                &StakeCredential::from_keyhash(&stake_key_hash),
            )
            .to_address()
            .to_bech32(None)
            .unwrap();

            let reward_address =
                RewardAddress::new(network_id, &StakeCredential::from_keyhash(&stake_key_hash))
                    .to_address()
                    .to_bech32(None)
                    .unwrap();

            WalletType::BaseWallet {
                address,
                reward_address,
                payment_key: payment_key.to_bech32(),
                stake_key: stake_key.to_bech32(),
            }
        }
        AddressType::EnterpriseAddress => {
            let address = EnterpriseAddress::new(
                network_id,
                &StakeCredential::from_keyhash(&payment_key_hash),
            )
            .to_address()
            .to_bech32(None)
            .unwrap();

            WalletType::EnterpriseWallet {
                address,
                payment_key: payment_key.to_bech32(),
            }
        }
    }
}

pub fn sign_tx(tx_raw: &str, keys: Vec<String>) -> String {
    let tx = Transaction::from_bytes(tx_raw.as_bytes().to_vec()).unwrap();
    let tx_body = tx.body();
    let tx_hash = hash_transaction(&tx_body);

    let mut witness_set = TransactionWitnessSet::new();
    let mut vkey_witnesses = Vkeywitnesses::new();

    for key in keys {
        let pkey = PrivateKey::from_bech32(&key).unwrap();
        let vkey = make_vkey_witness(&tx_hash, &pkey);
        vkey_witnesses.add(&vkey);
    }

    witness_set.set_vkeys(&vkey_witnesses);
    witness_set.to_hex()
}

uniffi::include_scaffolding!("mwrust");
