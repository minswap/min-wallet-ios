use std::collections::HashMap;

use cardano_serialization_lib::utils::Value as CSLValue;

use crate::asset::{Asset, ADA};
use crate::bytes::Bytes;

#[derive(Clone)]
pub struct Value {
    pub map: HashMap<String, u64>,
}

impl Value {
    pub fn new(map: Option<HashMap<String, u64>>) -> Self {
        match map {
            Some(map) => Self { map },
            None => Self {
                map: HashMap::new(),
            },
        }
    }

    fn init_if_not_exists(&mut self, a: &Asset) {
        if !self.map.contains_key(&a.to_string()) {
            self.map.insert(a.to_string(), 0);
        }
    }

    pub fn add(&mut self, a: &Asset, x: u64) -> &mut Self {
        if x == 0 {
            return self;
        }

        self.init_if_not_exists(a);
        self.map
            .insert(a.to_string(), self.map.get(&a.to_string()).unwrap() + 1);

        self
    }

    pub fn from_hex(value: &str) -> Self {
        let value = CSLValue::from_hex(value).unwrap();
        let coin = value.coin();
        let mut initialzed_value = Value::new(None);
        let ret = initialzed_value.add(&ADA.to_owned(), coin.try_into().unwrap());
        let ma = value.multiasset();
        if let Some(ma) = ma {
            for i in 0..ma.keys().len() {
                let currency_symbol = ma.keys().get(i);
                let assets = ma.get(&currency_symbol).unwrap();

                for j in 0..assets.keys().len() {
                    let token_name = assets.keys().get(j);
                    let amount = assets.get(&token_name).unwrap();
                    let asset = Asset::new(
                        &Bytes::from_hex(&currency_symbol.to_hex()),
                        &Bytes::from_hex(&token_name.to_hex()),
                    );
                    ret.add(&asset, amount.try_into().unwrap());
                }
            }
        }

        ret.to_owned()
    }
}
