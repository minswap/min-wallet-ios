import Foundation


struct Token: Hashable {
    var currencySymbol: String = ""
    var tokenName: String = ""
    var ticker: String = ""
    var project: String = ""
    var decimals: Int = 6
    var isVerified: Bool = false
}

extension Token {
    static let sampleData = Token(currencySymbol: "", tokenName: "", ticker: "ADA", project: "Cardano", decimals: 6, isVerified: true)
}
