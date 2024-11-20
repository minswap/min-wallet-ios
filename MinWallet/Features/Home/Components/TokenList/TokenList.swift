import SwiftUI

struct TokenList: View {
  let label: String
  let tokens: [TokenWithPrice]

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text(label).padding(.horizontal, 16)
        .font(.titleH6)
        .foregroundColor(.appTentPrimary)
      ScrollView {
        VStack(spacing: 0) {
          ForEach(tokens) { token in
            TokenListItem(tokenWithPrice: token)
          }
        }
      }
    }
  }
}

struct TokenList_Previews: PreviewProvider {
  static let tokens: [TokenWithPrice] = Array(
    repeating: TokenWithPrice(
      id: UUID(),
      token: Token(
        currencySymbol: "", tokenName: "", ticker: "ADA", project: "Cardano", decimals: 6,
        isVerified: true), price: 37123.35, changePercent: 5.7), count: 20)

  static var previews: some View {
    TokenList(label: "Crypto prices", tokens: tokens)
  }
}
