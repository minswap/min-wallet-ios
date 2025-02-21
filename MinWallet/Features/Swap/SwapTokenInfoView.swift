import SwiftUI
import FlowStacks


struct SwapTokenInfoView: View {
    @Environment(\.partialSheetDismiss)
    private var onDismiss
    @EnvironmentObject
    private var viewModel: SwapTokenViewModel

    var onShowToolTip: ((_ title: LocalizedStringKey, _ content: LocalizedStringKey) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Details")
                .font(.titleH5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 60)
                .padding(.top, .md)
            HStack {
                DashedUnderlineText(text: viewModel.isSwapExactIn ? "Minimum Received" : "Minimum Send", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                Spacer()
                let tokenName = viewModel.isSwapExactIn ? viewModel.tokenReceive.token.adaName : viewModel.tokenPay.token.adaName
                Text(viewModel.minimumMaximumAmount.formatNumber(suffix: tokenName, font: .labelMediumSecondary, fontColor: .colorBaseTent))
            }
            .padding(.top, .lg)
            .contentShape(.rect)
            .onTapGesture {
                onShowToolTip?("Minimum received", "Your transaction will revert if there is a large, unfavorable price movement before it is confirmed.You can adjust this by setting percentage of Slippage Tolerance")
            }
            HStack {
                DashedUnderlineText(text: "Slippage Tolerance", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                Spacer()
                Text(viewModel.swapSetting.slippageSelectedValue().formatSNumber(maximumFractionDigits: 2) + "%")
                    .font(.labelMediumSecondary)
                    .foregroundStyle(.colorBaseTent)
            }
            .padding(.top, .xl)
            .contentShape(.rect)
            .onTapGesture {
                onShowToolTip?("Slippage tolerance", "Your transaction will revert if the price changes unfavorably by more than this percentage.")
            }
            HStack {
                DashedUnderlineText(text: "Price Impact", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                Spacer()
                let priceImpact = viewModel.iosTradeEstimate?.priceImpact ?? 100
                Text(priceImpact.formatSNumber(maximumFractionDigits: 2) + "%")
                    .font(.labelMediumSecondary)
                    .foregroundStyle(.colorBaseSuccess)
            }
            .padding(.top, .xl)
            .contentShape(.rect)
            .onTapGesture {
                onShowToolTip?("Price impact", "This % indicates the potential effect your swap might have on the pool's price. A higher % suggests a more significant impact.")
            }
            HStack {
                DashedUnderlineText(text: "Liquidity Provider Fee", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                Spacer()
                let fee = viewModel.iosTradeEstimate?.lpFee?.toExact(decimal: viewModel.tokenPay.token.decimals) ?? 0
                Text(fee.formatNumber(suffix: Currency.ada.prefix, font: .labelMediumSecondary, fontColor: .colorBaseTent))
            }
            .padding(.top, .xl)
            .contentShape(.rect)
            .onTapGesture {
                onShowToolTip?("Trading fee","The trading fee is divided into two parts: one portion is distributed to liquidity providers (LPs) as a reward for supplying liquidity to the protocol, while the other portion goes to the protocol.")
            }
            /*
            HStack {
                DashedUnderlineText(text: "Batcher Fee", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                Spacer()
                Text("2 \(Currency.ada.prefix)")
                    .strikethrough()
                    .font(.labelMediumSecondary)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
                Text("1.5 \(Currency.ada.prefix)")
                    .font(.labelMediumSecondary)
                    .foregroundStyle(.colorInteractiveToneHighlight)
            }
            .padding(.top, .xl)
            .padding(.bottom, .xs)
            .contentShape(.rect)
            .onTapGesture {
                onShowToolTip?("Batcher Fee", "Fee paid for the service of off-chain Laminar batcher to process transactions.")
            }
            Text("Want a discount?")
                .font(.paragraphXSmall)
                .foregroundStyle(.colorInteractiveToneHighlight)
                .onTapGesture {
                    "https://docs.minswap.org/min-token/usdmin-tokenomics/trading-fee-discount".openURL()
                }
             */
            HStack {
                DashedUnderlineText(text: "Deposit ADA", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                Spacer()
                Text("2 \(Currency.ada.prefix)")
                    .font(.labelMediumSecondary)
                    .foregroundStyle(.colorBaseTent)
            }
            .padding(.top, .xl)
            .padding(.bottom, 40)
            .contentShape(.rect)
            .onTapGesture {
                onShowToolTip?("Deposit ADA", "This amount of ADA will be held as minimum UTxO ADA and will be returned when your orders are processed or cancelled.")
            }
            CustomButton(title: "Swap") {
                onDismiss?()
            }
            .frame(height: 56)
            .padding(.bottom, .md)
        }
        .padding(.horizontal, .xl)
        .presentSheetModifier()
    }
}


#Preview {
    VStack {
        Spacer()
        SwapTokenInfoView()
            .environmentObject(SwapTokenViewModel())
    }
}
