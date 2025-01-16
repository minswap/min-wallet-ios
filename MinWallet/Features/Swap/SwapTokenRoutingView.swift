import SwiftUI
import FlowStacks


struct SwapTokenRoutingView: View {
    @Binding
    var isShowRouting: Bool
    @EnvironmentObject
    var viewModel: SwapTokenViewModel

    @Environment(\.partialSheetDismiss)
    var onDismiss

    var onRoutingSelected: ((WrapRouting) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Select route")
                .font(.titleH5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 60)
                .padding(.top, .md)
                .padding(.horizontal, .xl)
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(0..<viewModel.wrapRoutings.count, id: \.self) { index in
                        let routing = viewModel.wrapRoutings[index]
                        let isSelectedBinding = Binding<Bool>(
                            get: { routing.uniqueID == viewModel.routingSelected?.uniqueID },
                            set: { newValue in }
                        )
                        SwapTokenRoutingItemView(wrapRouting: routing, title: routing.title, titleColor: index == 0 ? .colorInteractiveToneHighlight : .colorBaseTent, showRecommend: index == 0, isSelected: isSelectedBinding)
                            .frame(height: 85)
                            .padding(.top, .lg)
                            .padding(.horizontal, .xl)
                            .contentShape(.rect)
                            .onTapGesture {
                                onRoutingSelected?(viewModel.wrapRoutings[index])
                                onDismiss?()
                            }
                    }
                }
            }
            .frame(maxHeight: min(CGFloat(85 * viewModel.wrapRoutings.count), UIScreen.main.bounds.height - 250))
            Spacer(minLength: 0)
            CustomButton(title: "Swap") {
                isShowRouting = false
            }
            .frame(height: 56)
            .padding(.top, 40)
            .padding(.horizontal, .xl)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}


private struct SwapTokenRoutingItemView: View {
    let wrapRouting: WrapRouting
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
    SwapTokenRoutingView(isShowRouting: .constant(false))
        .environmentObject(SwapTokenViewModel())
}
