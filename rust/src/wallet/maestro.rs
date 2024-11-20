use std::collections::HashMap;
use std::error::Error;

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

    pub async fn get_utxos(&self, address_bech32: &String) -> Result<Vec<MaestroUtxo>, Box<dyn Error>> {
        let url = format!("/addresses/{}/utxos?with_cbor=true", address_bech32);
        let response = self.get(&url).await?;
        eprintln!("Raw API Response: {}", response); // Log the raw response

        let wrapper: WrapperData<Vec<MaestroUtxo>> =
            serde_json::from_str(&response).map_err(|e| {
                eprintln!("Deserialization failed: {:?}", e);
                eprintln!("Response: {}", response);
                Box::new(e) as Box<dyn Error>
            })?;

        // Deserialize into the generic wrapper
        // let wrapper: WrapperData<Vec<MaestroUtxo>> =
        //     serde_json::from_str(&response).map_err(|e| Box::new(e) as Box<dyn Error>)?;

        // Extract the inner data
        Ok(wrapper.data)
    }
}

#[cfg(test)]
mod tests {
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

    async fn test_maestro() {
        let maestro_client = Maestro::new(
            "QlSHwIRe4Hq47kKgmFQOR0slx8lWyhiD".to_string(),
            "preprod".to_string(),
        );
        let address_bech32 = String::from("addr_test1qzneme4j4mp3rxjzygvwnafvmzqww0kqhxl50a73u6z5865zvt27s3xuclj7q6mtqd9qn8rhdv3ywhh0gvqrz0f6sgwqxfxeqt");
        let utxos = maestro_client.get_utxos(&address_bech32).await.unwrap();
        assert!(utxos.len() > 0)
    }
}
