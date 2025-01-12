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
        if ticker.isBlank {
            return UserInfo.TOKEN_NAME_DEFAULT[currencySymbol] ?? tokenName.adaName ?? ""
        } else {
            return ticker
        }
    }

    //TODO: cuongnv check sau
    var amount: Double {
        0
    }

    var uniqueID: String {
        currencySymbol + "." + tokenName
    }
}
