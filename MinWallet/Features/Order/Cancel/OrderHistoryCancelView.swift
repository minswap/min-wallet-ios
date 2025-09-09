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
                            Text("You can cancel only 1 type per time - Plutus V1, Plutus V2")
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
                        let isCanSelect: Binding<Bool> = .constant(orderCanSelect[order.id] != nil || orderCanSelect.isEmpty)
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
                            guard orderCanSelect[order.id] != nil || orderCanSelect.isEmpty else { return }
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
        var orderCanSelect: [String: OrderHistory] = [:]
        
        let selectedValues = Array(selected.values)
        let selectedCount = selectedValues.count
        let hasP1 = selectedValues.contains { Self.isP1($0.protocolSource) }
        let hasP2 = selectedValues.contains { Self.isP2($0.protocolSource) }
        let hasP3 = selectedValues.contains { Self.isP3($0.protocolSource) }
        let p3Count = selectedValues.filter { Self.isP3($0.protocolSource) }.count
        let splashCount = selectedValues.filter { Self.isSplashOrder($0.protocolSource) }.count
        let selectedIDs = Set(selectedValues.map { $0.id })
        
        if selectedCount >= 6 {
            return [:]
        }
        
        for order in orders {
            if selectedIDs.contains(order.id) { continue }
            
            if selectedCount + 1 > 6 { continue }
            
            let src = order.protocolSource
            let candIsP1 = Self.isP1(src)
            let candIsP2 = Self.isP2(src)
            let candIsP3 = Self.isP3(src)
            let candIsSplash = Self.isSplashOrder(src)
            
            var allowed = true
            if candIsP1 && (hasP2 || hasP3) { allowed = false }
            if candIsP2 && hasP1 { allowed = false }
            if candIsP3 && (hasP1 || splashCount > 0) { allowed = false }
            if candIsSplash && hasP3 { allowed = false }
            
            if candIsP3 && p3Count >= 1 { allowed = false }
            if candIsSplash && splashCount >= 1 { allowed = false }
            
            if allowed {
                orderCanSelect[order.id] = order
            }
        }
        
        return orderCanSelect
    }
    
    static let PLUTUS_V1: Set<AggregatorSource> = [
        .Minswap, .SundaeSwap, .VyFinance, .WingRiders,
    ]

    static let PLUTUS_V2: Set<AggregatorSource> = [
        .MinswapStable, .MinswapV2, .MuesliSwap, .Spectrum, .Splash, .SplashStable,
        .SundaeSwapV3, .WingRidersStableV2, .WingRidersV2, .CSwap,
    ]

    static let PLUTUS_V3: Set<AggregatorSource> = [
        .CSwap
    ]

    static let SPLASH_ORDERS: Set<AggregatorSource> = [
        .Splash, .SplashStable, .Spectrum,
    ]

    static func isP1(_ s: AggregatorSource?) -> Bool {
        guard let s = s else { return false }
        return Self.PLUTUS_V1.contains(s)
    }
    
    static func isP2(_ s: AggregatorSource?) -> Bool {
        guard let s = s else { return false }
        return Self.PLUTUS_V2.contains(s)
    }
    
    static func isP3(_ s: AggregatorSource?) -> Bool {
        guard let s = s else { return false }
        return Self.PLUTUS_V3.contains(s)
    }
    
    static func isSplashOrder(_ s: AggregatorSource?) -> Bool {
        guard let s = s else { return false }
        return Self.SPLASH_ORDERS.contains(s)
    }
}


extension AggregatorSource {
    var nameAndBackgroundColorPlus: (String?, Color?) {
        if OrderHistoryCancelView.PLUTUS_V1.contains(self) {
            return ("P1", .colorBaseChartGreen)
        }
        if OrderHistoryCancelView.PLUTUS_V2.contains(self) {
            return ("P2", .colorBaseChartPurple)
        }
        if OrderHistoryCancelView.PLUTUS_V3.contains(self) {
            return ("P3", .colorBaseChartGold)
        }
        return (nil, nil)
    }
}

#Preview {
    VStack {
        OrderHistoryCancelView(orders: .constant([.init()]), orderSelected: .constant([:]), orderCanSelect: .constant([:]))
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
        ZStack {
            VStack(alignment: .leading, spacing: .xl) {
                HStack(alignment: .center) {
                    Text("#\(number)")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(isCanSelect ? .colorInteractiveToneHighlight : .colorInteractiveTentPrimaryDisable)
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
                    if let attr = order.orderAttribute, isCanSelect {
                        Text(attr)
                    }
                    if let attr = order.orderAttributeDisable, !isCanSelect {
                        Text(attr)
                    }
                    HStack(spacing: 6) {
                        Text("on")
                            .font(.paragraphSmall)
                            .foregroundStyle(isCanSelect ? .colorInteractiveTentPrimarySub : .colorInteractiveTentPrimaryDisable)
                        if let source = order.protocolSource {
                            Image(source.image)
                                .fixSize(20)
                            Text(source.name)
                                .font(.labelSmallSecondary)
                                .foregroundStyle(isCanSelect ? .colorBaseTent : .colorInteractiveTentPrimaryDisable)
                                .lineLimit(1)
                            
                            let (name, bgColor) = source.nameAndBackgroundColorPlus
                            
                            if let name = name, let bgColor = bgColor {
                                Text(name)
                                    .font(.paragraphXSemiSmall)
                                    .foregroundStyle(.colorBaseTentNoDarkMode)
                                    .padding(.horizontal, .md)
                                    .frame(height: 20)
                                    .background(
                                        RoundedRectangle(cornerRadius: BorderRadius.full).fill(bgColor)
                                    )
                                    .lineLimit(1)
                            }
                        }
                    }
                }
            }
            .padding(.xl)
            if !isCanSelect {
                Color.colorSurfacePrimaryDisable.clipped()
                    .cornerRadius(16)
            }
        }
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(isSelected ? .colorInteractiveToneHighlight : .colorBorderPrimaryTer, lineWidth: 2))
        .contentShape(.rect)
        .padding(.top, 2)
    }
}
