use cardano_serialization_lib::{Address, Value, TransactionOutput};

pub enum DatumSource {
    DatumHash { hash: Vec<u8> },
    InlineDatum { data: Vec<u8> },
}

pub struct TxOut {
    pub address: Address,
    pub value: Value,
    pub datum_source: Option<DatumSource>,
    pub script_ref: Option<Vec<u8>>,
}

impl TxOut {
    pub fn from_hex(out: &str) -> Self {
        let transaction_output = TransactionOutput::from_hex(out).unwrap();

        let address = transaction_output.address();
        let value = transaction_output.amount();
        let datum_hash = transaction_output.data_hash();
        let plutus_data = transaction_output.plutus_data();

        let mut datum_source: Option<DatumSource> = None;
        if let Some(plutus_data) = plutus_data {
            datum_source = Some(DatumSource::InlineDatum {
                data: plutus_data.to_bytes(),
            });
        } else if let Some(datum_hash) = datum_hash {
            datum_source = Some(DatumSource::DatumHash {
                hash: datum_hash.to_bytes(),
            })
        }

        let script_ref = transaction_output.script_ref();
        let plutus_script = match script_ref {
            None => None,
            Some(script_ref) => Some(script_ref.plutus_script()),
        };
        Self {
            address,
            value,
            datum_source,
            script_ref: match plutus_script {
                None => None,
                Some(None) => None,
                Some(Some(plutus_script)) => Some(plutus_script.to_bytes()),
            },
        }
    }
}
