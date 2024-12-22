import Foundation


extension MinWallet: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //TODO: cuongnv
        //walletName = try container.decode(String.self, forKey: .walletName)
        address = try container.decode(String.self, forKey: .address)
        networkId = try container.decode(UInt32.self, forKey: .networkId)
        accountIndex = try container.decode(UInt32.self, forKey: .accountIndex)
        encryptedKey = try container.decode(String.self, forKey: .encryptedKey)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        //TODO: cuongnv
        //try container.encode(walletName, forKey: .walletName)
        try container.encode(address, forKey: .address)
        try container.encode(networkId, forKey: .networkId)
        try container.encode(accountIndex, forKey: .accountIndex)
        try container.encode(encryptedKey, forKey: .encryptedKey)
    }

    private enum CodingKeys: String, CodingKey {
        case walletName
        case address
        case networkId
        case accountIndex
        case encryptedKey
    }
}
