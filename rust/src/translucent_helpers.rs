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
