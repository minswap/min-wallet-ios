use bip39::{Mnemonic, Language};
use cardano_serialization_lib::Bip32PrivateKey;

pub struct Account {}

#[derive(Debug, Clone)]
pub enum EmbeddedWalletKeyType {
    Root {
        bech32: String,
    },
    Cli {
        payment: String,
        stake: Option<String>,
    },
    Mnemonic {
        words: Vec<String>,
    },
}

#[derive(Debug, Clone)]
pub struct CreateEmbeddedWalletOptions {
    pub network_id: u32,
    pub key: EmbeddedWalletKeyType,
}

pub trait WalletStaticMethods {
    fn mnemonic_to_entropy(words: Vec<&str>) -> String {
        let phrase = words.join(" ");
        let mnemonic = Mnemonic::from_phrase(&phrase, Language::English).unwrap();
        let entropy = mnemonic.entropy();
        let bip32_private_key = Bip32PrivateKey::from_bip39_entropy(entropy, &[]);
        hex::encode(bip32_private_key.as_bytes())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use hex;

    struct TestWallet;

    impl WalletStaticMethods for TestWallet {}

    #[test]
    fn test_mnemonic_to_entropy() {
        // Sample mnemonic phrase (12-word)
        let words = vec![
            "abandon", "abandon", "abandon", "abandon", "abandon", "abandon",
            "abandon", "abandon", "abandon", "abandon", "abandon", "about",
        ];

        // Expected entropy from the above mnemonic
        // For this test, ensure the expected result matches the mnemonic tools you're using.
        // For example, you can calculate it using a reliable library/tool.
        let expected_entropy_hex = "00000000000000000000000000000000";

        // Call the function
        let result = TestWallet::mnemonic_to_entropy(words);

        // Verify the result
        assert_eq!(result, expected_entropy_hex);
    }
}
