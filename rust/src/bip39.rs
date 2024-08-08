use bip39::{Language, Mnemonic};

pub fn generate_mnemonic() -> String {
    let mut rng = bip39::rand::thread_rng();
    let m = Mnemonic::generate_in_with(&mut rng, Language::English, 24);
    m.unwrap().to_string()
}
