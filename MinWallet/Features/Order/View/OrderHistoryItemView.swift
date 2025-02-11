import SwiftUI
import MinWalletAPI


struct OrderHistoryItemView: View {
    @State
    var order: OrderHistoryQuery.Data.Orders.WrapOrder?

    var body: some View {
        VStack(spacing: .lg) {
            tokenView
                .padding(.top, .xl)
            HStack {
                Text(order?.detail.name)
                    .font(.labelMediumSecondary)
                    .foregroundStyle(.colorBaseTent)
                Spacer()
                HStack(spacing: 4) {
                    Circle().frame(width: 4, height: 4)
                        .foregroundStyle(order?.order?.status.value?.foregroundCircleColor ?? .clear)
                    Text(order?.order?.status.value?.title)
                        .font(.paragraphXMediumSmall)
                        .foregroundStyle(order?.order?.status.value?.foregroundColor ?? .colorInteractiveToneHighlight)
                }
                .padding(.horizontal, .lg)
                .padding(.vertical, .xs)
                .background(
                    RoundedRectangle(cornerRadius: BorderRadius.full).fill(order?.order?.status.value?.backgroundColor ?? .colorSurfaceHighlightDefault)
                )
                .frame(height: 20)
                .lineLimit(1)
            }
            HStack(alignment: .top) {
                Text("You paid")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
                Spacer()
                let inputs = order?.detail.inputs ?? []
                VStack(alignment: .trailing, spacing: 4) {
                    ForEach(inputs, id: \.self) { input in
                        Text(input.amount.formatNumber(suffix: input.currency, font: .labelSmallSecondary, fontColor: .colorBaseTent))
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                    }
                }
            }
            HStack(alignment: .top) {
                Text("You receive")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
                Spacer()
                if order?.order?.status == .cancelled {
                    Text("--")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                } else {
                    let outputs = order?.detail.outputs ?? []
                    VStack(alignment: .trailing, spacing: 4) {
                        ForEach(outputs, id: \.self) { output in
                            if output.amount == .zero {
                                Text("--")
                                    .font(.labelSmallSecondary)
                                    .foregroundStyle(.colorBaseTent)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                            } else {
                                Text(output.amount.formatNumber(suffix: output.currency, font: .labelSmallSecondary, fontColor: .colorBaseTent))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                            }
                        }
                    }
                }
            }
            if let order = order, let warningContent = order.overSlippageWarning, order.order?.status.value == .created {
                HStack(spacing: Spacing.md) {
                    Image(.icWarningYellow)
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text(warningContent)
                        .lineLimit(nil)
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveToneWarning)
                }
                .padding(.md)
                .background(
                    RoundedRectangle(cornerRadius: .lg).fill(.colorSurfaceWarningDefault)
                )
                .frame(minHeight: 32)
                /*
                HStack(spacing: .xl) {
                    CustomButton(title: "Cancel", variant: .secondary) {

                    }
                    .frame(height: 36)
                    CustomButton(title: "Update") {

                    }
                    .frame(height: 36)
                }
                 */
            }
            Color.colorBorderPrimarySub.frame(height: 1)
        }
    }

    private var tokenView: some View {
        HStack(spacing: .xs) {
            HStack(spacing: -4) {
                let inputs = order?.detail.inputs ?? []
                ForEach(inputs, id: \.self) { input in
                    TokenLogoView(currencySymbol: input.currencySymbol, tokenName: input.tokenName, isVerified: input.isVerified, size: .init(width: 24, height: 24))
                }
            }
            Image(.icBack)
                .resizable()
                .rotationEffect(.degrees(180))
                .frame(width: 16, height: 16)
                .padding(.horizontal, 2)
            HStack(spacing: -4) {
                let outputs = order?.detail.outputs ?? []
                ForEach(outputs, id: \.self) { output in
                    TokenLogoView(currencySymbol: output.currencySymbol, tokenName: output.tokenName, isVerified: output.isVerified, size: .init(width: 24, height: 24))
                }
            }
            Text(order?.order?.type.value?.title)
                .font(.paragraphXMediumSmall)
                .foregroundStyle(order?.order?.type.value?.foregroundColor ?? .colorInteractiveToneHighlight)
                .padding(.horizontal, .md)
                .padding(.vertical, .xs)
                .background(
                    RoundedRectangle(cornerRadius: BorderRadius.full).fill(order?.order?.type.value?.backgroundColor ?? .colorSurfaceHighlightDefault)
                )
                .frame(height: 20)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .padding(.trailing)
            Spacer()
            Text(order?.order?.action.value?.title)
                .font(.labelMediumSecondary)
                .foregroundStyle(.colorBaseTent)
        }
    }
}

#Preview {
    VStack {
        OrderHistoryView()
            .padding(.horizontal, .xl)
        Spacer()
    }

}
