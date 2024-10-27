use crate::{tx_in::TxIn, utxo::Utxo};

pub struct TOutRef {
    pub tx_hash: String,
    pub output_index: u32,
}

impl TOutRef {
    pub fn from_tx_in(tx_in: &TxIn) -> Self {
        Self {
            tx_hash: format!("{:x?}", tx_in.tx_id),
            output_index: tx_in.index,
        }
    }
}

pub struct TUTxO {}

impl TUTxO {
    pub fn from_hex(utxos: &Vec<String>) -> Vec<Self> {
        for tutxo in utxos {
            let utxo = Utxo::from_hex(tutxo);
            utxo.output.value.
            if let Some(multiasset) = utxo.output.value.multiasset() {
                for i in 0..multiasset.keys().len() {
                    let key = multiasset.keys().get(i);
                    let assets = multiasset.get(&key).unwrap();
                    for name_index in 0..assets.keys().len() {
                        // TODO: Continue this
                        let asset_name = assets.keys().get(name_index);
                        if asset_name == "" {}
                        let asset = assets.get(&asset_name).unwrap();
                    }
                }
            }
        }
        vec![]
    }
}
