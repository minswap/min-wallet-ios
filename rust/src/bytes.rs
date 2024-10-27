#[derive(Clone, PartialEq)]
pub struct Bytes {
    pub bytes: Vec<u8>,
    pub hex: String,
}

impl Bytes {
    pub fn new(bytes: &[u8]) -> Self {
        Self {
            bytes: bytes.to_vec(),
            hex: hex::encode(bytes),
        }
    }

    pub fn from_hex(hex: &str) -> Self {
        Self::new(&hex::decode(hex).unwrap())
    }
}
