import SwiftUI


struct TokenListItemView: View {
    let tokenWithPrice: TokenWithPrice
    let isPositive: Bool
    
    init(tokenWithPrice: TokenWithPrice) {
        self.tokenWithPrice = tokenWithPrice
        self.isPositive = tokenWithPrice.changePercent >= 0
    }
    
    var body: some View {
        HStack(spacing: .xl) {
            TokenLogoView(token: tokenWithPrice.token)
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text(tokenWithPrice.token.ticker)
                        .font(.labelMediumSecondary)
                        .foregroundStyle(.color050B18FFFFFF78)
                    Spacer()
                    Text("\(String(tokenWithPrice.price)) ₳")
                        .lineSpacing(24)
                        .font(.labelMediumSecondary)
                        .foregroundStyle(.color050B18FFFFFF78)
                }
                HStack(spacing: 0) {
                    Text(tokenWithPrice.token.project)
                        .font(.paragraphSmall)
                        .foregroundStyle(.color050B1856FFFFFF48)
                        .lineLimit(1)
                    Spacer()
                    VStack(alignment: .trailing, spacing: 0) {
                        HStack(spacing: 0) {
                            Text("\(String(abs(tokenWithPrice.changePercent)))%")
                                .font(.labelSmallSecondary)
                                .foregroundStyle(isPositive ? .color0087661ABB93 : .colorB81F29FF5C54)
                            Image(isPositive ? .icUp : .icDown)
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                    }
                }
            }
            .padding(.vertical, 12)
            .overlay(
                Rectangle().frame(height: 1).foregroundColor(.colorF5F5F61D1E24), alignment: .bottom
            )
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    VStack(spacing: 0) {
        TokenListItemView(
            tokenWithPrice: TokenWithPrice(
                id: UUID(),
                token: Token(
                    currencySymbol: "", tokenName: "", ticker: "ADA", project: "Cardano", decimals: 6,
                    isVerified: true), price: 37123.35, changePercent: 5.7))
        TokenListItemView(
            tokenWithPrice: TokenWithPrice(
                id: UUID(),
                token: Token(
                    currencySymbol: "", tokenName: "", ticker: "ADA", project: "Cardano", decimals: 6,
                    isVerified: true), price: 37123.35, changePercent: -5.7))
    }
}
