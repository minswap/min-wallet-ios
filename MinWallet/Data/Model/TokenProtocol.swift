import SwiftUI
import Then
import MinWalletAPI


protocol TokenProtocol {
    var currencySymbol: String { get }
    var tokenName: String { get }
    var isVerified: Bool { get }
    var ticker: String { get }
    var name: String { get }
    var category: [String] { get }

    var percentChange: Double { get }

    var priceValue: Double { get }
    var subPriceValue: Double { get }
    var amount: Double { get }
    var uniqueID: String { get }
    var socialLinks: [SocialLinks: String] { get }
    var decimals: Int { get }
}

extension TokenProtocol {
    var adaName: String {
        guard ticker.isBlank else { return ticker }
        if currencySymbol == MinWalletConstant.lpToken { return "LP" }
        return UserInfo.TOKEN_NAME_DEFAULT[uniqueID] ?? tokenName.adaName ?? ""
    }

    var amount: Double {
        0
    }

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

    var isTokenADA: Bool {
        uniqueID == "lovelace"
    }
}

struct WrapTokenProtocol: Identifiable {
    let id: UUID = UUID()
    let token: TokenProtocol

    init(token: TokenProtocol) {
        self.token = token
    }
}
