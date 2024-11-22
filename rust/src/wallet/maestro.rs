use std::collections::HashMap;
use std::error::Error;

use cardano_serialization_lib::Address;
use cardano_serialization_lib::TransactionHash;
use cardano_serialization_lib::TransactionInput;
use cardano_serialization_lib::TransactionOutput;
use cardano_serialization_lib::TransactionUnspentOutput;
use cardano_serialization_lib::TransactionUnspentOutputs;
use reqwest::RequestBuilder;
use serde::Deserialize;
use serde::Serialize;

#[derive(Deserialize, Debug, Clone)]
pub struct ClientConfig {
    pub version: String,
}

#[derive(Deserialize, Debug, Clone)]
pub struct Config {
    pub client: ClientConfig,
}

impl Config {
    pub fn get_config() -> Config {
        Config {
            client: ClientConfig {
                version: "v1".to_string(),
            },
        }
    }
}

pub struct Maestro {
    api_key: String,
    http_client: reqwest::Client,
    pub base_url: String,
}

impl Maestro {
    pub fn new(api_key: String, network: String) -> Self {
        let cfg = Config::get_config();
        let base_url = format!(
            "https://{}.gomaestro-api.org/{}",
            &network, &cfg.client.version
        );
        let http_client = reqwest::Client::builder()
            .timeout(std::time::Duration::from_secs(300))
            .build()
            .expect("Failed to create HTTP client");

        Maestro {
            api_key,
            http_client,
            base_url,
        }
    }

    async fn send_request(
        &self,
        req: RequestBuilder,
        response_body: &mut String,
    ) -> Result<(), Box<dyn std::error::Error>> {
        let req = req
            .header("Accept", "application/json")
            .header("api-key", &self.api_key)
            .build()?;

        let response = self.http_client.execute(req).await?;

        if response.status().is_success() {
            *response_body = response.text().await?;
            Ok(())
        } else {
            Err(format!("Error: {}", response.status()).into())
        }
    }

    pub async fn get(&self, url: &str) -> Result<String, Box<dyn std::error::Error>> {
        let req = self.http_client.get(format!("{}{}", &self.base_url, url));
        let mut response_body = String::new();
        self.send_request(req, &mut response_body).await?;
        Ok(response_body)
    }

    pub async fn post<T: Serialize>(
        &self,
        url: &str,
        body: T,
    ) -> Result<String, Box<dyn std::error::Error>> {
        let json_body = serde_json::to_string(&body)?;

        let req = self
            .http_client
            .post(format!("{}{}", &self.base_url, url))
            .header("Content-Type", "application/json")
            .body(json_body);

        let mut response_body = String::new();
        self.send_request(req, &mut response_body).await?;
        Ok(response_body)
    }
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct OperationalCertificate {
    pub hot_vkey: String,
    pub sequence_number: i64,
    pub kes_period: i64,
    pub kes_signature: String,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct LastUpdated {
    timestamp: String,
    block_hash: String,
    block_slot: i64,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct TotalExUnits {
    pub mem: i64,
    pub steps: i64,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct LatestBlockData {
    pub hash: String,
    pub height: i64,
    pub timestamp: String,
    pub epoch: i64,
    pub epoch_slot: i64,
    pub absolute_slot: i64,
    pub block_producer: String,
    pub confirmations: i64,
    pub tx_hashes: Vec<String>,
    pub total_fees: i64,
    pub total_ex_units: TotalExUnits,
    pub script_invocations: i32,
    pub size: i32,
    pub previous_block: String,
    pub next_block: Option<String>,
    pub total_output_lovelace: String,
    pub era: String,
    pub protocol_version: Vec<i32>,
    pub vrf_key: String,
    pub operational_certificate: OperationalCertificate,
}

#[derive(Deserialize, Debug, Clone)]
pub struct Asset {
    pub amount: i64,
    pub unit: String,
}

#[derive(Deserialize, Debug, Clone)]
pub struct ReferenceScript {
    pub bytes: String,
    pub hash: String,
    pub json: Option<HashMap<String, serde_json::Value>>,
    pub r#type: String,
}

#[derive(Deserialize, Debug, Clone)]
pub struct MaestroUtxo {
    pub address: String,
    pub assets: Vec<Asset>,
    pub datum: Option<HashMap<String, serde_json::Value>>,
    pub index: i64,
    pub reference_script: Option<ReferenceScript>,
    pub tx_hash: String,
    #[serde(alias = "txout_cbor")]
    pub tx_out_cbor: String,
    pub slot: Option<i64>,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct WrapperData<T> {
    pub data: T,
    pub last_updated: Option<LastUpdated>,
    pub next_cursor: Option<String>,
}

impl Maestro {
    pub async fn get_latest_block(&self) -> Result<LatestBlockData, Box<dyn Error>> {
        let url = String::from("/blocks/latest");
        let response = self.get(&url).await?;

        // Deserialize into the generic wrapper
        let wrapper: WrapperData<LatestBlockData> =
            serde_json::from_str(&response).map_err(|e| Box::new(e) as Box<dyn Error>)?;

        // Extract the inner data
        Ok(wrapper.data)
    }

    pub async fn get_utxos(
        &self,
        address_bech32: &String,
    ) -> Result<Vec<MaestroUtxo>, Box<dyn Error>> {
        let url = format!("/addresses/{}/utxos?with_cbor=true", address_bech32);
        let response = self.get(&url).await?;
        let wrapper: WrapperData<Vec<MaestroUtxo>> =
            serde_json::from_str(&response).map_err(|e| {
                eprintln!("Deserialization failed: {:?}", e);
                eprintln!("Response: {}", response);
                Box::new(e) as Box<dyn Error>
            })?;
        Ok(wrapper.data)
    }

    pub async fn submit_tx(&self, tx_cbor: &Vec<u8>) -> Result<String, Box<dyn Error>> {
        let url = "/txmanager";
        let req = self
            .http_client
            .post(format!("{}{}", &self.base_url, url))
            .header("Content-Type", "application/cbor")
            .header("Accept", "text/plain")
            .header("api-key", &self.api_key)
            .body(tx_cbor.clone())
            .build()?;

        let response = self.http_client.execute(req).await?;
        // Clone the status before consuming the response body
        let status = response.status();
        let response_body = response.text().await.unwrap_or_else(|_| "Failed to read response body".to_string());

        if status.is_success() {
            Ok(response_body)
        } else {
            eprintln!("Error | Status = {}, Body = {}", status, response_body);
            Err(format!("Error | Status = {}, Body = {}", status, response_body).into())
        }
    }

    pub fn to_csl_utxo(&self, utxo: &MaestroUtxo) -> TransactionUnspentOutput {
        let tx_hash = TransactionHash::from_hex(utxo.tx_hash.as_str()).unwrap();
        let tx_index = utxo.index as u32;
        let tx_in = TransactionInput::new(&tx_hash, tx_index);
        let tx_out = TransactionOutput::from_hex(utxo.tx_out_cbor.as_str()).unwrap();
        TransactionUnspentOutput::new(&tx_in, &tx_out)
    }

    pub async fn get_csl_utxos(
        &self,
        address: &Address,
    ) -> Result<TransactionUnspentOutputs, Box<dyn Error>> {
        let bech32 = address.to_bech32(None).map_err(|e| {
            eprintln!("Failed to convert address to Bech32: {:?}", e);
            e
        })?;

        let maestro_utxos = self.get_utxos(&bech32).await.map_err(|e| {
            eprintln!("Failed to fetch UTXOs: {:?}", e);
            e
        })?;

        let mut csl_utxos = TransactionUnspentOutputs::new();
        for utxo in maestro_utxos.into_iter() {
            let csl_utxo = self.to_csl_utxo(&utxo);
            csl_utxos.add(&csl_utxo);
        }

        Ok(csl_utxos)
    }
}

#[cfg(test)]
mod tests {
    use cardano_serialization_lib::Transaction;
    use super::*;

    #[tokio::test]
    async fn test_get_latest_block() {
        let maestro_client = Maestro::new(
            "QlSHwIRe4Hq47kKgmFQOR0slx8lWyhiD".to_string(),
            "preprod".to_string(),
        );
        let data = maestro_client.get_latest_block().await.unwrap();
        assert!(data.height > 0);
    }

    #[tokio::test]
    async fn test_get_utxos() {
        let maestro_client = Maestro::new(
            "QlSHwIRe4Hq47kKgmFQOR0slx8lWyhiD".to_string(),
            "preprod".to_string(),
        );
        let address_bech32 = String::from("addr_test1qzneme4j4mp3rxjzygvwnafvmzqww0kqhxl50a73u6z5865zvt27s3xuclj7q6mtqd9qn8rhdv3ywhh0gvqrz0f6sgwqxfxeqt");
        let utxos = maestro_client.get_utxos(&address_bech32).await.unwrap();
        assert!(utxos.len() > 0)
    }

    #[tokio::test]
    async fn test_get_csl_utxos() {
        let maestro_client = Maestro::new(
            "QlSHwIRe4Hq47kKgmFQOR0slx8lWyhiD".to_string(),
            "preprod".to_string(),
        );
        let address = Address::from_bech32("addr_test1qzneme4j4mp3rxjzygvwnafvmzqww0kqhxl50a73u6z5865zvt27s3xuclj7q6mtqd9qn8rhdv3ywhh0gvqrz0f6sgwqxfxeqt").unwrap();
        let csl_utxos = maestro_client.get_csl_utxos(&address).await.unwrap();
        assert!(csl_utxos.len() > 0);
    }

    #[tokio::test]
    #[ignore]
    async fn test_submit_tx() {
        let maestro_client = Maestro::new(
            "QlSHwIRe4Hq47kKgmFQOR0slx8lWyhiD".to_string(),
            "preprod".to_string(),
        );
        let tx_raw = "84a300818258203cc12ff1e7e02a953ce2dbe2c3e4edf5fc516c64322778a123e547dbf1886cfc010182825839006980b40d8cf53e77a718cf753ff381846570cde86d325f49193fecc5598d578c63cfe8e4a4d7653144d1559c5146210d70177ec00826d2a91a00989680825839006980b40d8cf53e77a718cf753ff381846570cde86d325f49193fecc5598d578c63cfe8e4a4d7653144d1559c5146210d70177ec00826d2a9821b00000001c9cd8f35a2581ce16c2dc8ae937e8d3790c7fd7168d7b994621ba14ca11415f39fed72a2434d494e1a00019ae2444d494e741a00018a7b581ce4214b7cce62ac6fbba385d164df48e157eae5863521b4b67ca71d86a258203bb0079303c57812462dec9de8fb867cef8fd3768de7f12c77f6f0dd80381d0d1a00022098582044d75b06a5aafc296e094bf3a450734f739449c62183d4e3bbd50c28522afc971a000428e7021a001eab58a10081825820caef3384a369c8267801777c240bf648aa59719a31a3706113bd7cce67d477a4584090363e91ee07de04952e818bbc67cbd24501c78ced75497b48a6e76e8a9993e33dff2508d319799985643eb7b75e8b4e04a7975cea43da96463378ef6179c30bf5f6";
        let tx = Transaction::from_hex(&tx_raw).unwrap();
        let tx_cbor = tx.to_bytes();
        let result = maestro_client.submit_tx(&tx_cbor).await.unwrap();
    }
}
