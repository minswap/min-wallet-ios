import SwiftUI
import FlowStacks


extension TokenDetailView {
    var tokenDetailBottomView: some View {
        ZStack {
            VStack(
                alignment: .leading,
                spacing: .md,
                content: {
                    Text("My balance")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                        .padding(.horizontal, .xl)
                        .padding(.top, .xl)
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(tokenManager.adaValue.formatNumber(suffix: Currency.ada.prefix, font: .titleH5, fontColor: .colorBaseTent))
                                .minimumScaleFactor(0.8)
                                .lineLimit(1)
                            Text(tokenManager.adaValue.getPriceValue(appSetting: appSetting, font: .paragraphSmall, fontColor: .colorInteractiveTentPrimarySub).attribute)
                                .minimumScaleFactor(0.8)
                                .lineLimit(1)
                                .padding(.bottom, 2)
                        }
                        Spacer()
                        CustomButton(title: "Swap") {
                            navigator.push(.swapToken(.swapToken(token: viewModel.token)))
                        }
                        .frame(width: 90, height: 44)
                    }
                    .padding(.horizontal, .xl)
                    .padding(.bottom, .xl)
                })
        }
        .background(.colorBaseBackground)
        .cornerRadius(BorderRadius._3xl)
        .overlay(
            RoundedRectangle(cornerRadius: BorderRadius._3xl).stroke(.colorBorderPrimaryDefault, lineWidth: 1)
        )
        .shadow(color: colorScheme == .light ? .colorBaseTent.opacity(0.18) : .clear, radius: 10, x: 10, y: 10)
        .zIndex(999)
        .compositingGroup()
    }
}

#Preview {
    TokenDetailView(viewModel: TokenDetailViewModel(token: TokenProtocolDefault()))
        .environmentObject(AppSetting.shared)
}
