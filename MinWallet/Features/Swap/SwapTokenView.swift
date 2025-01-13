import SwiftUI
import FlowStacks


struct SwapTokenView: View {
    enum FocusedField: Hashable {
        case pay
        case receive
    }

    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    private var appSetting: AppSetting

    @State
    private var amountYouPay: String = ""

    @StateObject
    private var viewModel: SwapTokenViewModel = .init()
    @FocusState
    private var focusedField: FocusedField?

    var body: some View {
        VStack(spacing: 0) {
            contentView
            Spacer()
            bottomView
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
            .padding(.top, 24)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()

                Button("Done") {
                    hideKeyboard()
                }
                .foregroundStyle(.colorLabelToolbarDone)
            }
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
                    $viewModel.isShowSwapSetting.showSheet()
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
        .presentSheet(isPresented: $viewModel.isShowSwapSetting) {
            SwapTokenSettingView()
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
                    .focused($focusedField, equals: .pay)
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
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(focusedField == .pay ? .colorBorderPrimaryPressed : .colorBorderPrimarySub, lineWidth: focusedField == .pay ? 2 : 1)
        )
        .padding(.horizontal, .xl)
        .padding(.top, .lg)
        Image(.icSwap)
            .resizable().frame(width: 36, height: 36)
            .padding(.top, -16)
            .padding(.bottom, -16)
            .zIndex(999)
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
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(.colorBorderPrimarySub, lineWidth: 1))
        .padding(.horizontal, .xl)
        .padding(.top, .xs)
        VStack(spacing: .lg) {
            HStack(spacing: 4) {
                Text("Select your route")
                    .font(.paragraphXMediumSmall)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
                Spacer()
                Image(.icDown)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 16, height: 16)
                    .tint(.colorBaseTent)
            }
            HStack(spacing: 8) {
                Text("Best route")
                    .lineLimit(1)
                    .font(.labelSmallSecondary)
                    .foregroundStyle(.colorBaseTent)
                Text("V1")
                    .font(.paragraphXMediumSmall)
                    .foregroundStyle(.colorDecorativeLeafSub)
                    .padding(.horizontal, .md)
                    .frame(height: 20)
                    .background(
                        RoundedRectangle(cornerRadius: BorderRadius.full).fill(.colorDecorativeLeaf)
                    )
                Spacer()
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
            }
        }
        .padding(.xl)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(.colorBorderPrimarySub, lineWidth: 1))
        .padding(.top, .md)
        .padding(.horizontal, .xl)
        .contentShape(.rect)
        .onTapGesture {
            $viewModel.isShowRouting.showSheet()
        }
    }

    @ViewBuilder
    private var bottomView: some View {
        Color.colorBorderPrimarySub.frame(height: 1)
        HStack(spacing: 8) {
            Circle().frame(width: 6, height: 6)
                .foregroundStyle(.colorBaseSuccess)
            Text("1 ADA = 9.443 MIN")
                .font(.paragraphSmall)
                .foregroundStyle(.colorInteractiveTentPrimarySub)
            Image(.icExecutePrice)
                .fixSize(.xl)
            Spacer()
            Text("0.3%")
                .font(.paragraphXMediumSmall)
                .foregroundStyle(.colorInteractiveToneSuccess)
                .padding(.horizontal, .md)
                .frame(height: 20)
                .background(
                    RoundedRectangle(cornerRadius: BorderRadius.full).fill(.colorSurfaceSuccess)
                )
            Image(.icNext)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 10, height: 10)
                .rotationEffect(.degrees(-90))
        }
        .padding(.xl)
        .containerShape(.rect)
        .onTapGesture {
            $viewModel.isShowInfo.showSheet()
        }
    }
}

#Preview {
    SwapTokenView()
}
