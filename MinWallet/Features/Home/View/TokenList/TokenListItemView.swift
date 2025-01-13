import SwiftUI
import SkeletonUI
import MinWalletAPI


struct TokenListItemView: View {
    @EnvironmentObject
    private var appSetting: AppSetting

    let token: TokenProtocol?
    let showSubPrice: Bool

    init(token: TokenProtocol?, showSubPrice: Bool = false) {
        self.token = token
        self.showSubPrice = showSubPrice
    }

    var body: some View {
        HStack(spacing: .xl) {
            TokenLogoView(currencySymbol: token?.currencySymbol, tokenName: token?.tokenName, isVerified: token?.isVerified)
                .frame(width: 28, height: 28)
            VStack(spacing: 4) {
                HStack(spacing: 0) {
                    Text(token?.ticker)
                        .font(.labelMediumSecondary)
                        .foregroundStyle(.colorBaseTent)
                    Spacer()
                    let priceValue: AttributedString = {
                        switch appSetting.currency {
                        case Currency.ada.rawValue:
                            return (token?.priceValue ?? 0).formatNumber(suffix: !showSubPrice ? Currency.ada.prefix : "")
                        default:
                            return ((token?.priceValue ?? 0) * appSetting.currencyInADA).formatNumber(prefix: !showSubPrice ? Currency.usd.prefix : "")
                        }
                    }()
                    Text(priceValue)
                        .font(.labelMediumSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                HStack(spacing: 0) {
                    Text(token?.name)
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                        .lineLimit(1)
                        .padding(.trailing, .md)
                    if !showSubPrice {
                        Spacer()
                    }
                    let percentChange: Double = token?.percentChange ?? 0

                    if !(showSubPrice && percentChange.isZero) {
                        HStack(spacing: 0) {
                            let foregroundStyle: Color = {
                                guard !percentChange.isZero else { return .colorInteractiveTentPrimarySub }
                                return percentChange > 0 ? .colorBaseSuccess : .colorBorderDangerDefault
                            }()
                            Text("\(percentChange.formatNumber)%")
                                .font(.labelSmallSecondary)
                                .foregroundStyle(foregroundStyle)
                            if !percentChange.isZero {
                                Image(percentChange > 0 ? .icUp : .icDown)
                                    .resizable()
                                    .frame(width: 16, height: 16)
                            }
                        }
                    }
                    if showSubPrice {
                        Spacer()
                        let subPrice: Double = token?.subPriceValue ?? 0
                        Text(subPrice.formatNumber(suffix: Currency.ada.prefix, font: .paragraphSmall, fontColor: .colorInteractiveTentPrimarySub))
                            .font(.paragraphSmall)
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
    @State
    var showLogo: Bool = true

    var body: some View {
        HStack(spacing: .xl) {
            if showLogo {
                TokenLogoView(currencySymbol: nil, tokenName: nil, isVerified: false)
                    .frame(width: 28, height: 28)
                    .skeleton(with: true, size: .init(width: 28, height: 28))
            }
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
        //        TokenListItemSkeletonView()
        TokenListItemView(token: TokenProtocolDefault(), showSubPrice: false)
        Spacer()
    }
    .environmentObject(AppSetting.shared)
}
