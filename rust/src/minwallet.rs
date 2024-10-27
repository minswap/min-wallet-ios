use base64::prelude::BASE64_STANDARD;
use base64::Engine;
use bip39::Mnemonic;
use cardano_serialization_lib::emip3::{decrypt_with_password, encrypt_with_password};
use cardano_serialization_lib::{
    address::{BaseAddress, NetworkInfo, RewardAddress, StakeCredential},
    crypto::{Bip32PrivateKey, Bip32PublicKey},
};
use cardano_serialization_lib::{utils, Transaction};
use rand::RngCore;
use std::collections::{HashMap, HashSet};

use crate::public_key_hash::PublicKeyHash;
use crate::tx_in::TxIn;
use crate::{
    network::{NetworkEnvironment, NetworkId},
    utils::harden,
};

const MINWALLET_VERSION: &str = "2.0.0";

pub struct Minwallet {
    name: String,
    base_address: HashMap<u8, String>,
    reward_address: HashMap<u8, String>,
    pub_key_hash_derive_map: HashMap<String, Vec<u32>>,
    network_id: u8,
    encrypted_key: String,
    version: String,
    account_index: u8,
    wallet_name: String,
}

impl Minwallet {
    pub fn create(
        mnemonic: &str,
        password: &str,
        network_environment: NetworkEnvironment,
        wallet_name: &str,
    ) -> Self {
        let entropy = Mnemonic::parse(mnemonic).unwrap().to_entropy();
        let root_key = Bip32PrivateKey::from_bip39_entropy(&entropy, &[]);
        let encrypted_key = encrypt_password(password, &root_key.to_hex());
        let account_key = root_key
            .derive(harden(1852))
            .derive(harden(1815))
            .derive(harden(0));
        let public_key = account_key.to_public();
        let network_id = network_environment.to_network_id() as u8;

        let base_address = generate_base_address(&public_key);
        let reward_address = generate_reward_address(&public_key);
        let pub_key_hash_derive_map = generate_addresses(&public_key);

        Minwallet {
            name: "minwallet".to_string(),
            base_address,
            reward_address,
            network_id,
            account_index: 0,
            encrypted_key,
            pub_key_hash_derive_map,
            version: MINWALLET_VERSION.to_string(),
            wallet_name: wallet_name.to_string(),
        }
    }

    pub fn sign_tx(&self, tx: &str, password: &str) -> String {
        "".to_string()
    }

    fn get_private_keys(&self, password: &str) -> String {
        "".to_string()
    }

    fn get_transaction_from_raw(&self, raw_tx: &str) {
        let tx = Transaction::from_hex(raw_tx).unwrap();
        let tx_body = tx.body();
        let tx_hash = utils::hash_transaction(&tx_body);
        let tx_id = tx_hash.to_hex();
        let tx_size = tx.to_bytes().len();
        let fee = tx_body.fee();

        let witness_set = tx.witness_set();
        let vkey_witnesses = witness_set.vkeys();
        let mut signed_pub_key_hashes = HashSet::new();

        if let Some(vkey_witnesses) = vkey_witnesses {
            for i in 0..vkey_witnesses.len() {
                let vkey_witness = vkey_witnesses.get(i);
                let key = vkey_witness.vkey();
                let pub_key = key.public_key();
                let pub_key_hash = pub_key.hash();
                signed_pub_key_hashes.insert(pub_key_hash.to_hex());
            }
        }

        let tx_ins = TxIn::get_inputs_from_tx_raw(raw_tx);
        let tx_collateral_ins = match TxIn::get_collateral_from_tx_raw(raw_tx) {
            Some(data) => data,
            None => vec![]
        };
        let mut public_key_hashes = HashSet::new();

        for tx_in in tx_ins {

        }


        //missing_signatures -> keyHash
        let missing_signatures = vec![];
        for signature in signed_pub_key_hashes {
            let pkh = PublicKeyHash::new(signature);
            if !signed_pub_key_hashes
        }
    }
}

fn generate_addresses(public_key: &Bip32PublicKey) -> HashMap<String, Vec<u32>> {
    let mut pub_key_hash_derive_map = HashMap::new();
    let stake_key_hash = public_key
        .derive(2)
        .unwrap()
        .derive(0)
        .unwrap()
        .to_raw_key()
        .hash();
    pub_key_hash_derive_map.insert(stake_key_hash.to_hex(), vec![2, 0]);

    for i in 0..1000 {
        let receving_pub_key_hash = public_key
            .derive(0)
            .unwrap()
            .derive(i)
            .unwrap()
            .to_raw_key()
            .hash();
        let change_pub_key_hash = public_key
            .derive(1)
            .unwrap()
            .derive(i)
            .unwrap()
            .to_raw_key()
            .hash();

        pub_key_hash_derive_map.insert(receving_pub_key_hash.to_hex(), vec![0, i]);
        pub_key_hash_derive_map.insert(change_pub_key_hash.to_hex(), vec![1, i]);
    }

    pub_key_hash_derive_map
}

fn generate_reward_address(public_key: &Bip32PublicKey) -> HashMap<u8, String> {
    let stake_key_hash = public_key
        .derive(2)
        .unwrap()
        .derive(0)
        .unwrap()
        .to_raw_key()
        .hash();
    let mut reward_address = HashMap::new();

    reward_address.insert(
        NetworkId::Mainnet as u8,
        RewardAddress::new(
            NetworkInfo::mainnet().network_id(),
            &StakeCredential::from_keyhash(&stake_key_hash),
        )
        .to_address()
        .to_hex(),
    );

    reward_address.insert(
        NetworkId::Testnet as u8,
        RewardAddress::new(
            NetworkInfo::testnet_preprod().network_id(),
            &StakeCredential::from_keyhash(&stake_key_hash),
        )
        .to_address()
        .to_hex(),
    );

    reward_address
}

fn generate_base_address(public_key: &Bip32PublicKey) -> HashMap<u8, String> {
    let payment_key_hash = public_key
        .derive(0)
        .unwrap()
        .derive(0)
        .unwrap()
        .to_raw_key()
        .hash();
    let stake_key_hash = public_key
        .derive(2)
        .unwrap()
        .derive(0)
        .unwrap()
        .to_raw_key()
        .hash();
    let mut base_address = HashMap::new();

    base_address.insert(
        NetworkId::Mainnet as u8,
        BaseAddress::new(
            NetworkInfo::mainnet().network_id(),
            &StakeCredential::from_keyhash(&payment_key_hash),
            &StakeCredential::from_keyhash(&stake_key_hash),
        )
        .to_address()
        .to_hex(),
    );

    base_address.insert(
        NetworkId::Testnet as u8,
        BaseAddress::new(
            NetworkInfo::testnet_preprod().network_id(),
            &StakeCredential::from_keyhash(&payment_key_hash),
            &StakeCredential::from_keyhash(&stake_key_hash),
        )
        .to_address()
        .to_hex(),
    );

    base_address
}

fn generate_secure_string(length: usize) -> String {
    let mut bytes = vec![0u8; length];
    rand::thread_rng().fill_bytes(&mut bytes);

    // Use base64 for a compact and URL-safe representation
    let mut encoded = BASE64_STANDARD.encode(bytes);
    encoded.truncate(length);
    encoded
}

fn encrypt_password(password: &str, root_key_hex: &str) -> String {
    let password_hex = hex::encode(password);
    let salt = hex::encode(generate_secure_string(32));
    let nonce = hex::encode(generate_secure_string(12));
    encrypt_with_password(&password_hex, &salt, &nonce, root_key_hex).unwrap()
}

fn decrypt_password(password: &str, encrypted_hex: &str) -> String {
    let password_hex = hex::encode(password);
    decrypt_with_password(&password_hex, encrypted_hex).unwrap()
}

fn get_root_key_from_password(password: &str, encrypted_hex: &str) -> String {
    decrypt_password(password, encrypted_hex)
}

fn get_account_key_from_password(password: &str, encrypted_hex: &str) -> String {
    let root_key = get_root_key_from_password(password, encrypted_hex);
    get_account_key_from_root_key(&root_key)
}

fn get_account_key_from_root_key(root_key_hex: &str) -> String {
    let account_key = Bip32PrivateKey::from_bytes(root_key_hex.as_bytes())
        .unwrap()
        .derive(harden(1852))
        .derive(harden(1815))
        .derive(harden(0));
    account_key.to_hex()
}
