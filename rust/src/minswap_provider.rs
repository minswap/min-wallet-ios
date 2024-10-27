use bip39::serde::Serialize;

use crate::translucent_helpers::{TOutRef, TUTxO};

struct WalletEndpoints {
    utxo_by_tx_in: &'static str,
}

const WALLET_ENDPOINTS: WalletEndpoints = WalletEndpoints {
    utxo_by_tx_in: "/wallet/utxo/tx-in",
};

struct MinswapProvider {
    url: String,
}

impl MinswapProvider {
    fn make_post_call(&self, path: &str, body: &str) -> String {
        let client = reqwest::blocking::Client::new();
        let res = client
            .post(format!("{}/{}", self.url, path))
            .body(body.to_string())
            .send()
            .unwrap();
        res.text().unwrap()
    }

    pub fn get_utxos_by_out_ref(&self, out_refs: Vec<TOutRef>) -> Vec<TUTxO> {
        if out_refs.is_empty() {
            return vec![];
        }

        #[derive(Serialize)]
        struct TxInBody {
            #[serde(rename = "txIns")]
            tx_ins: Vec<String>,
        }

        let body = TxInBody {
            tx_ins: out_refs
                .iter()
                .map(|out_ref| format!("{}#{}", out_ref.tx_hash, out_ref.output_index))
                .collect(),
        };

        let res = self.make_post_call(
            WALLET_ENDPOINTS.utxo_by_tx_in,
            &serde_json::to_string(&body).unwrap(),
        );
        let parsed_res: Vec<String> = serde_json::from_str(&res).unwrap();

        TUTxO::from_hex(&parsed_res)
    }
}
