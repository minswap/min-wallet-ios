import SwiftUI
import FlowStacks


struct SwapTokenView: View {
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>

    @State
    private var amountYouPay: String = ""
    @State
    private var isShowSwapSetting: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .lastTextBaseline, spacing: 6) {
                    Text("You pay")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    Text("Half")
                        .font(.paragraphXMediumSmall)
                        .foregroundStyle(.colorInteractiveToneHighlight)
                    Text("Max")
                        .font(.paragraphXMediumSmall)
                        .foregroundStyle(.colorInteractiveToneHighlight)
                }
                HStack(alignment: .center, spacing: 6) {
                    TextField("", text: $amountYouPay)
                        .placeholder("0.0", font: .titleH4, when: amountYouPay.isEmpty)
                        .font(.titleH4)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    HStack(alignment: .center, spacing: .md) {
                        Image(.ada)
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("ADA")
                            .font(.labelMediumSecondary)
                            .foregroundStyle(.colorBaseTent)
                        Image(.icDown)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 16, height: 16)
                            .tint(.colorBaseTent)
                    }
                    .padding(.md)
                    .overlay(RoundedRectangle(cornerRadius: 20).fill(Color.colorSurfacePrimaryDefault))
                }
                HStack(alignment: .center, spacing: 4) {
                    Text("$0.0")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    Image(.icWallet)
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text("235.789")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                }
            }
            .padding(.xl)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(.colorBorderPrimaryDefault, lineWidth: 1))
            .padding(.horizontal, .xl)
            .padding(.top, .lg)
            Image(.icSwap)
                .resizable().frame(width: 36, height: 36)
                .padding(.top, -18)
                .padding(.bottom, -18)
                .zIndex(999)
                .onTapGesture {
                    //TODOZ: cuongnv swap token
                }
            VStack(alignment: .leading, spacing: 4) {
                Text("You receive")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
                HStack(alignment: .center, spacing: 6) {
                    TextField("", text: $amountYouPay)
                        .placeholder("0.0", font: .titleH4, when: amountYouPay.isEmpty)
                        .font(.titleH4)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    HStack(alignment: .center, spacing: .md) {
                        Image(.icAdd)
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Select token")
                            .font(.labelMediumSecondary)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                            .foregroundStyle(.colorBaseTent)
                        Image(.icDown)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 16, height: 16)
                            .tint(.colorBaseTent)
                    }
                    .padding(.md)
                    .overlay(RoundedRectangle(cornerRadius: 20).fill(Color.colorSurfacePrimaryDefault))
                }
                HStack(alignment: .center, spacing: 4) {
                    Text("$0.0")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    Image(.icWallet)
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text("235.789")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                }
            }
            .padding(.xl)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(.colorBorderPrimaryDefault, lineWidth: 1))
            .padding(.horizontal, .xl)
            .padding(.top, .xs)
            Spacer()
            CustomButton(title: "Swap") {
                //navigator.push(.createWallet(.biometricSetup))
            }
            .frame(height: 56)
            .padding(.horizontal, .xl)
        }
        .modifier(
            BaseContentView(
                screenTitle: "Swap",
                iconRight: .icSwapTokenSetting,
                alignmentTitle: .center,
                actionLeft: {
                    navigator.pop()
                },
                actionRight: {
                    isShowSwapSetting = true
                })
        )
        .presentSheet(isPresented: $isShowSwapSetting, height: 600) {
            SwapTokenSettingView(isShowSwapSetting: $isShowSwapSetting)
                .padding(.xl)
        }
    }
}

#Preview {
    SwapTokenView()
}
