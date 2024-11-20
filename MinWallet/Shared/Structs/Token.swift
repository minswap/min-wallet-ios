import Foundation

struct Token {
  let currencySymbol: String
  let tokenName: String
  let ticker: String
  let project: String
  let decimals: Int
  let isVerified: Bool
}

struct TokenWithPrice: Identifiable {
  let id: UUID
  let token: Token
  let price: Double
  let changePercent: Double
}
