import SwiftUI
import FlowStacks


struct SwapTokenView: View {
    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    private var appSetting: AppSetting

    @State
    private var amountYouPay: String = ""

    @StateObject
    private var viewModel: SwapTokenViewModel = .init()


    var body: some View {
        VStack(spacing: 0) {
            contentView
            Spacer()
            CustomButton(title: "Swap") {
                viewModel.swapToken(
                    appSetting: appSetting,
                    signContract: {
                        navigator.presentSheet(
                            .sendToken(
                                .signContract(onSuccess: {

                                })))
                    },
                    signSuccess: {

                    })
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
                    viewModel.isShowSwapSetting = true
                })
        )
        .popupSheet(
            isPresented: $viewModel.isShowInfo,
            content: {
                SwapTokenInfoView(isShowInfo: $viewModel.isShowInfo)
            }
        )
        .popupSheet(
            isPresented: $viewModel.isShowRouting,
            content: {
                SwapTokenRoutingView(isShowRouting: $viewModel.isShowRouting)
            }
        )
        .presentSheet(isPresented: $viewModel.isShowSwapSetting, height: 600) {
            SwapTokenSettingView(isShowSwapSetting: $viewModel.isShowSwapSetting)
                .padding(.xl)
        }
        .banner(isShowing: $viewModel.isShowBannerTransaction) {
            HStack(alignment: .top) {
                Image(.icCheckSuccess)
                    .fixSize(24)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Transaction Submitted")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorInteractiveToneSuccess)
                    Text("Your transaction has been submitted successfully")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    HStack(spacing: 4) {
                        Text("View on explorer")
                            .underline()
                            .baselineOffset(4)
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorInteractiveTentSecondaryDefault)
                            .onTapGesture {

                            }
                        Image(.icArrowUp)
                            .fixSize(.xl)
                            .onTapGesture {

                            }
                    }
                    .padding(.top, 4)
                }
            }
            .padding()
            .background(.colorBaseBackground)
            .clipped()
            .cornerRadius(._3xl)
            .overlay(RoundedRectangle(cornerRadius: ._3xl).stroke(.colorBaseSuccessSub, lineWidth: 1))
            .shadow(radius: 5, x: 0, y: 5)
        }
    }

    @ViewBuilder
    private var contentView: some View {
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
                    TokenLogoView(
                        currencySymbol: viewModel.tokenPay?.currencySymbol,
                        tokenName: viewModel.tokenPay?.tokenName,
                        isVerified: viewModel.tokenPay?.isVerified,
                        size: .init(width: 24, height: 24)
                    )
                    Text(viewModel.tokenPay?.name)
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
                .contentShape(.rect)
                .onTapGesture {
                    navigator.presentSheet(
                        .selectToken(
                            tokensSelected: [viewModel.tokenReceive],
                            onSelectToken: { token in
                                self.viewModel.tokenPay = token.first
                            }))
                }
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
                    if let tokenReceive = viewModel.tokenReceive {
                        TokenLogoView(
                            currencySymbol: tokenReceive.currencySymbol,
                            tokenName: tokenReceive.tokenName,
                            isVerified: tokenReceive.isVerified,
                            size: .init(width: 24, height: 24)
                        )
                        Text(tokenReceive.name)
                            .font(.labelMediumSecondary)
                            .foregroundStyle(.colorBaseTent)
                    } else {
                        Image(.icAdd)
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Select token")
                            .font(.labelMediumSecondary)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                            .foregroundStyle(.colorBaseTent)
                    }
                    Image(.icDown)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 16, height: 16)
                        .tint(.colorBaseTent)
                }
                .padding(.md)
                .overlay(RoundedRectangle(cornerRadius: 20).fill(Color.colorSurfacePrimaryDefault))
                .onTapGesture {
                    navigator.presentSheet(
                        .selectToken(
                            tokensSelected: [viewModel.tokenPay],
                            onSelectToken: { token in
                                self.viewModel.tokenReceive = token.first
                            }))
                }
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
    }

    private var bottomView: some View {
        HStack {
            Text("zz")
        }
        .background(.pink)
    }
}

#Preview {
    SwapTokenView()
}
