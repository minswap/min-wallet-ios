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
    private var hudState: HUDState
    @EnvironmentObject
    private var bannerState: BannerState
    @StateObject
    private var viewModel: SwapTokenViewModel = .init()
    @FocusState
    private var focusedField: FocusedField?
    @State
    private var isShowSignContract: Bool = false
    @State
    var isShowToolTip: Bool = false
    @State
    var content: LocalizedStringKey = ""
    @State
    var title: LocalizedStringKey = ""
    @State
    private var isShowLoading: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    contentView
                        .onChange(of: focusedField) { focusedField in
                            guard let focusedField = focusedField else { return }
                            viewModel.isSwapExactIn = focusedField == .pay
                        }
                }
            }
            Spacer()
            bottomView
            let combinedBinding = Binding<Bool>(
                get: { viewModel.errorInfo == nil },
                set: { _ in }
            )
            let swapTitle: LocalizedStringKey = viewModel.errorInfo?.content ?? "Swap"
            CustomButton(title: swapTitle, isEnable: combinedBinding) {
               processingSwapToken()
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
            SwapTokenInfoView(onShowToolTip: { (title, content) in
                self.content = content
                self.title = title
                $isShowToolTip.showSheet()
            })
            .environmentObject(viewModel)
        }
        /*
        .presentSheet(isPresented: $viewModel.isShowRouting) {
            SwapTokenRoutingView()
                .environmentObject(viewModel)
        }
         */
        .presentSheet(isPresented: $viewModel.isShowSwapSetting) {
            SwapTokenSettingView(
                onShowToolTip: { title, content in
                    self.content = content
                    self.title = title
                    $isShowToolTip.showSheet()
                }, viewModel: viewModel
            )
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
        .presentSheet(isPresented: $isShowToolTip) {
            TokenDetailToolTipView(title: $title, content: $content)
                .background(content: {
                    RoundedCorners(lineWidth: 0, tl: 24, tr: 24, bl: 0, br: 0)
                        .fill(.colorBaseBackground)
                        .ignoresSafeArea()

                })
                .ignoresSafeArea()
        }
        .ignoresSafeArea(.keyboard)
        .onFirstAppear {
            viewModel.hudState = hudState
        }
        .progressView(isShowing: $isShowLoading)
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
                hideKeyboard()
                viewModel.action.send(.swapToken)
            }
        tokenReceiveView
        routingView
        warningView
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
                /*
                Text("$0.0")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
                 */
                Spacer()
                Image(.icWallet)
                    .resizable()
                    .frame(width: 16, height: 16)
                Text(viewModel.tokenPay.token.amount.formatNumber(font: .paragraphSmall, fontColor: .colorInteractiveTentPrimarySub))
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
                /*
                Text("$0.0")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
                 */
                Spacer()
                Image(.icWallet)
                    .resizable()
                    .frame(width: 16, height: 16)
                Text(viewModel.tokenReceive.token.amount.formatNumber(font: .paragraphSmall, fontColor: .colorInteractiveTentPrimarySub))
            }
        }
        .padding(.xl)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(focusedField == .receive ? .colorBorderPrimaryPressed : .colorBorderPrimarySub, lineWidth: focusedField == .receive ? 2 : 1)
        )
        .padding(.horizontal, .xl)
        .padding(.top, .xs)
    }

    @ViewBuilder
    private var routingView: some View {
        if let assets = viewModel.iosTradeEstimate?.path, let contractType = viewModel.iosTradeEstimate?.type.value {
            VStack(spacing: .lg) {
                HStack(spacing: 4) {
                    /*
                    Text("Select your route")
                        .font(.paragraphXMediumSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                     */
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
                    Text(contractType.title)
                        .font(.paragraphXMediumSmall)
                        .foregroundStyle(contractType.foregroundColor)
                        .padding(.horizontal, .md)
                        .frame(height: 20)
                        .background(
                            RoundedRectangle(cornerRadius: BorderRadius.full).fill(contractType.backgroundColor)
                        )
                    Spacer()
                    Image(.icStartRouting)
                        .padding(.trailing, 4)
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
            /*
            .onTapGesture {
                guard !viewModel.isLoadingRouting else { return }
                hideKeyboard()
                $viewModel.isShowRouting.showSheet()
            }
             */
        }
    }

    @ViewBuilder
    private var bottomView: some View {
        let payAmount = Double(viewModel.tokenPay.amount) ?? 0
        let receiveAmount = Double(viewModel.tokenReceive.amount) ?? 0
        if !payAmount.isZero && !receiveAmount.isZero {
            Color.colorBorderPrimarySub.frame(height: 1)
            HStack(spacing: 8) {
                Circle().frame(width: 6, height: 6)
                    .foregroundStyle(.colorBaseSuccess)
                let rate: Double = !viewModel.isConvertRate ? (receiveAmount / payAmount) : (payAmount / receiveAmount)
                let firstAtt = AttributedString("1 \(!viewModel.isConvertRate ? viewModel.tokenPay.token.adaName : viewModel.tokenReceive.token.adaName) = ").build(font: .paragraphSmall, color: .colorInteractiveTentPrimarySub)
                let attribute = rate.formatNumber(suffix: viewModel.isConvertRate ? viewModel.tokenPay.token.adaName : viewModel.tokenReceive.token.adaName, font: .paragraphSmall, fontColor: .colorInteractiveTentPrimarySub)
                Text(firstAtt + attribute)
                Image(.icExecutePrice)
                    .fixSize(.xl)
                    .onTapGesture {
                        viewModel.isConvertRate.toggle()
                    }
                Spacer()
                let priceImpact = viewModel.iosTradeEstimate?.priceImpact ?? 100
                Text(priceImpact.formatSNumber(maximumFractionDigits: 2) + "%")
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
                    .containerShape(.rect)
                    .onTapGesture {
                        hideKeyboard()
                        $viewModel.isShowInfo.showSheet()
                    }
            }
            .padding(.xl)
        }
    }

    @ViewBuilder
    private var warningView: some View {
        if !viewModel.warningInfo.isEmpty {
            VStack(spacing: 0) {
                ForEach(Array(viewModel.warningInfo.enumerated()), id: \.offset) { index, warningInfo in
                    let isExpand = Binding<Bool>(
                        get: { (self.viewModel.isExpand[warningInfo] ?? false) == true },
                        set: { isExpand in
                            self.viewModel.isExpand[warningInfo] = isExpand
                        }
                    )
                    WarningItemView(waringInfo: warningInfo, isExpand: isExpand, showBottomLine: index != viewModel.warningInfo.count - 1)
                }
            }
            .background(.colorSurfaceWarningDefault)
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(.colorBorderWarningSub, lineWidth: 1))
            .padding(.horizontal, .xl)
            .padding(.bottom, .xl)
            .padding(.top, .md)
        }
    }

    private func processingSwapToken() {
        hideKeyboard()
        guard !viewModel.isGettingTradeInfo, viewModel.errorInfo == nil, viewModel.iosTradeEstimate != nil else { return }
        let amountToPay = Double(viewModel.tokenPay.amount) ?? 0
        let amountToReceive = Double(viewModel.tokenReceive.amount) ?? 0
        guard amountToPay > 0, amountToReceive > 0 else { return }
        Task {
            do {
                switch appSetting.authenticationType {
                case .biometric:
                    try await appSetting.reAuthenticateUser()
                    swapTokenSuccess()
                case .password:
                    $isShowSignContract.showSheet()
                }
            } catch {
                hudState.showMsg(msg: error.localizedDescription)
            }
        }
    }
    
    private func swapTokenSuccess() {
        Task {
            do {
                withAnimation {
                    isShowLoading = true
                }
                let tx = try await viewModel.swapToken()
                let finalID = try await viewModel.finalizeAndSubmit(tx: tx)
                withAnimation {
                    isShowLoading = false
                }
                bannerState.infoContent = {
                    bannerState.infoContentDefault(onViewTransaction: {
                        finalID?.viewTransaction()
                    })
                }
                bannerState.showBanner(isShow: true)
                TokenManager.shared.reloadBalance.send(())
                if appSetting.rootScreen != .home {
                    appSetting.rootScreen = .home
                }
                navigator.popToRoot()
            } catch {
                withAnimation {
                    isShowLoading = false
                }
                hudState.showMsg(msg: error.localizedDescription)
            }
        }
    }
}

#Preview {
    SwapTokenView()
}


struct WarningItemView: View {
    @State
    var waringInfo: SwapTokenViewModel.WarningInfo = .indivisibleTokenPay
    @Binding
    var isExpand: Bool
    @State
    var showBottomLine: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: Spacing.md) {
                Image(.icWarningYellow)
                    .resizable()
                    .rotationEffect(.degrees(180))
                    .frame(width: 16, height: 16)
                Text(waringInfo.title)
                    .font(.paragraphXMediumSmall)
                    .foregroundStyle(.colorInteractiveToneWarning)
                Spacer()
                Image(.icArrowDown)
                    .resizable()
                    .rotationEffect(.degrees(isExpand ? 0 : -180))
                    .frame(width: 16, height: 16)
            }
            .padding(.top, .md)
            if isExpand {
                Text(waringInfo.content)
                    .font(.paragraphXSmall)
                    .lineSpacing(2)
                    .foregroundStyle(.colorBaseTent)
                    .padding(.top, .xs)
            }

            if showBottomLine {
                Color.colorBorderPrimarySub.frame(height: 1)
                    .padding(.top, .md)
            } else {
                Color.clear.frame(height: 1)
                    .padding(.top, .md)
            }
        }
        .padding(.horizontal, .md)
        .contentShape(.rect)
        .onTapGesture {
            //withAnimation {
            isExpand.toggle()
            //}
        }
    }
}
