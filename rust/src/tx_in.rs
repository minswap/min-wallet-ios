use cardano_serialization_lib::{Transaction, TransactionInput};

pub struct TxIn {
    pub tx_id: Vec<u8>,
    pub index: u32,
}

impl TxIn {
    pub fn get_inputs_from_tx_raw(tx_raw: &str) -> Vec<Self> {
        let tx = Transaction::from_bytes(tx_raw.as_bytes().to_vec()).unwrap();
        let tx_body = tx.body();
        let inputs = tx_body.inputs();
        let mut tx_ins = Vec::new();
        for i in 0..inputs.len() {
            let input = inputs.get(i);
            tx_ins.push(Self::from_hex(&input.to_hex()));
        }

        tx_ins
    }

    pub fn get_collateral_from_tx_raw(tx_raw: &str) -> Option<Vec<Self>> {
        let tx = Transaction::from_bytes(tx_raw.as_bytes().to_vec()).unwrap();
        let tx_body = tx.body();
        let collateral = tx_body.collateral();

        match collateral {
            Some(collateral) => {
                let mut tx_ins = Vec::new();
                for i in 0..collateral.len() {
                    let input = collateral.get(i);
                    tx_ins.push(Self::from_hex(&input.to_hex()));
                }

                Some(tx_ins)
            }
            None => None,
        }
    }

    pub fn from_hex(input: &str) -> Self {
        let transaction_input = TransactionInput::from_hex(input).unwrap();
        let transaction_hash = transaction_input.transaction_id();
        Self {
            tx_id: transaction_hash.to_bytes(),
            index: transaction_input.index(),
        }
    }
}
