import SwiftUI
import SkeletonUI
import MinWalletAPI


struct TokenListItemView: View {
    let isPositive: Bool
    let token: TokenProtocol?
    
    init(token: TokenProtocol?) {
        self.token = token
        self.isPositive = (Double(token?.priceChange24h ?? "") ?? 0) >= 0
    }

    var body: some View {
        HStack(spacing: .xl) {
            TokenLogoView(currencySymbol: token?.currencySymbol, tokenName: token?.tokenName, isVerified: token?.isVerified)
            VStack(spacing: 4) {
                HStack(spacing: 0) {
                    Text(token?.ticker)
                        .font(.labelMediumSecondary)
                        .foregroundStyle(.colorBaseTent)
                    Spacer()
                    Text("\(token?.price ?? "") ₳")
                        .lineSpacing(24)
                        .font(.labelMediumSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                HStack(spacing: 0) {
                    Text(token?.name)
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                        .lineLimit(1)
                    Spacer()
                    VStack(alignment: .trailing, spacing: 0) {
                        HStack(spacing: 0) {
                            Text("\(String(abs(token?.changePercent ?? 0)))%")
                                .font(.labelSmallSecondary)
                                .foregroundStyle(isPositive ? .colorBaseSuccess : .colorBorderDangerDefault)
                            Image(isPositive ? .icUp : .icDown)
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                    }
                }
            }
            .padding(.vertical, 14)
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
//            TokenLogoView(token: nil).skeleton(with: true, size: .init(width: 28, height: 28))
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
        SearchTokenView()
        TokenListItemSkeletonView()
    }
}
