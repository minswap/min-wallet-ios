# mwrust Library

The `mwrust` namespace provides a set of tools for interacting with wallets and signing transactions. This library is designed to facilitate wallet generation, transaction signing, and related functionality in a structured and easy-to-use API.

## Features

- Generate mnemonic phrases for wallet creation.
- Create wallets with customizable phrases and passwords.
- Sign raw transactions securely using wallet credentials.

## Namespace

The library exposes the `mwrust` namespace with the following functions and types:

### Functions

#### `gen_phrase(u32 word_count) -> string`
Generates a mnemonic phrase with the specified word count.

- **Parameters**:
    - `word_count`: Number of words in the generated mnemonic phrase (e.g., 12, 15, 24).
- **Returns**:
    - A string containing the generated mnemonic phrase.

#### Example:
```cpp
string phrase = mwrust::gen_phrase(12);
```

---

#### `create_wallet(string phrase, string password, string network_env) -> MinWallet`
Creates a wallet based on the provided mnemonic phrase, password, and network environment.

- **Parameters**:
    - `phrase`: The mnemonic phrase used to derive the wallet.
    - `password`: A user-defined password for encrypting the wallet's private key.
    - `network_env`: The network environment for the wallet (e.g., `"mainnet"` or `"preprod"`).
- **Returns**:
    - A `MinWallet` object containing wallet details.

#### Example:
```cpp
MinWallet wallet = mwrust::create_wallet(
    "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about",
    "secure_password",
    "testnet"
);
```

---

#### `sign_tx(MinWallet wallet, string password, u32 account_index, string tx_raw) -> string`
Signs a raw transaction using the provided wallet.

- **Parameters**:
    - `wallet`: A `MinWallet` object containing wallet details.
    - `password`: The password used to decrypt the wallet's private key.
    - `account_index`: The account index to sign the transaction from (default `account_index = 0`).
    - `tx_raw`: The raw transaction string to be signed.
- **Returns**:
    - A signed transaction string.

#### Example:
```cpp
string signed_tx = mwrust::sign_tx(wallet, "secure_password", 0, "raw_tx_data");
```

---

### Types

#### `MinWallet`
A dictionary object containing details of a wallet.

- **Fields**:
    - `address` (`string`): The wallet's address.
    - `network_id` (`u32`): The ID of the network the wallet belongs to (e.g., `1` for mainnet).
    - `account_index` (`u32`): The account index within the wallet.
    - `encrypted_key` (`string`): The wallet's encrypted private key.

#### Example:
```cpp
MinWallet wallet = {
    "address": "addr_test1...",
    "network_id": 0,
    "account_index": 0,
    "encrypted_key": "<encrypted_data>"
};
```

## Usage Examples

### Generate a Mnemonic Phrase
```cpp
string phrase = mwrust::gen_phrase(24);
```

### Create a Wallet
```cpp
MinWallet wallet = mwrust::create_wallet(
    "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about",
    "secure_password",
    "mainnet"
);
```

### Sign a Transaction
```cpp
string signed_tx = mwrust::sign_tx(
    wallet,
    "secure_password",
    0,
    "raw_tx_data"
);
```

## Requirements
- C++ compiler
- Rust integration (if applicable for `mwrust` implementation)

## License
This library is licensed under the MIT License. See the LICENSE file for more details.

## Contributing
Contributions are welcome! Please open an issue or submit a pull request on the repository.

