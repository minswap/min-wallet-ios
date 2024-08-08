use base64::prelude::*;
use bip39::Mnemonic;
use cardano_serialization_lib::{
    crypto::Bip32PrivateKey,
    emip3::{decrypt_with_password, encrypt_with_password},
};
use rand::RngCore;

use crate::network::NetworkEnvironment;
use crate::utils::harden;

pub struct Minwallet {}

impl Minwallet {
    pub fn new(
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
        Minwallet {}
    }
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

#[cfg(test)]
mod tests {
    use super::{decrypt_password, encrypt_password, generate_secure_string};

    #[test]
    fn can_generate_secure_string_with_length() {
        let result = generate_secure_string(64);
        assert_eq!(result.bytes().len(), 64);
    }

    #[test]
    fn can_encrypt_password() {
        let password = "MyPassword@@";
        let data = "aqu23oi45ufdgsaiklojug8oasdff";
        let data_hex = hex::encode(data);
        let encrypted_hex = encrypt_password(&password, &data_hex);
        let decrypted_hex = decrypt_password(&password, &encrypted_hex);
        assert_eq!(decrypted_hex, data_hex);
    }
}
