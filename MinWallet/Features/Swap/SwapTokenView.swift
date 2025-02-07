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
    @EnvironmentObject
    private var bannerState: BannerState
    @StateObject
    private var viewModel: SwapTokenViewModel = .init()
    @FocusState
    private var focusedField: FocusedField?
    @State
    private var isShowSignContract: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    contentView
                }
            }
            Spacer()
            bottomView
            CustomButton(title: "Swap") {
                hideKeyboard()
                viewModel.swapToken(
                    appSetting: appSetting,
                    signContract: {
                        isShowSignContract = true
                    },
                    signSuccess: {
                        swapTokenSuccess()
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
                alignmentTitle: .leading,
                actionLeft: {
                    navigator.pop()
                },
                actionRight: {
                    hideKeyboard()
                    $viewModel.isShowSwapSetting.showSheet()
                })
        )
        .presentSheet(isPresented: $viewModel.isShowInfo) {
            SwapTokenInfoView()
                .environmentObject(viewModel)
        }
        .presentSheet(isPresented: $viewModel.isShowRouting) {
            SwapTokenRoutingView()
                .environmentObject(viewModel)
        }
        .presentSheet(isPresented: $viewModel.isShowSwapSetting) {
            SwapTokenSettingView(viewModel: viewModel)
                .padding(.xl)
        }
        .presentSheet(isPresented: $isShowSignContract) {
            SignContractView(
                onSignSuccess: {
                    swapTokenSuccess()
                }
            )
        }
        .presentSheet(isPresented: $viewModel.isShowSelectPayToken) {
            SelectTokenView(
                viewModel: SelectTokenViewModel(tokensSelected: [viewModel.tokenPay.token], screenType: .swapToken, sourceScreenType: .normal),
                onSelectToken: { tokens in
                    self.viewModel.action.send(.selectTokenPay(token: tokens.first))
                }
            )
            .frame(height: (UIScreen.current?.bounds.height ?? 0) * 0.83)
            .presentSheetModifier()
        }
        .presentSheet(isPresented: $viewModel.isShowSelectReceiveToken) {
            SelectTokenView(
                viewModel: SelectTokenViewModel(tokensSelected: [viewModel.tokenReceive.token], screenType: .swapToken, sourceScreenType: .normal),
                onSelectToken: { tokens in
                    self.viewModel.action.send(.selectTokenReceive(token: tokens.first))
                }
            )
            .frame(height: (UIScreen.current?.bounds.height ?? 0) * 0.83)
            .presentSheetModifier()
        }
    }

    @ViewBuilder
    private var contentView: some View {
        tokenPayView
        Image(.icSwap)
            .resizable().frame(width: 36, height: 36)
            .padding(.top, -16)
            .padding(.bottom, -16)
            .zIndex(999)
            .containerShape(.rect)
            .onTapGesture {
                viewModel.action.send(.swapToken)
            }
        tokenReceiveView
        routingView
    }

    @ViewBuilder
    private var tokenPayView: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .lastTextBaseline, spacing: 6) {
                Text("You pay")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
                Spacer()
                Text("Half")
                    .font(.paragraphXMediumSmall)
                    .foregroundStyle(.colorInteractiveToneHighlight)
                    .onTapGesture {
                        viewModel.action.send(.setHalfAmount)
                    }
                Text("Max")
                    .font(.paragraphXMediumSmall)
                    .foregroundStyle(.colorInteractiveToneHighlight)
                    .onTapGesture {
                        viewModel.action.send(.setMaxAmount)
                    }
            }
            HStack(alignment: .center, spacing: 6) {
                AmountTextField(
                    value: $viewModel.tokenPay.amount,
                    maxValue: viewModel.tokenPay.token.amount,
                    fontPlaceHolder: .titleH4
                )
                .font(.titleH4)
                .foregroundStyle(.colorBaseTent)
                .focused($focusedField, equals: .pay)
                Spacer()
                HStack(alignment: .center, spacing: .md) {
                    TokenLogoView(
                        currencySymbol: viewModel.tokenPay.token.currencySymbol,
                        tokenName: viewModel.tokenPay.token.tokenName,
                        isVerified: viewModel.tokenPay.token.isVerified,
                        size: .init(width: 24, height: 24)
                    )
                    Text(viewModel.tokenPay.token.adaName)
                        .lineLimit(1)
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
                    hideKeyboard()
                    $viewModel.isShowSelectPayToken.showSheet()
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
    }
    @ViewBuilder
    private var tokenReceiveView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("You receive")
                .font(.paragraphSmall)
                .foregroundStyle(.colorInteractiveTentPrimarySub)
            HStack(alignment: .center, spacing: 6) {
                AmountTextField(
                    value: $viewModel.tokenReceive.amount,
                    maxValue: viewModel.tokenReceive.token.amount,
                    fontPlaceHolder: .titleH4
                )
                .font(.titleH4)
                .foregroundStyle(.colorBaseTent)
                .focused($focusedField, equals: .receive)
                .disabled(true)
                Spacer()
                HStack(alignment: .center, spacing: .md) {
                    TokenLogoView(
                        currencySymbol: viewModel.tokenReceive.token.currencySymbol,
                        tokenName: viewModel.tokenReceive.token.tokenName,
                        isVerified: viewModel.tokenReceive.token.isVerified,
                        size: .init(width: 24, height: 24)
                    )
                    Text(viewModel.tokenReceive.token.adaName)
                        .lineLimit(1)
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
                .onTapGesture {
                    hideKeyboard()
                    $viewModel.isShowSelectReceiveToken.showSheet()
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
    }

    @ViewBuilder
    private var routingView: some View {
        if let routingSelected = viewModel.routingSelected {
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
                    Text(routingSelected.title)
                        .lineLimit(1)
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                    Text(routingSelected.routing.type.value?.title)
                        .font(.paragraphXMediumSmall)
                        .foregroundStyle(routingSelected.routing.type.value?.foregroundColor ?? .clear)
                        .padding(.horizontal, .md)
                        .frame(height: 20)
                        .background(
                            RoundedRectangle(cornerRadius: BorderRadius.full).fill(routingSelected.routing.type.value?.backgroundColor ?? .clear)
                        )
                    Spacer()
                    Image(.icStartRouting)
                        .padding(.trailing, 4)
                    let assets = routingSelected.poolsAsset
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
                }
            }
            .padding(.xl)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(.colorBorderPrimarySub, lineWidth: 1))
            .padding(.top, .md)
            .padding(.horizontal, .xl)
            .contentShape(.rect)
            .onTapGesture {
                guard !viewModel.isLoadingRouting else { return }
                hideKeyboard()
                $viewModel.isShowRouting.showSheet()
            }
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
            hideKeyboard()
            $viewModel.isShowInfo.showSheet()
        }
    }

    private func swapTokenSuccess() {
        bannerState.infoContent = {
            bannerState.infoContentDefault(onViewTransaction: {

            })
        }
        bannerState.isShowingBanner = true
        if appSetting.rootScreen != .home {
            appSetting.rootScreen = .home
        }
        navigator.popToRoot()
    }
}

#Preview {
    SwapTokenView()
}
