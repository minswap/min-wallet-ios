import SwiftUI
import FlowStacks


struct SwapTokenRoutingView: View {
    @Binding
    var isShowRouting: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Select route")
                .font(.titleH5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 60)
                .padding(.top, .md)
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(0..<2, id: \.self) { index in
                        SwapTokenRoutingItemView()
                            .frame(height: 85)
                            .padding(.top, .lg)
                    }
                }
            }
            .frame(maxHeight: UIScreen.main.bounds.height - 400)
            Spacer(minLength: 0)
            CustomButton(title: "Swap") {
                isShowRouting = false
            }
            .frame(height: 56)
            .padding(.top, 40)
            .padding(.horizontal, .md)
        }
        .padding(.horizontal, .xl)
        .fixedSize(horizontal: false, vertical: true)
    }
}


private struct SwapTokenRoutingItemView: View {
    var body: some View {
        VStack(spacing: .xl) {
            HStack(spacing: 4) {
                Text("Best route")
                    .font(.labelSmallSecondary)
                    //                    .foregroundStyle(.colorBaseTent)
                    .foregroundStyle(.colorInteractiveToneHighlight)
                Spacer()
                Text("Recommended")
                    .font(.paragraphXSmall)
                    .foregroundStyle(.colorDecorativeLeafSub)
                    .padding(.horizontal, .md)
                    .frame(height: 20)
                    .background(
                        RoundedRectangle(cornerRadius: BorderRadius.full).fill(.colorDecorativeLeaf)
                    )
                Text("Stable")
                    .font(.paragraphXSmall)
                    .foregroundStyle(.colorDecorativeLeafSub)
                    .padding(.horizontal, .md)
                    .frame(height: 20)
                    .background(
                        RoundedRectangle(cornerRadius: BorderRadius.full).fill(.colorDecorativeLeaf)
                    )
            }
            HStack(spacing: 2) {
                Image(.icStartRouting)
                    .padding(.trailing, 4)
                ForEach(0..<3, id: \.self) { index in
                    TokenLogoView(size: .init(width: 16, height: 16))
                    if index != 2 {
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
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.colorBorderPrimaryTer, lineWidth: 2))
    }
}

#Preview {
    SwapTokenRoutingView(isShowRouting: .constant(false))
}
