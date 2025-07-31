import SwiftUI
import MinWalletAPI


struct OrderHistoryItemView: View {
    @State
    var order: OrderHistory?
    
    var onCancelItem: (() -> Void)?
    
    var body: some View {
        VStack(spacing: .lg) {
            tokenView
                .padding(.top, .xl)
            HStack {
                Text(order?.name)
                    .font(.labelMediumSecondary)
                    .foregroundStyle(.colorBaseTent)
                Spacer()
                HStack(spacing: 4) {
                    Circle().frame(width: 4, height: 4)
                        .foregroundStyle(order?.status?.foregroundCircleColor ?? .clear)
                    Text(order?.status?.title)
                        .font(.paragraphXMediumSmall)
                        .foregroundStyle(order?.status?.foregroundColor ?? .colorInteractiveToneHighlight)
                }
                .padding(.horizontal, .lg)
                .padding(.vertical, .xs)
                .background(
                    RoundedRectangle(cornerRadius: BorderRadius.full).fill(order?.status?.backgroundColor ?? .colorSurfaceHighlightDefault)
                )
                .frame(height: 20)
                .lineLimit(1)
            }
            HStack(alignment: .top) {
                Text("You paid")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
                Spacer()
                let inputs = order?.inputAsset ?? []
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
                if order?.status == .cancelled {
                    Text("--")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                } else {
                    let outputs = order?.outputAsset ?? []
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
            if let source = order?.aggregatorSource {
                HStack(alignment: .top, spacing: .xs) {
                    Text("Interacted with")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    Image(source.image)
                        .fixSize(20)
                    Text(source.name)
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                }
            }
            if let order = order, let expiredAt = order.detail.expireAt, !expiredAt.isEmpty, order.status == .created {
                HStack(spacing: Spacing.md) {
                    Image(.icWarningYellow)
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text("Expires at \(expiredAt.formattedDateGMT)")
                        .lineLimit(nil)
                        .font(.paragraphXSmall)
                        .foregroundStyle(.colorInteractiveToneWarning)
                    Spacer(minLength: 0)
                }
                .padding(.md)
                .background(
                    RoundedRectangle(cornerRadius: .lg).fill(.colorSurfaceWarningDefault)
                )
                .frame(minHeight: 32)
            }
            if let order = order, order.status == .created {
                CustomButton(title: "Cancel", variant: .secondary) {
                    onCancelItem?()
                }
                .frame(height: 36)
            }
            
            Color.colorBorderPrimarySub.frame(height: 1)
        }
    }
    
    private var tokenView: some View {
        HStack(spacing: .xs) {
            HStack(spacing: -4) {
                let inputs = order?.inputAsset ?? []
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
                let outputs = order?.outputAsset ?? []
                ForEach(outputs, id: \.self) { output in
                    TokenLogoView(currencySymbol: output.currencySymbol, tokenName: output.tokenName, isVerified: output.isVerified, size: .init(width: 24, height: 24))
                }
            }
            if let version = order?.aggregatorSource?.nameVersion, !version.isBlank {
                Text(version)
                    .font(.paragraphXMediumSmall)
                    .foregroundStyle(version.foregroundColor ?? .colorInteractiveToneHighlight)
                    .padding(.horizontal, .md)
                    .padding(.vertical, .xs)
                    .background(
                        RoundedRectangle(cornerRadius: BorderRadius.full).fill(version.backgroundColor ?? .colorSurfaceHighlightDefault)
                    )
                    .frame(height: 20)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .padding(.trailing)
            }
            Spacer()
            Text(order?.detail.orderType.title)
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
