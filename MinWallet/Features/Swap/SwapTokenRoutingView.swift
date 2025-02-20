import SwiftUI
import FlowStacks


struct SwapTokenRoutingView: View {
    @EnvironmentObject
    private var viewModel: SwapTokenViewModel

    @Environment(\.partialSheetDismiss)
    private var onDismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Select route")
                .font(.titleH5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 60)
                .padding(.top, .md)
                .padding(.horizontal, .xl)
            /*
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(0..<viewModel.wrapRoutings.count, id: \.self) { index in
                        let routing = viewModel.wrapRoutings[index]
                        let isSelectedBinding = Binding<Bool>(
                            get: { routing.uniqueID == viewModel.routingSelected?.uniqueID },
                            set: { _ in }
                        )
                        Color.clear.frame(height: .lg)
                        SwapTokenRoutingItemView(
                            wrapRouting: .constant(routing),
                            title: routing.title,
                            titleColor: index == 0 ? .colorInteractiveToneHighlight : .colorBaseTent,
                            showRecommend: index == 0,
                            isSelected: isSelectedBinding
                        )
                        .padding(.horizontal, .xl)
                        .contentShape(.rect)
                        .onTapGesture {
                            viewModel.routingSelected = viewModel.wrapRoutings[index]
                            viewModel.action.send(.routeSelected)
                            onDismiss?()
                        }
                    }
                }
            }
             */
            Spacer(minLength: 0)
            CustomButton(title: "Swap") {
                onDismiss?()
            }
            .frame(height: 56)
            .padding(.top, 40)
            .padding(.horizontal, .xl)
        }
        .frame(height: (UIScreen.current?.bounds.height ?? 0) * 0.83)
        .presentSheetModifier()
    }
}


private struct SwapTokenRoutingItemView: View {
    @Binding var wrapRouting: WrapRouting
    let title: LocalizedStringKey?
    let titleColor: Color
    let showRecommend: Bool

    @Binding
    var isSelected: Bool

    var body: some View {
        VStack(spacing: .xl) {
            HStack(spacing: 4) {
                Text(title)
                    .font(.labelSmallSecondary)
                    .foregroundStyle(titleColor)
                Spacer()
                if showRecommend {
                    Text("Recommended")
                        .font(.paragraphXSmall)
                        .foregroundStyle(.colorDecorativeLeafSub)
                        .padding(.horizontal, .md)
                        .frame(height: 20)
                        .background(
                            RoundedRectangle(cornerRadius: BorderRadius.full).fill(.colorDecorativeLeaf)
                        )
                }
                Text(wrapRouting.routing.type.value?.title)
                    .font(.paragraphXSmall)
                    .foregroundStyle(wrapRouting.routing.type.value?.foregroundColor ?? .clear)
                    .padding(.horizontal, .md)
                    .frame(height: 20)
                    .background(
                        RoundedRectangle(cornerRadius: BorderRadius.full).fill(wrapRouting.routing.type.value?.backgroundColor ?? .clear)
                    )
            }
            HStack(spacing: 2) {
                Image(.icStartRouting)
                    .padding(.trailing, 4)
                let assets = wrapRouting.poolsAsset
                ForEach(0..<assets.count, id: \.self) { index in
                    let asset = assets[index]
                    TokenLogoView(currencySymbol: asset.currencySymbol, tokenName: asset.tokenName, isVerified: false, size: .init(width: 16, height: 16))
                    if index != assets.count - 1 {
                        Image(.icBack)
                            .resizable()
                            .renderingMode(.template)
                            .rotationEffect(.degrees(180))
                            .frame(width: 14, height: 14)
                            .foregroundStyle(.colorInteractiveTentPrimaryDisable)
                    }
                }
                Spacer()
                Text("124.64 A")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorInteractiveToneHighlight)
            }
        }
        .padding(.xl)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(isSelected ? .colorInteractiveToneHighlight : .colorBorderPrimaryTer, lineWidth: 2))
    }
}

#Preview {
    SwapTokenRoutingView()
        .environmentObject(SwapTokenViewModel())
}
