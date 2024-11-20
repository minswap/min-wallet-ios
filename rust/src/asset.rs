use lazy_static::lazy_static;

use crate::bytes::Bytes;

#[derive(Clone, PartialEq)]
pub struct Asset {
    pub currency_symbol: Bytes,
    pub token_name: Bytes,
}

impl Asset {
    pub fn new(currency_symbol: &Bytes, token_name: &Bytes) -> Self {
        Self {
            currency_symbol: currency_symbol.clone(),
            token_name: token_name.clone(),
        }
    }

    pub fn to_string(&self) -> String {
        if *self == *ADA {
            return "lovelace".to_string();
        }

        if self.token_name.hex == "" {
            return self.currency_symbol.hex.clone();
        }

        return format!("{}.{}", self.currency_symbol.hex, self.token_name.hex);
    }
}

lazy_static! {
    pub static ref ADA: Asset = Asset::new(&Bytes::from_hex(""), &Bytes::from_hex(""));
}
