pub struct PublicKeyHash {
    pub key_hash: String,
}

impl PublicKeyHash {
    pub fn new(key_hash: String) -> Self {
        if key_hash.as_bytes().len() != 28 {
            panic!("Invalid key hash length")
        }
        PublicKeyHash { key_hash }
    }
}
