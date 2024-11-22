use crate::network::NetworkEnvironment;
use crate::wallet::embedded::WalletStaticMethods;
use crate::wallet::emip3::encrypt_password;
use cardano_serialization_lib::{Address, PrivateKey, RewardAddress};

const MINWALLET_VERSION: &str = "2.0.0";

pub struct Minwallet {
    name: String,
    address: Address,
    reward_address: RewardAddress,
    network_id: u8,
    encrypted_key: String,
    version: String,
    account_index: u32,
    wallet_name: String,
}

impl WalletStaticMethods for Minwallet {}

impl Minwallet {
    pub fn create(
        mnemonic: &str,
        password: &str,
        network_environment: NetworkEnvironment,
        wallet_name: &str,
    ) -> Self {
        let account_index = 0;

        // Convert mnemonic to entropy
        let entropy = Minwallet::mnemonic_to_entropy(&mnemonic);

        // Derive root key and account key
        let root_key = Minwallet::entropy_to_root_key(&entropy, &password);
        let account_key = Minwallet::get_account(&root_key, account_index);

        // Encrypt root key with password
        let encrypted_key = Minwallet::gen_encrypted_key(password, &root_key);

        // Derive network ID
        let network_id = network_environment.to_network_id() as u8;

        // Generate addresses
        let address = Minwallet::get_address(&account_key, network_id);
        let reward_address = Minwallet::gen_reward_address(&account_key, network_id);

        Minwallet {
            name: "minwallet".to_string(),
            address,
            reward_address,
            network_id,
            account_index,
            encrypted_key,
            version: MINWALLET_VERSION.to_string(),
            wallet_name: wallet_name.to_string(),
        }
    }

    pub fn get_private_key(&self, password: &str, account_index: u32) -> PrivateKey {
        let root_key = Minwallet::get_root_key_from_password(&password, &self.encrypted_key);
        let account_key = Minwallet::get_account(&root_key, account_index);
        let payment_key = account_key.derive(0).derive(0).to_raw_key();
        PrivateKey::from_bech32(payment_key.to_bech32().as_ref()).unwrap()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use cardano_serialization_lib::{make_vkey_witness, Transaction, TransactionHash, TransactionWitnessSet, Vkeywitness, Vkeywitnesses};
    use crate::crypto::blake2b256;

    #[test]
    fn test_get_private_key() {
        let password = "Minswap@123456";
        let min_wallet = Minwallet::create(
            "belt change crouch decorate advice emerge tongue loop cute olympic tuna donkey",
            &password,
            NetworkEnvironment::TestnetPreprod, "Tony"
        );
        let private_key = min_wallet.get_private_key(&password, 0);
        assert_eq!(private_key.to_hex(), String::from("f838ddcb280f7c89bf5480591a0b46b2b80602134b19179a61c1991d7639ab549009491d6b359c37f03af6422af350e2e041ecde02a734a4b9dae5a6f7a1bf69"));
    }

    #[test]
    fn test_happy_path() {
        let password = "Minswap@123456";
        let min_wallet = Minwallet::create(
            "belt change crouch decorate advice emerge tongue loop cute olympic tuna donkey",
            &password,
            NetworkEnvironment::TestnetPreprod, "Tony"
        );
        let tx_raw = "84a40081825820dee6b0848594bea01d61450e47827da762947f61ad2387ccf1f8ba629b5252d4020182825839006980b40d8cf53e77a718cf753ff381846570cde86d325f49193fecc5598d578c63cfe8e4a4d7653144d1559c5146210d70177ec00826d2a91a00989680825839006980b40d8cf53e77a718cf753ff381846570cde86d325f49193fecc5598d578c63cfe8e4a4d7653144d1559c5146210d70177ec00826d2a91a1d16ce6d021a0002917d031a048f683ca0f5f6";
        let tx = Transaction::from_hex(tx_raw).unwrap();
        let tx_hash = TransactionHash::from(blake2b256(&tx.body().to_bytes()));
        let mut witness_set = TransactionWitnessSet::new();
        let mut v_key_witness = Vkeywitnesses::new();
        let private_key = min_wallet.get_private_key(&password, 0);
        let v_key = make_vkey_witness(&tx_hash, &private_key);
        v_key_witness.add(&v_key);
        witness_set.set_vkeys(&v_key_witness);
    }
}
