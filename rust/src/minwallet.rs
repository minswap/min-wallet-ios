use crate::network::NetworkEnvironment;
use crate::wallet::embedded::WalletStaticMethods;
use crate::wallet::emip3::encrypt_password;
use cardano_serialization_lib::{Address, RewardAddress};

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
        let encrypted_key = encrypt_password(password, &root_key.to_hex());

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
}
