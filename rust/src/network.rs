pub enum NetworkId {
    Testnet = 0,
    Mainnet = 1,
}

impl NetworkId {
    pub fn from_network_environment(network_environment: NetworkEnvironment) -> Self {
        match network_environment {
            NetworkEnvironment::Mainnet => NetworkId::Mainnet,
            NetworkEnvironment::TestnetPreprod => NetworkId::Testnet,
            NetworkEnvironment::TestnetPreview => NetworkId::Testnet,
        }
    }
}

pub enum NetworkEnvironment {
    Mainnet = 764824073,
    TestnetPreprod = 1,
    TestnetPreview = 2,
}
