use cardano_serialization_lib::{decrypt_with_password, encrypt_with_password};
use hex::ToHex;
use rand::Rng;

mod password_encryption_parameter {
    pub const ITER: u32 = 19_162;
    pub const SALT_SIZE: usize = 32;
    pub const NONCE_SIZE: usize = 12;
    pub const KEY_SIZE: usize = 32;
    pub const TAG_SIZE: usize = 16;

    pub const METADATA_SIZE: usize = SALT_SIZE + NONCE_SIZE + TAG_SIZE;

    pub const SALT_START: usize = 0;
    pub const SALT_END: usize = SALT_START + SALT_SIZE;
    pub const NONCE_START: usize = SALT_END;
    pub const NONCE_END: usize = NONCE_START + NONCE_SIZE;
    pub const TAG_START: usize = NONCE_END;
    pub const TAG_END: usize = TAG_START + TAG_SIZE;
    pub const ENCRYPTED_START: usize = TAG_END;
}

/// Generates a random value of the given size in hexadecimal format
fn generate_random_hex(size: usize) -> String {
    let mut rng = rand::thread_rng();
    (0..size)
        .map(|_| format!("{:02x}", rng.gen::<u8>()))
        .collect()
}

/// Generates a random salt
pub fn generate_salt() -> String {
    generate_random_hex(password_encryption_parameter::SALT_SIZE)
}

/// Generates a random nonce
pub fn generate_nonce() -> String {
    generate_random_hex(password_encryption_parameter::NONCE_SIZE)
}

pub fn encrypt_password(password: &str, data: &str) -> String {
    let salt = generate_salt();
    let nonce = generate_nonce();
    let password_hex = hex::encode(password);
    encrypt_with_password(&password_hex, &salt, &nonce, &data).unwrap()
}

pub fn decrypt_password(password: &str, data: &str) -> String {
    let password_hex = hex::encode(password);
    decrypt_with_password(&password_hex, &data).unwrap()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_round_trip_encryption() {
        let password = "fMESeaTVyCklzUD";
        let data = String::from("736f6d65206461746120746f20656e6372797074");
        let encrypted_data = encrypt_password(&password, &data);
        let decrypted_data = decrypt_password(&password, &encrypted_data);
        assert_eq!(data, decrypted_data);
    }
}
