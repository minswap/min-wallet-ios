import SwiftUI
import MinWalletAPI


struct OrderHistoryItemView: View {
    @State
    var wrapOrder: WrapOrderHistory? = .init()
    @State
    var order: OrderHistory?
    
    var onCancelItem: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            tokenView
                .frame(minHeight: 40)
                .padding(.top, .md)
            HStack(alignment: .top, spacing: 0) {
                Text("You paid")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
                    .padding(.trailing, .xs)
                Spacer()
                let inputs = wrapOrder?.inputAsset ?? []
                VStack(alignment: .trailing, spacing: 4) {
                    ForEach(inputs, id: \.self) { input in
                        Text(input.amount.formatNumber(suffix: input.currency, font: .labelSmallSecondary, fontColor: .colorBaseTent))
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                    }
                }
                if let extraPaid = order?.extraPaid, !extraPaid.isEmpty {
                    Text(" · \(extraPaid)")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorInteractiveToneHighlight)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                }
            }
            .frame(minHeight: 36)
            HStack(alignment: .top) {
                Text("You receive")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
                Spacer()
                if wrapOrder?.status == .cancelled {
                    Text("--")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                } else {
                    let outputs = wrapOrder?.outputAsset ?? []
                    VStack(alignment: .trailing, spacing: 4) {
                        ForEach(outputs, id: \.self) { output in
                            Text(output.amount.formatNumber(suffix: output.currency, font: .labelSmallSecondary, fontColor: .colorBaseTent))
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                        }
                    }
                }
            }
            .frame(minHeight: 36)
            HStack {
                Text("Status")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
                Spacer()
                HStack(spacing: 4) {
                    Circle().frame(width: 4, height: 4)
                        .foregroundStyle(wrapOrder?.status.foregroundCircleColor ?? .clear)
                    Text(wrapOrder?.status.title)
                        .font(.paragraphXMediumSmall)
                        .foregroundStyle(wrapOrder?.status.foregroundColor ?? .colorInteractiveToneHighlight)
                }
                .padding(.horizontal, .lg)
                .padding(.vertical, .xs)
                .background(
                    RoundedRectangle(cornerRadius: BorderRadius.full).fill(wrapOrder?.status.backgroundColor ?? .colorSurfaceHighlightDefault)
                )
                .frame(height: 20)
                .lineLimit(1)
            }
            .frame(height: 40)
            .padding(.bottom, 9)
            /*
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
            */
            Color.colorBorderPrimarySub.frame(height: 1)
        }
    }
    
    private var tokenView: some View {
        HStack(spacing: .xs) {
            let inputs = wrapOrder?.inputAsset ?? []
            if inputs.count == 1 {
                TokenLogoView(
                    currencySymbol: inputs.first?.currencySymbol,
                    tokenName: inputs.first?.tokenName,
                    isVerified: inputs.first?.isVerified,
                    size: .init(width: 24, height: 24)
                )
            } else if let first = inputs.first, let last = inputs.last {
                ZStack {
                    TokenLogoView(
                        currencySymbol: first.currencySymbol,
                        tokenName: first.tokenName,
                        isVerified: false,
                        forceVerified: true,
                        size: .init(width: 24, height: 24)
                    )
                    .mask { 
                        HalfCircleMask(isLeft: true)
                    }
                    TokenLogoView(
                        currencySymbol: last.currencySymbol,
                        tokenName: last.tokenName,
                        isVerified: false,
                        forceVerified: true,
                        size: .init(width: 24, height: 24)
                    )
                    .mask { 
                        HalfCircleMask(isLeft: false)
                    }
                }
            }
            Image(.icBack)
                .resizable()
                .rotationEffect(.degrees(180))
                .frame(width: 16, height: 16)
                .padding(.horizontal, 2)
            let outputs = wrapOrder?.outputAsset ?? []
            if outputs.count == 1 {
                TokenLogoView(
                    currencySymbol: outputs.first?.currencySymbol,
                    tokenName: outputs.first?.tokenName,
                    isVerified: outputs.first?.isVerified,
                    size: .init(width: 24, height: 24)
                )
            } else if let first = outputs.first, let last = outputs.last {
                ZStack {
                    TokenLogoView(
                        currencySymbol: first.currencySymbol,
                        tokenName: first.tokenName,
                        isVerified: false,
                        forceVerified: true,
                        size: .init(width: 24, height: 24)
                    )
                    .mask { 
                        HalfCircleMask(isLeft: true)
                    }
                    TokenLogoView(
                        currencySymbol: last.currencySymbol,
                        tokenName: last.tokenName,
                        isVerified: false,
                        forceVerified: true,
                        size: .init(width: 24, height: 24)
                    )
                    .mask { 
                        HalfCircleMask(isLeft: false)
                    }
                }
            }
            Spacer()
            Text(wrapOrder?.orderType.title)
                .font(.labelMediumSecondary)
                .foregroundStyle(.colorBaseTent)
            Text("via")
                .font(.labelMediumSecondary)
                .foregroundStyle(.colorInteractiveTentPrimarySub)
            if let source = wrapOrder?.source {
                ZStack {
                    Image(source.image)
                        .fixSize(24)
                    if wrapOrder?.orders.count != 1 {
                        Image(.icAggrsource)
                            .fixSize(16)
                            .position(x: 2, y: 2)
                    }
                }
                .frame(width: 24, height: 24)
                .padding(.leading, wrapOrder?.orders.count == 1 ? 0 : 4)
            }
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
