import Foundation
import Then
import MinWalletAPI


struct Token: Then, Hashable {
    var currencySymbol: String = ""
    var tokenName: String = ""
    var ticker: String = ""
    var project: String = ""
    var decimals: Int = 6
    var isVerified: Bool = false

    var url: URL?
}

extension Token {
    static let sampleData = Token(currencySymbol: "", tokenName: "", ticker: "ADA", project: "Cardano", decimals: 6, isVerified: true)
}


extension TopAssetsInput: Then {}
extension TopAssetsSortInput: Then {}

extension TopAssetQuery.Data.TopAssets.TopAsset {
    var changePercent: Double {
        Double(priceChange24h) ?? 0
    }
}
