use cardano_serialization_lib::{
    Address, TransactionUnspentOutput, TransactionUnspentOutputs,
};
use cardano_serialization_lib::{TransactionHash, TransactionInput, TransactionOutput};
use maestro_rust_sdk::models::addresses::Utxo as MaestroUtxo;
use maestro_rust_sdk::Maestro;

struct MaestroProvider {
    key: String,
    network: String,
}

impl MaestroProvider {
    pub fn to_csl_utxo(utxo: &MaestroUtxo) -> TransactionUnspentOutput {
        let tx_hash = TransactionHash::from_hex(utxo.tx_hash.as_str()).unwrap();
        let tx_index = utxo.index as u32;
        let tx_in = TransactionInput::new(&tx_hash, tx_index);
        let tx_out = TransactionOutput::from_hex(utxo.tx_out_cbor.as_str()).unwrap();
        TransactionUnspentOutput::new(&tx_in, &tx_out)
    }

    pub async fn get_utxos(client: &Maestro, address: &Address) -> Result<TransactionUnspentOutputs, Box<dyn std::error::Error>> {
        let bech32 = address.to_bech32(None).unwrap();
        let utxos_at_address = Maestro::utxos_at_address(&client, &bech32.as_str(), None).await;

        // Handle errors properly
        let utxos_at_address = match utxos_at_address {
            Ok(result) => result,
            Err(e) => {
                eprintln!("Error fetching UTXOs: {:?}", e);
                return Err(e);
            }
        };

        let mut csl_utxos = TransactionUnspentOutputs::new();
        for utxo in utxos_at_address.data.into_iter() {
            let csl_utxo = MaestroProvider::to_csl_utxo(&utxo);
            csl_utxos.add(&csl_utxo);
        }
        Ok(csl_utxos)
    }
}

// #[cfg(test)]
// mod tests {
//     use super::*;
//
//     #[tokio::test]
//     async fn test_maestro() {
//         let maestro_client = Maestro::new(
//             "QlSHwIRe4Hq47kKgmFQOR0slx8lWyhiD".to_string(),
//             "preprod".to_string(),
//         );
//         let address = Address::from_bech32("addr_test1qq6dyn40spwrvhgx9sk28u0lu6e2xew7hsprev409gwv6pw5p9fxve2hgwv9ce5zz86j4k82vaa5g72cs9yjpz0jspfsvdm6zz").unwrap();
//         let utxos = MaestroProvider::get_utxos(&maestro_client, &address).await.unwrap();
//         assert!(utxos.len() > 0);
//     }
// }
