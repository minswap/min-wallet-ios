struct Token {
    let currencySymbol: String
    let tokenName: String
    let ticker: String
    let project: String
    let decimals: Int
    let isVerified: Bool
}

struct TokenWithPrice {
    let token: Token
    let price: Double
    let changePercent: Double
}
