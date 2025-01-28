import Foundation
import Then


struct TokenFavourite: Then {
    var dateAdded: Double = Date().timeIntervalSince1970
    var currencySymbol: String = ""
    var tokenName: String = ""
    var adaName: String = ""

    init() {}

    var uniqueID: String {
        if currencySymbol.isEmpty && tokenName.isEmpty {
            return "lovelace"
        }

        if currencySymbol.isEmpty {
            return tokenName
        }
        if tokenName.isEmpty {
            return currencySymbol
        }

        return currencySymbol + "." + tokenName
    }
}


extension TokenFavourite: Codable {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dateAdded = try container.decode(Double.self, forKey: .dateAdded)
        currencySymbol = try container.decode(String.self, forKey: .currencySymbol)
        tokenName = try container.decode(String.self, forKey: .tokenName)
        adaName = try container.decode(String.self, forKey: .adaName)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dateAdded, forKey: .dateAdded)
        try container.encode(currencySymbol, forKey: .currencySymbol)
        try container.encode(tokenName, forKey: .tokenName)
        try container.encode(adaName, forKey: .adaName)
    }

    private enum CodingKeys: String, CodingKey {
        case dateAdded
        case currencySymbol
        case tokenName
        case adaName
    }
}
