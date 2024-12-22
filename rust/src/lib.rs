mod crypto;
pub mod network;
mod wallet;

use crate::crypto::blake2b256;
use crate::network::NetworkEnvironment;
use crate::wallet::embedded::WalletStaticMethods;
use bip39::{Language, Mnemonic, MnemonicType};
use cardano_serialization_lib::{
    make_vkey_witness, PrivateKey, Transaction, TransactionHash, TransactionWitnessSet,
    Vkeywitnesses,
};

// *************************** EXPORT ***************************
pub struct MinWallet {
    address: String,
    network_id: u32,
    encrypted_key: String,
    account_index: u32,
}

pub fn gen_phrase(word_count: u32) -> String {
    // Match the word_count to the corresponding MnemonicType variant
    let m_type = match word_count {
        12 => MnemonicType::Words12,
        15 => MnemonicType::Words15,
        18 => MnemonicType::Words18,
        21 => MnemonicType::Words21,
        24 => MnemonicType::Words24,
        _ => panic!("Invalid word count! Must be one of: 12, 15, 18, 21, or 24."),
    };

    // Create a new randomly generated mnemonic phrase
    let mnemonic = Mnemonic::new(m_type, Language::English);

    // Get the phrase as a string
    mnemonic.phrase().to_string()
}

pub fn create_wallet(phrase: String, password: String, network_env: String) -> MinWallet {
    let network_environment = NetworkEnvironment::from_string(network_env).unwrap();
    MinWallet::create(phrase.as_str(), password.as_str(), network_environment)
}

pub fn sign_tx(wallet: MinWallet, password: String, account_index: u32, tx_raw: String) -> String {
    wallet.sign_tx(password.as_str(), account_index, tx_raw)
}
// *************************** END EXPORT ***************************

impl WalletStaticMethods for MinWallet {}

impl MinWallet {
    pub fn create(mnemonic: &str, password: &str, network_environment: NetworkEnvironment) -> Self {
        let account_index = 0;

        // Convert mnemonic to entropy
        let entropy = MinWallet::phrase_to_entropy(&mnemonic);

        // Derive root key and account key
        let root_key = MinWallet::entropy_to_root_key(&entropy);
        let account_key = MinWallet::get_account(&root_key, account_index);

        // Encrypt root key with password
        let encrypted_key = MinWallet::gen_encrypted_key(password, &root_key);

        // Derive network ID
        let network_id = network_environment.to_network_id() as u32;

        // Generate addresses
        let address = MinWallet::get_address(&account_key, network_id);

        MinWallet {
            address: address.to_bech32(None).unwrap(),
            network_id,
            account_index,
            encrypted_key,
        }
    }

    pub fn get_private_key(&self, password: &str, account_index: u32) -> PrivateKey {
        let root_key = MinWallet::get_root_key_from_password(&password, &self.encrypted_key);
        let account_key = MinWallet::get_account(&root_key, account_index);
        let payment_key = account_key.derive(0).derive(0).to_raw_key();
        PrivateKey::from_bech32(payment_key.to_bech32().as_ref()).unwrap()
    }

    pub fn sign_tx(&self, password: &str, account_index: u32, tx_raw: String) -> String {
        let private_key = &self.get_private_key(password, account_index);
        let tx = Transaction::from_hex(tx_raw.as_str()).unwrap();
        let tx_hash = TransactionHash::from(blake2b256(&tx.body().to_bytes()));
        let mut witness_set = TransactionWitnessSet::new();
        let mut v_key_witnesses = Vkeywitnesses::new();
        let v_key = make_vkey_witness(&tx_hash, private_key);
        v_key_witnesses.add(&v_key);
        witness_set.set_vkeys(&v_key_witnesses);
        witness_set.to_hex()
    }
}

uniffi::include_scaffolding!("mwrust");

#[cfg(test)]
mod tests {
    use super::*;
    use crate::crypto::hash_transaction;
    use cardano_serialization_lib::Transaction;

    #[test]
    fn test_wallet_happy_case() {
        let phrase =
            "belt change crouch decorate advice emerge tongue loop cute olympic tuna donkey";
        let password = "123456";
        let wallet = create_wallet(
            phrase.to_string(),
            password.to_string(),
            "preprod".to_string(),
        );
        assert_eq!(wallet.address, "addr_test1qp5cpdqd3n6nuaa8rr8h20lnsxzx2uxdapknyh6fryl7e32e34tccc70arj2f4m9x9zdz4vu29rzzrtszalvqzpx625s2z2338".to_string());

        let prk = wallet.get_private_key(password, 0);
        assert_eq!(prk.to_hex(), "28ceeb4ab29780c599235ceac57f28db9939ff722d71dd4ccae6298c06f4c9596bee62e48edf249344602b310231ba80883e1ecb4c7196d192af9ed48d9f9ad5");

        let tx_raw = "84a400d9010281825820b92cd85195fcf6bcbab09fbac22b0018a9aad5c7f75d85bcd4ed6538985f7f62020181825839006980b40d8cf53e77a718cf753ff381846570cde86d325f49193fecc5598d578c63cfe8e4a4d7653144d1559c5146210d70177ec00826d2a9821b00000001fa051528a3581cb4dac0cea6dcf6f951a07add2ef6114c41be3cb7b4cfddf06a2eb593a14c0014df104361707962617261191cbb581ce16c2dc8ae937e8d3790c7fd7168d7b994621ba14ca11415f39fed72a4434d494e1a0001c094444d494e7419c53e44744254431909134d0014df104341545448554841491b00000001ad9e7c03581ce4214b7cce62ac6fbba385d164df48e157eae5863521b4b67ca71d86a4582029acf586bf10c3b25c488705a542400178f9c9116f123a581d89fa8fb25ed3fb1a001d53d758203bb0079303c57812462dec9de8fb867cef8fd3768de7f12c77f6f0dd80381d0d1a00022098582044d75b06a5aafc296e094bf3a450734f739449c62183d4e3bbd50c28522afc971a00058bde58205efbe6716c317ee3a9333ca42993b2f9608a0e8a383e8b750312cf4d21970ab41a012318bc021a0002bda9031a04aae41da0f5f6";
        let tx = Transaction::from_hex(tx_raw).unwrap();
        let tx_hash = hash_transaction(&tx.body());
        assert_eq!(
            tx_hash.to_hex().as_str(),
            "7de67019c1ee101882736d4f7104f3bbeed33f0d16e30930c0f4b2f944872cff"
        );

        let witness = sign_tx(wallet, password.to_string(), 0, tx_raw.to_string());
        assert_eq!(witness.as_str(), "a100d9010281825820caef3384a369c8267801777c240bf648aa59719a31a3706113bd7cce67d477a45840e2987748dbb198c4ce6f7804a79cea2fe515e7d0730a18352394b6f8aac38d728a579a70ebcb9a0264069d139a1b911effc60e8b8c2513b690577292c8c3d80e");
    }
}
