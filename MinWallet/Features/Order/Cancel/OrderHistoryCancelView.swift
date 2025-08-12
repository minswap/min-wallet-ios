import SwiftUI


struct OrderHistoryCancelView: View {
    @Environment(\.partialSheetDismiss)
    private var onDismiss
    
    @Binding
    var orders: [OrderHistory]
    @Binding
    var orderSelected: [String: OrderHistory]
    @Binding
    var orderCanSelect: [String: OrderHistory]
    
    var onCancelOrder: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Cancel Orders")
                .font(.titleH5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 60)
                .padding(.horizontal, .xl)
            if orders.count != 1 {
                HStack(alignment: .top, spacing: Spacing.md) {
                    Image(.icWarningYellow)
                        .resizable()
                        .frame(width: 16, height: 16)
                    VStack(alignment: .leading, spacing: .xs) {
                        Text("Read it before cancelling")
                            .font(.paragraphSemi)
                            .lineLimit(nil)
                            .foregroundStyle(.colorInteractiveToneWarning)
                        HStack(alignment: .top) {
                            Circle().frame(width: 4, height: 4)
                                .foregroundStyle(.colorInteractiveToneWarning)
                                .padding(.top, 6)
                            Text("The service fee will be refunded if no split has been filled")
                                .font(.paragraphXSmall)
                                .lineLimit(nil)
                                .foregroundStyle(.colorInteractiveToneWarning)
                        }
                        HStack(alignment: .top) {
                            Circle().frame(width: 4, height: 4)
                                .foregroundStyle(.colorInteractiveToneWarning)
                                .padding(.top, 6)
                            Text("You can cancel only 1 type per time - p1, p2")
                                .font(.paragraphXSmall)
                                .lineLimit(nil)
                                .foregroundStyle(.colorInteractiveToneWarning)
                        }
                    }
                }
                .padding(.xl)
                .frame(maxWidth: .infinity, minHeight: 32, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: .xl).fill(.colorSurfaceWarningDefault)
                )
                .padding(.horizontal, .xl)
            }
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(Array(orders.enumerated()), id: \.offset) { index, order in
                        let isSelected: Binding<Bool> = .constant(orderSelected[order.id] != nil)
                        let isCanSelect: Binding<Bool> = .constant(orderCanSelect[order.id] != nil)
                        OrderHistoryItemStatusView(
                            number: index + 1,
                            isShowStatus: false,
                            isShowSelected: true,
                            isSelected: isSelected,
                            isCanSelect: isCanSelect,
                            order: order
                        )
                        .padding(.horizontal, .xl)
                        .contentShape(.rect)
                        .onTapGesture {
                            guard orderCanSelect[order.id] != nil else { return }
                            if orderSelected[order.id] == nil {
                                orderSelected[order.id] = order
                            } else {
                                orderSelected.removeValue(forKey: order.id)
                            }
                            orderCanSelect = updateSelectableOrders(orders, selected: orderSelected)
                        }
                    }
                }
                .padding(.top, .xl)
            }
            Spacer(minLength: 0)
            HStack(spacing: .xl) {
                CustomButton(title: "Cancel", variant: .secondary) {
                    onDismiss?()
                }
                .frame(height: 56)
                CustomButton(
                    title: "Confirm",
                    variant: .other(
                        textColor: .colorBaseTent,
                        backgroundColor: .colorInteractiveDangerDefault,
                        borderColor: .clear,
                        textColorDisable: .colorSurfaceDangerPressed,
                        backgroundColorDisable: .colorSurfaceDanger
                    )
                ) {
                    guard !orderSelected.isEmpty else { return }
                    
                    onDismiss?()
                    onCancelOrder?()
                }
                .frame(height: 56)
            }
            .padding(.top, 24)
            .padding(.horizontal, .xl)
            .padding(.bottom, .md)
        }
        .frame(height: (UIScreen.current?.bounds.height ?? 0) * 0.8)
        .presentSheetModifier()
    }
    
    private func updateSelectableOrders(_ orders: [OrderHistory], selected: [String: OrderHistory]) -> [String: OrderHistory] {
        let selectedCount = selected.count
        let selectedVersions = Set(selected.map({ _, value in value }).compactMap { plutusVersion($0.protocolSource) })
        let splashSelectedCount = selected.map({ (key, value: OrderHistory) in value })
            .filter {
                guard let protocolSource = $0.protocolSource else { return false }
                return SPLASH_ORDERS.contains(protocolSource)
            }
            .count
        
        var orderCanSelect: [String: OrderHistory] = [:]
        
        orders.forEach { order in
            var canSelect = true
            
            if selected[order.id] != nil {
                canSelect = true
            } else if selectedCount >= 6 {
                canSelect = false
            } else if selectedVersions.count > 1 {
                canSelect = false
            } else if let ver = plutusVersion(order.protocolSource),
                let selVer = selectedVersions.first,
                ver != selVer
            {
                canSelect = false
            } else if let protocolSource = order.protocolSource, SPLASH_ORDERS.contains(protocolSource),
                splashSelectedCount >= 1
            {
                canSelect = false
            } else {
                canSelect = true
            }
            
            if canSelect {
                orderCanSelect[order.id] = order
            }
        }
        return orderCanSelect
    }
    
    private let PLUTUS_V1: Set<AggregatorSource> = [
        .Minswap, .SundaeSwap, .VyFinance, .WingRiders,
    ]

    private let PLUTUS_V2: Set<AggregatorSource> = [
        .MinswapStable, .MinswapV2, .MuesliSwap, .Spectrum, .Splash, .SplashStable,
        .SundaeSwapV3, .WingRidersStableV2, .WingRidersV2,
    ]

    private let SPLASH_ORDERS: Set<AggregatorSource> = [
        .Splash, .SplashStable, .Spectrum,
    ]

    private func plutusVersion(_ src: AggregatorSource?) -> Int? {
        guard let src else { return nil }
        if PLUTUS_V1.contains(src) { return 1 }
        if PLUTUS_V2.contains(src) { return 2 }
        return nil
    }
}

#Preview {
    VStack {
        OrderHistoryCancelView(orders: .constant([]), orderSelected: .constant([:]), orderCanSelect: .constant([:]))
    }
}


struct OrderHistoryItemStatusView: View {
    @State
    var number: Int = 0
    @State
    var isShowStatus: Bool = true
    @State
    var isShowSelected: Bool = false
    @Binding
    var isSelected: Bool
    @Binding
    var isCanSelect: Bool
    @State
    var order: OrderHistory = .init()
    
    var body: some View {
        VStack(alignment: .leading, spacing: .xl) {
            HStack(alignment: .center) {
                Text("#\(number)")
                    .font(.labelSmallSecondary)
                    .foregroundStyle(.colorInteractiveToneHighlight)
                Spacer()
                if isShowStatus {
                    HStack(spacing: 4) {
                        Circle().frame(width: 4, height: 4)
                            .foregroundStyle(order.status?.foregroundCircleColor ?? .clear)
                        Text(order.status?.title)
                            .font(.paragraphXMediumSmall)
                            .foregroundStyle(order.status?.foregroundColor ?? .colorInteractiveToneHighlight)
                    }
                    .padding(.horizontal, .lg)
                    .padding(.vertical, .xs)
                    .background(
                        RoundedRectangle(cornerRadius: BorderRadius.full).fill(order.status?.backgroundColor ?? .colorSurfaceHighlightDefault)
                    )
                    .lineLimit(1)
                }
                if isShowSelected && isSelected {
                    Image(isSelected ? .icChecked : .icUnchecked)
                        .fixSize(16)
                        .padding(.leading, 4)
                }
            }
            VStack(alignment: .leading, spacing: .lg) {
                if let attr = order.orderAttribute {
                    Text(attr)
                }
                HStack(spacing: 6) {
                    Text("on")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    if let source = order.protocolSource {
                        Image(source.image)
                            .fixSize(20)
                        Text(source.name)
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorBaseTent)
                            .lineLimit(1)
                    }
                }
            }
        }
        .padding(.xl)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(isSelected ? .colorInteractiveToneHighlight : .colorBorderPrimaryTer, lineWidth: 2))
        .contentShape(.rect)
        .padding(.top, 2)
    }
}
