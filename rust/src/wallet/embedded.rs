use bip39::{Mnemonic, Language};
use cardano_serialization_lib::{Address, BaseAddress, Bip32PrivateKey, Credential, RewardAddress};

use crate::utils::harden;
pub struct Account {}

pub trait WalletStaticMethods {
    fn mnemonic_to_entropy(phrase: &str) -> Vec<u8> {
        let mnemonic = Mnemonic::from_phrase(&phrase, Language::English).unwrap();
        mnemonic.entropy().to_vec()
    }

    fn entropy_to_root_key(entropy: &[u8], password: &str)-> Bip32PrivateKey {
        Bip32PrivateKey::from_bip39_entropy(
            entropy,
        password.as_bytes()
        )
    }

    fn harden(index: u32) -> u32 {
        index | 0x80_00_00_00
    }
    
    fn get_account(root_key: &Bip32PrivateKey, index: u32) -> Bip32PrivateKey {
        root_key
            .derive(harden(1852)) // purpose
            .derive(harden(1815)) // coin type
            .derive(harden(index))
    }

    fn get_address(account: &Bip32PrivateKey, network_id: u8) -> Address {
        let payment_key = account.derive(0).derive(0).to_raw_key();
        let payment_key_hash = payment_key.to_public().hash();
        let payment_credential = Credential::from_keyhash(&payment_key_hash);
        
        let stake_key = account.derive(2).derive(0).to_raw_key();
        let stake_key_hash = stake_key.to_public().hash();
        let stake_credential = Credential::from_keyhash(&stake_key_hash);

        BaseAddress::new(network_id, &payment_credential, &stake_credential).to_address()
    }

    fn gen_reward_address(account: &Bip32PrivateKey, network_id: u8) -> RewardAddress {
        let stake_key = account.derive(2).derive(0).to_raw_key();
        let stake_key_hash = stake_key.to_public().hash();
        let stake_credential = Credential::from_keyhash(&stake_key_hash);

        RewardAddress::new(network_id, &stake_credential)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    struct TestWallet;

    impl WalletStaticMethods for TestWallet {}

    #[test]
    fn test_base_address() {
        let seed = String::from("detect amateur eternal elite dad kangaroo usual chase poem detail tumble amount");
        let password = String::from("helloworld");
        let entropy = TestWallet::mnemonic_to_entropy(&seed);
        let root_key = TestWallet::entropy_to_root_key(&entropy, &password);
        assert_eq!(root_key.to_bech32(), "xprv1gre69tdkhwnzsl0spaj9n9ty9gc7yx64fm29ff9hea57sd4q03xuatqlpq7qanpl3dnjzdtchx394gdk9w0c9ezaaau45c2wk5aduyht3kw7659u7gzt4qh37na0dsh66txhajlzssf27ay75s8hpdqqug7vwwy6");

        let account = TestWallet::get_account(&root_key, 0);
        let address = TestWallet::get_address(&account, 1);
        assert_eq!(address.to_bech32(None).unwrap(), "addr1q82vnh5g9epl7x8c3m0zngjtfzcjttt5gjpf8eptvjxk74397eag00jf7yvzj28v38mufm9keaygaywu0eprdwnu40hsm6eekf");

        let reward_address = TestWallet::gen_reward_address(&account, 1);
        assert_eq!(reward_address.to_address().to_bech32(None).unwrap(), "stake1uyjlv758heylzxpf9rkgna7yajmv7jywj8w8us3khf72hmcmx40fs");
    }
}
