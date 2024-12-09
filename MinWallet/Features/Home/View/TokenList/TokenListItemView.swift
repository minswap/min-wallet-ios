import SwiftUI
import SkeletonUI


struct TokenListItemView: View {
    let tokenWithPrice: TokenWithPrice?
    let isPositive: Bool

    init(tokenWithPrice: TokenWithPrice?) {
        self.tokenWithPrice = tokenWithPrice
        self.isPositive = (tokenWithPrice?.changePercent ?? 0) >= 0
    }

    var body: some View {
        HStack(spacing: .xl) {
            TokenLogoView(token: tokenWithPrice?.token)
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text(tokenWithPrice?.token.ticker)
                        .font(.labelMediumSecondary)
                        .foregroundStyle(.colorBaseTent)
                    Spacer()
                    Text("\(String(tokenWithPrice?.price ?? 0)) ₳")
                        .lineSpacing(24)
                        .font(.labelMediumSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                HStack(spacing: 0) {
                    Text(tokenWithPrice?.token.project)
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                        .lineLimit(1)
                    Spacer()
                    VStack(alignment: .trailing, spacing: 0) {
                        HStack(spacing: 0) {
                            Text("\(String(abs(tokenWithPrice?.changePercent ?? 0)))%")
                                .font(.labelSmallSecondary)
                                .foregroundStyle(isPositive ? .colorBaseSuccess : .colorBorderDangerDefault)
                            Image(isPositive ? .icUp : .icDown)
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                    }
                }
            }
            .padding(.vertical, 12)
            .overlay(
                Rectangle().frame(height: 1).foregroundColor(.colorBorderItem), alignment: .bottom
            )
        }
        .padding(.horizontal, 16)
    }
}

struct TokenListItemSkeletonView: View {
    var body: some View {
        HStack(spacing: .xl) {
            TokenLogoView(token: nil).skeleton(with: true, size: .init(width: 28, height: 28))
            VStack(spacing: 4) {
                HStack(spacing: 0) {
                    Text("")
                        .font(.labelMediumSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                .skeleton(with: true)
                .frame(height: 20)
                HStack(spacing: 0) {
                    Text("")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                        .lineLimit(1)
                }
                .skeleton(with: true)
                .frame(height: 20)
            }
            .padding(.vertical, 12)
            .overlay(
                Rectangle().frame(height: 1).foregroundColor(.colorBorderItem), alignment: .bottom
            )
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    VStack(spacing: 0) {
        TokenListItemSkeletonView()
        TokenListItemView(
            tokenWithPrice: TokenWithPrice(
                id: UUID(),
                token: Token(
                    currencySymbol: "",
                    tokenName: "",
                    ticker: "ADA",
                    project: "Cardano",
                    decimals: 6,
                    isVerified: true
                ),
                price: 37123.35,
                changePercent: 5.7
            )
        )
        TokenListItemView(
            tokenWithPrice: TokenWithPrice(
                id: UUID(),
                token: Token(
                    currencySymbol: "",
                    tokenName: "",
                    ticker: "ADA",
                    project: "Cardano",
                    decimals: 6,
                    isVerified: true
                ),
                price: 37123.35,
                changePercent: -5.7
            )
        )
    }
}
