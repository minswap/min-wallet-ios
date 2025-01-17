import SwiftUI
import FlowStacks


extension TokenDetailView {
    var tokenDetailBottomView: some View {
        ZStack {
            VStack(
                alignment: .leading,
                content: {
                    HStack {
                        Spacer()
                        Color.colorInteractiveTentPrimarySub.frame(width: 36, height: 4)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    Text("My balance")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                        .padding(.horizontal, .xl)
                        .padding(.top, .xl)
                        .padding(.bottom, .md)
                    HStack(alignment: .lastTextBaseline) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(portfolioOverviewViewModel.netAdaValue.getPriceValue(appSetting: appSetting, font: .titleH5).attribute)
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                            Text(portfolioOverviewViewModel.adaValue.getPriceValue(appSetting: appSetting, font: .paragraphSmall, fontColor: .colorInteractiveTentPrimarySub).attribute)
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                        }
                        Spacer()
                        CustomButton(title: "Swap") {
                            navigator.push(.swapToken(.swapToken))
                        }
                        .frame(width: 90, height: 44)
                    }
                    .padding(.horizontal, .xl)
                    .padding(.bottom, .xl)
                })
        }
        .foregroundStyle(.colorBaseBackground)
        .cornerRadius(BorderRadius._3xl)
        .overlay(RoundedRectangle(cornerRadius: BorderRadius._3xl).stroke(.colorBorderPrimarySub, lineWidth: 1))
    }
}

#Preview {
    TokenDetailView(viewModel: TokenDetailViewModel(token: TokenProtocolDefault()))
        .environmentObject(AppSetting.shared)
}
