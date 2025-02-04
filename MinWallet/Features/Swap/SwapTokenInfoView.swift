import SwiftUI
import FlowStacks


struct SwapTokenInfoView: View {
    @Environment(\.partialSheetDismiss)
    private var onDismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Details")
                .font(.titleH5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 60)
                .padding(.top, .md)
            HStack {
                DashedUnderlineText(text: "Minimum Received", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                Spacer()
                Text("1,486.35 MIN")
                    .font(.labelMediumSecondary)
                    .foregroundStyle(.colorBaseTent)
            }
            .padding(.top, .lg)
            HStack {
                DashedUnderlineText(text: "Slippage Tolerance", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                Spacer()
                Text("0.50%")
                    .font(.labelMediumSecondary)
                    .foregroundStyle(.colorBaseTent)
            }
            .padding(.top, .xl)
            HStack {
                DashedUnderlineText(text: "Price Impact", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                Spacer()
                Text("0.20%")
                    .font(.labelMediumSecondary)
                    .foregroundStyle(.colorBaseSuccess)
            }
            .padding(.top, .xl)
            HStack {
                DashedUnderlineText(text: "Liquidity Provider Fee", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                Spacer()
                Text("0.3 \(Currency.ada.prefix)")
                    .font(.labelMediumSecondary)
                    .foregroundStyle(.colorBaseTent)
            }
            .padding(.top, .xl)
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
            Text("Want a discount?")
                .font(.paragraphXSmall)
                .foregroundStyle(.colorInteractiveToneHighlight)
                .onTapGesture {
                    UIApplication.shared.open(URL(string: "https://docs.minswap.org/min-token/usdmin-tokenomics/trading-fee-discount")!, options: [:], completionHandler: nil)
                }
            HStack {
                DashedUnderlineText(text: "Deposit ADA", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                Spacer()
                Text("0.3 \(Currency.ada.prefix)")
                    .font(.labelMediumSecondary)
                    .foregroundStyle(.colorBaseTent)
            }
            .padding(.top, .xl)
            .padding(.bottom, 40)

            CustomButton(title: "Swap") {
                onDismiss?()
            }
            .frame(height: 56)
        }
        .padding(.horizontal, .xl)
        .presentSheetModifier()
    }
}


#Preview {
    VStack {
        Spacer()
        SwapTokenInfoView()
    }
}
