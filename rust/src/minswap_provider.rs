use crate::translucent_helpers::TOutRef;

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
}
