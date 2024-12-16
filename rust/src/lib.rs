mod crypto;
pub mod network;
mod wallet;

use crate::crypto::blake2b256;
use crate::network::NetworkEnvironment;
use crate::wallet::embedded::WalletStaticMethods;
use bip39::{Language, Mnemonic, MnemonicType};
use cardano_serialization_lib::{
    make_vkey_witness, Bip32PrivateKey, PrivateKey, Transaction, TransactionHash,
    TransactionWitnessSet, Vkeywitnesses,
};
use serde::{Deserialize, Serialize};
use std::panic;

// *************************** EXPORT ***************************
#[derive(Debug, Serialize, Deserialize)]
pub struct MinWallet {
    wallet_name: String,
    address: String,
    network_id: u32,
    encrypted_key: String,
    account_index: u32,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct EWType {
    wallet: EWWallet,
    settings: EWSettings,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct EWWallet {
    export: String,
    version: String,
    id: String,
    network_id: String,
    sign_type: String,
    root_key: EWRootKey,
    account_list: Vec<EWAccount>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct EWRootKey {
    #[serde(rename = "pub")]
    pub_key: String,
    prv: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct EWAccount {
    id: String,
    #[serde(rename = "pub")]
    pub_key: String,
    path: (u32, u32, u32),
    sign_type: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct EWSettings {
    id: String,
    network_id: String,
    name: String,
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

pub fn create_wallet(
    phrase: String,
    password: String,
    network_env: String,
    wallet_name: String,
) -> MinWallet {
    let network_environment = NetworkEnvironment::from_string(network_env).unwrap();
    MinWallet::create(
        phrase.as_str(),
        password.as_str(),
        network_environment,
        wallet_name,
    )
}

pub fn sign_tx(wallet: MinWallet, password: String, account_index: u32, tx_raw: String) -> String {
    wallet.sign_tx(password.as_str(), account_index, tx_raw)
}

pub fn change_password(
    wallet: MinWallet,
    current_password: String,
    new_password: String,
) -> MinWallet {
    // Retrieve the root key using the current password and the wallet's encrypted key
    let root_key =
        MinWallet::get_root_key_from_password(current_password.as_str(), &wallet.encrypted_key);

    // Generate a new encrypted key using the new password and the retrieved root key
    let new_encrypted_key = MinWallet::gen_encrypted_key(new_password.as_str(), &root_key);

    // Return a new MinWallet with the updated encrypted_key
    MinWallet {
        encrypted_key: new_encrypted_key,
        ..wallet // Use the struct update syntax to copy the remaining fields
    }
}

pub fn verify_password(wallet: MinWallet, password: String) -> bool {
    let result = panic::catch_unwind(|| {
        MinWallet::get_root_key_from_password(password.as_str(), &wallet.encrypted_key)
    });
    result.is_ok()
}

pub fn export_wallet(wallet: MinWallet, password: String, network_env: String) -> String {
    let network_environment = NetworkEnvironment::from_string(network_env.clone()).unwrap();
    let network_suffix = match network_environment {
        NetworkEnvironment::Mainnet => "mm",
        NetworkEnvironment::Preprod => "pm",
        NetworkEnvironment::Preview => "pm",
    };
    let root_private_key =
        MinWallet::get_root_key_from_password(password.as_str(), &wallet.encrypted_key);
    let root_pub_key = root_private_key.to_public();
    let root_account_id = root_pub_key.to_bech32().as_str()[..16].to_string();

    let account_private_key = MinWallet::get_account(&root_private_key, 0);
    let account_public_key = account_private_key.to_public();
    let account_id = account_public_key.to_bech32().as_str()[..16].to_string();

    let wallet_export = EWType {
        wallet: EWWallet {
            export: "minswap".to_string(),
            version: "1.0.0".to_string(),
            id: root_account_id.clone() + "-" + network_suffix,
            network_id: network_env.clone(),
            sign_type: "mnemonic".to_string(),
            root_key: EWRootKey {
                pub_key: root_pub_key.to_bech32(),
                prv: root_private_key.to_hex(),
            },
            account_list: vec![EWAccount {
                id: account_id,
                pub_key: account_public_key.to_bech32(),
                path: (1852, 1815, 0),
                sign_type: "mnemonic".to_string(),
            }],
        },
        settings: EWSettings {
            id: root_account_id + "-" + network_suffix,
            network_id: network_env.clone(),
            name: wallet.wallet_name.clone(),
        },
    };
    serde_json::to_string(&wallet_export).unwrap()
}

pub fn get_wallet_name_from_export_wallet(data: String) -> String {
    let wallet_export: EWType = serde_json::from_str(data.as_str()).unwrap();
    wallet_export.settings.name
}

pub fn import_wallet(data: String, password: String, wallet_name: String) -> MinWallet {
    let wallet_export: EWType = serde_json::from_str(data.as_str()).unwrap();
    let root_key_hex = wallet_export.wallet.root_key.prv;
    let root_key = Bip32PrivateKey::from_hex(root_key_hex.as_str()).unwrap();
    let account_index = 0;
    let account_key = MinWallet::get_account(&root_key, account_index);

    // Encrypt root key with password
    let encrypted_key = MinWallet::gen_encrypted_key(password.as_str(), &root_key);

    // Derive network ID
    let network_env = wallet_export.wallet.network_id;
    let network_environment = NetworkEnvironment::from_string(network_env).unwrap();
    let network_id = network_environment.to_network_id() as u32;

    // Generate addresses
    let address = MinWallet::get_address(&account_key, network_id);

    MinWallet {
        wallet_name,
        address: address.to_bech32(None).unwrap(),
        network_id,
        account_index,
        encrypted_key,
    }
}
// *************************** END EXPORT ***************************

impl WalletStaticMethods for MinWallet {}

impl MinWallet {
    pub fn create(
        mnemonic: &str,
        password: &str,
        network_environment: NetworkEnvironment,
        wallet_name: String,
    ) -> Self {
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
            wallet_name,
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
    fn test_export_wallet() {
        let phrase =
            "belt change crouch decorate advice emerge tongue loop cute olympic tuna donkey";
        let password = "Minswap@123456";
        let wallet_name = "My MinWallet".to_string();
        let wallet = create_wallet(
            phrase.to_string(),
            password.to_string(),
            "preprod".to_string(),
            wallet_name.clone(),
        );
        let old_prk = wallet.get_private_key(password, 0);
        let old_wallet_name = wallet.wallet_name.clone();
        let old_address = wallet.address.clone();
        let export_wallet_data = export_wallet(wallet, password.to_string(), "preprod".to_string());

        let round_trip_wallet =
            import_wallet(export_wallet_data, password.to_string(), wallet_name);

        assert_eq!(old_wallet_name, round_trip_wallet.wallet_name);
        assert_eq!(old_address, round_trip_wallet.address);

        let new_prk = round_trip_wallet.get_private_key(password, 0);
        assert_eq!(old_prk.to_hex(), new_prk.to_hex());
    }
    #[test]
    fn test_verify_password() {
        let phrase =
            "belt change crouch decorate advice emerge tongue loop cute olympic tuna donkey";
        let password = "123456";
        let wallet = create_wallet(
            phrase.to_string(),
            password.to_string(),
            "preprod".to_string(),
            "My MinWallet".to_string(),
        );
        let is_correct = verify_password(wallet, "Wrong Password".to_string());
        assert_eq!(is_correct, false);
    }
    #[test]
    fn test_change_password() {
        let phrase =
            "belt change crouch decorate advice emerge tongue loop cute olympic tuna donkey";
        let password = "123456";
        let wallet = create_wallet(
            phrase.to_string(),
            password.to_string(),
            "preprod".to_string(),
            "My MinWallet".to_string(),
        );
        let private_key_1 = wallet.get_private_key(password, 0);

        let new_password = String::from("Minswap@123456");
        let new_wallet = change_password(wallet, password.to_string(), new_password.clone());
        let private_key_2 = new_wallet.get_private_key(new_password.as_str(), 0);
        assert_eq!(private_key_1.to_hex(), private_key_2.to_hex());
    }
    #[test]
    fn test_wallet_happy_case() {
        let phrase =
            "belt change crouch decorate advice emerge tongue loop cute olympic tuna donkey";
        let password = "123456";
        let wallet = create_wallet(
            phrase.to_string(),
            password.to_string(),
            "preprod".to_string(),
            "My MinWallet".to_string(),
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
