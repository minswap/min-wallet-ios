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


extension TopAssetsInput: @retroactive Then {}
extension TopAssetsSortInput: @retroactive Then {}
extension AssetsInput: @retroactive Then {}
