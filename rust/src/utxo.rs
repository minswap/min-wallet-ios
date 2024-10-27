use cardano_serialization_lib::utils::TransactionUnspentOutput;

use crate::{tx_in::TxIn, tx_out::TxOut};

pub struct Utxo {
    pub input: TxIn,
    pub output: TxOut,
}

impl Utxo {
    pub fn from_hex(value: &str) -> Self {
        let cls_utxo = TransactionUnspentOutput::from_hex(value).unwrap();
        let input = cls_utxo.input();
        let output = cls_utxo.output();
        Self {
            input: TxIn::from_hex(&input.to_hex()),
            output: TxOut::from_hex(&output.to_hex()),
        }
    }
}
