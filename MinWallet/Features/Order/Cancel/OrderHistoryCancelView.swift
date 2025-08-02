import SwiftUI


struct OrderHistoryCancelView: View {
    @Environment(\.partialSheetDismiss)
    private var onDismiss

    @State
    var orders: [OrderHistory] = [.init().with({ $0.id = "1" }), .init().with({ $0.id = "2" })]
    @State
    private var orderSelected: [String: OrderHistory] = [:]

    var body: some View {
        VStack(spacing: 0) {
            Text("Cancel Orders")
                .font(.titleH5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 60)
                .padding(.horizontal, .xl)
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

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(Array(orders.enumerated()), id: \.offset) { index, order in
                        let isSelected: Binding<Bool> = .constant(orderSelected[order.id] != nil)
                        OrderHistoryItemStatusView(
                            number: index + 1,
                            isShowStatus: false,
                            isShowSelected: true,
                            isSelected: isSelected,
                            order: order
                        )
                            .padding(.horizontal, .xl)
                            .contentShape(.rect)
                            .onTapGesture {
                            if orderSelected[order.id] == nil {
                                orderSelected[order.id] = order
                            } else {
                                orderSelected.removeValue(forKey: order.id)
                            }
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
                    let orders: [OrderHistory] = orderSelected.map({ _, value in value})
                    guard !orders.isEmpty else { return }
                    
                    onDismiss?()
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
}

#Preview {
    VStack {
        OrderHistoryCancelView()
            .environmentObject(AppSetting.shared)
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
                    if let source = order.aggregatorSource {
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
