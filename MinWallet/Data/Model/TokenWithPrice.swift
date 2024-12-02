import Foundation


struct Token: Hashable {
    let currencySymbol: String
    let tokenName: String
    let ticker: String
    let project: String
    let decimals: Int
    let isVerified: Bool
}

extension Token {
    static let sampleData = Token(currencySymbol: "", tokenName: "", ticker: "ADA", project: "Cardano", decimals: 6, isVerified: true)
}
