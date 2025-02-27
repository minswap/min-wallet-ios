import SwiftUI
import FlowStacks
import SkeletonUI


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
    private var viewModel: SwapTokenViewModel
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

    init(viewModel: SwapTokenViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }

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
                get: { viewModel.enableSwap },
                set: { _ in }
            )
            let swapTitle: LocalizedStringKey = viewModel.errorInfo?.content ?? "Swap"
            CustomButton(title: swapTitle, isEnable: combinedBinding) {
                processingSwapToken()
            }
            .frame(height: 56)
            .padding(.horizontal, .xl)
            .padding(.top, .xl)
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
            SwapTokenInfoView(
                viewModel: viewModel,
                onShowToolTip: { (title, content) in
                    self.content = content
                    self.title = title
                    $isShowToolTip.showSheet()
                },
                onSwap: {
                    processingSwapToken()
                }
            )
        }
        /*
        .presentSheet(isPresented: $viewModel.isShowRouting) {
            SwapTokenRoutingView()
                .environmentObject(viewModel)
        }
         */
        .presentSheet(
            isPresented: $viewModel.isShowSelectToken,
            onDimiss: {
                viewModel.action.send(.hiddenSelectToken)
            },
            content: {
                SelectTokenView(
                    viewModel: viewModel.selectTokenVM,
                    onSelectToken: { tokens in
                        viewModel.action.send(.selectToken(token: tokens.first))
                    }
                )
                .frame(height: (UIScreen.current?.bounds.height ?? 0) * 0.83)
                .presentSheetModifier()
            }
        )
        .ignoresSafeArea(.keyboard)
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
        .presentSheet(isPresented: $isShowToolTip) {
            TokenDetailToolTipView(title: $title, content: $content)
                .background(content: {
                    RoundedCorners(lineWidth: 0, tl: 24, tr: 24, bl: 0, br: 0)
                        .fill(.colorBaseBackground)
                        .ignoresSafeArea()
                })
                .ignoresSafeArea()
        }
        .onAppear { [weak viewModel] in
            viewModel?.hudState = hudState
            //            print("SwapTokenView appear")
            viewModel?.subscribeCombine()
        }
        .onDisappear { [weak viewModel] in
            //            print("SwapTokenView onDisappear")
            viewModel?.unsubscribeCombine()
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
                if !viewModel.isSwapExactIn && viewModel.isGettingTradeInfo {
                    HStack(spacing: 0) {
                        Text("")
                    }
                    .skeleton(with: true)
                    .frame(width: 124, height: 32)
                } else {
                    let minValueBinding = Binding<Double>(
                        get: { pow(10, Double(viewModel.tokenPay.token.decimals) * -1) },
                        set: { _ in }
                    )
                    AmountTextField(
                        value: $viewModel.tokenPay.amount,
                        minValue: minValueBinding,
                        maxValue: .constant(nil),
                        fontPlaceHolder: .titleH4
                    )
                    .font(.titleH4)
                    .foregroundStyle(.colorBaseTent)
                    .focused($focusedField, equals: .pay)
                }
                Spacer(minLength: 0)
                HStack(alignment: .center, spacing: .md) {
                    TokenLogoView(
                        currencySymbol: viewModel.tokenPay.token.currencySymbol,
                        tokenName: viewModel.tokenPay.token.tokenName,
                        isVerified: viewModel.tokenPay.token.isVerified,
                        size: .init(width: 24, height: 24)
                    )
                    Text(viewModel.tokenPay.adaName)
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
                    viewModel.action.send(.showSelectToken(isTokenPay: true))
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
                Text(viewModel.tokenPay.token.amount.formatNumber(roundingOffset: nil, font: .paragraphSmall, fontColor: .colorInteractiveTentPrimarySub))
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
                if viewModel.isSwapExactIn && viewModel.isGettingTradeInfo {
                    HStack(spacing: 0) {
                        Text("")
                    }
                    .skeleton(with: true)
                    .frame(width: 124, height: 32)
                } else {
                    let minValueBinding = Binding<Double>(
                        get: { pow(10, Double(viewModel.tokenReceive.token.decimals) * -1) },
                        set: { _ in }
                    )
                    AmountTextField(
                        value: $viewModel.tokenReceive.amount,
                        minValue: minValueBinding,
                        maxValue: .constant(nil),
                        fontPlaceHolder: .titleH4
                    )
                    .font(.titleH4)
                    .foregroundStyle(.colorBaseTent)
                    .focused($focusedField, equals: .receive)
                }
                Spacer(minLength: 0)
                HStack(alignment: .center, spacing: .md) {
                    TokenLogoView(
                        currencySymbol: viewModel.tokenReceive.token.currencySymbol,
                        tokenName: viewModel.tokenReceive.token.tokenName,
                        isVerified: viewModel.tokenReceive.token.isVerified,
                        size: .init(width: 24, height: 24)
                    )
                    Text(viewModel.tokenReceive.adaName)
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
                    viewModel.action.send(.showSelectToken(isTokenPay: false))
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
                Text(viewModel.tokenReceive.token.amount.formatNumber(roundingOffset: nil, font: .paragraphSmall, fontColor: .colorInteractiveTentPrimarySub))
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
        HStack(alignment: .center, spacing: 8) {
            Text("Trade route")
                .lineLimit(1)
                .font(.paragraphXSmall)
                .foregroundStyle(.colorInteractiveTentPrimarySub)
            /*
            let contractType = viewModel.iosTradeEstimate?.type.value
            if !viewModel.isGettingTradeInfo, let contractType = contractType {
                Text(contractType.title)
                    .font(.paragraphXMediumSmall)
                    .foregroundStyle(contractType.foregroundColor)
                    .padding(.horizontal, .md)
                    .frame(height: 20)
                    .background(
                        RoundedRectangle(cornerRadius: BorderRadius.full).fill(contractType.backgroundColor)
                    )
            }
             */
            Spacer(minLength: 0)
            if viewModel.isGettingTradeInfo {
                HStack(spacing: 0) {
                    Text("")
                }
                .skeleton(with: true)
                .frame(width: 56, height: 16)
            } else if let assets = viewModel.iosTradeEstimate?.path, !assets.isEmpty {
                Image(.icStartRouting)
                    .padding(.trailing, 4)
                ForEach(0..<assets.count, id: \.self) { index in
                    if let asset = assets[gk_safeIndex: index] {
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
        }
        .padding(.horizontal, .xl)
        .frame(height: 48)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(.colorBorderPrimarySub, lineWidth: 1))
        .padding(.top, .md)
        .padding(.horizontal, .xl)
        /*
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
                        if let asset = assets[gk_safeIndex: index] {
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
             */
    }

    @ViewBuilder
    private var bottomView: some View {
        let payAmount = viewModel.tokenPay.amount.doubleValue
        let receiveAmount = viewModel.tokenReceive.amount.doubleValue
        if !payAmount.isZero && !receiveAmount.isZero {
            Color.colorBorderPrimarySub.frame(height: 1)
            HStack(alignment: .center, spacing: 8) {
                Circle().frame(width: 6, height: 6)
                    .foregroundStyle(.colorBaseSuccess)
                let rate: Double = !viewModel.isConvertRate ? (receiveAmount / payAmount) : (payAmount / receiveAmount)
                let firstAtt = AttributedString("1 \(!viewModel.isConvertRate ? viewModel.tokenPay.token.adaName : viewModel.tokenReceive.token.adaName) = ").build(font: .paragraphSmall, color: .colorInteractiveTentPrimarySub)
                let attribute = rate.formatNumber(suffix: viewModel.isConvertRate ? viewModel.tokenPay.token.adaName : viewModel.tokenReceive.token.adaName, font: .paragraphSmall, fontColor: .colorInteractiveTentPrimarySub)
                Text(firstAtt + attribute)
                    .frame(height: 22)
                Image(.icExecutePrice)
                    .fixSize(.xl)
                    .onTapGesture {
                        viewModel.isConvertRate.toggle()
                    }
                Spacer()
                if let iosTradeEstimate = viewModel.iosTradeEstimate, let priceImpact = iosTradeEstimate.priceImpact {
                    let priceImpactColor = iosTradeEstimate.priceImpactColor
                    Text(priceImpact.formatSNumber() + "%")
                        .font(.paragraphXMediumSmall)
                        .foregroundStyle(priceImpactColor.0)
                        .padding(.horizontal, .md)
                        .frame(height: 20)
                        .background(
                            RoundedRectangle(cornerRadius: BorderRadius.full).fill(priceImpactColor.1)
                        )
                        .containerShape(.rect)
                        .onTapGesture {
                            hideKeyboard()
                            $viewModel.isShowInfo.showSheet()
                        }
                } else {
                    Text("--%")
                        .font(.paragraphXMediumSmall)
                        .foregroundStyle(.colorInteractiveToneSuccess)
                        .padding(.horizontal, .md)
                        .frame(height: 20)
                        .background(
                            RoundedRectangle(cornerRadius: BorderRadius.full).fill(.colorSurfaceSuccess)
                        )
                        .containerShape(.rect)
                        .onTapGesture {
                            hideKeyboard()
                            $viewModel.isShowInfo.showSheet()
                        }
                }
                HStack(alignment: .center) {
                    Image(.icNext)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 10, height: 10)
                        .rotationEffect(.degrees(-90))
                }
                .frame(height: 22)
                .containerShape(.rect)
                .onTapGesture {
                    hideKeyboard()
                    $viewModel.isShowInfo.showSheet()
                }
            }
            .padding(.xl)
        }
        if viewModel.showUnderstandingCheckbox {
            HStack(alignment: .center, spacing: 8) {
                Image(viewModel.understandingWarning ? .icSquareCheckBox : .icSquareUncheckBox)
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("I understand these warnings")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorBaseTent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, .xl)
            .contentShape(.rect)
            .onTapGesture {
                viewModel.understandingWarning.toggle()
            }
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
                    WarningItemView(waringInfo: warningInfo, isExpand: isExpand)
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
        guard !viewModel.tokenPay.amount.doubleValue.isZero, !viewModel.tokenReceive.amount.doubleValue.isZero else { return }
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
                hudState.showLoading(true)
                let txRaw = try await viewModel.swapToken()
                let finalID = try await TokenManager.finalizeAndSubmit(txRaw: txRaw)
                hudState.showLoading(false)
                bannerState.infoContent = {
                    bannerState.infoContentDefault(onViewTransaction: {
                        finalID?.viewTransaction()
                    })
                }
                bannerState.showBanner(isShow: true)
                viewModel.action.send(.resetSwap)
                /*
                TokenManager.shared.reloadBalance.send(())
                if appSetting.rootScreen != .home {
                    appSetting.rootScreen = .home
                }
                navigator.popToRoot()
                 */
            } catch {
                hudState.showLoading(false)
                hudState.showMsg(msg: error.localizedDescription)
            }
        }
    }
}

#Preview {
    SwapTokenView(viewModel: SwapTokenViewModel(tokenReceive: nil))
        .environmentObject(HUDState())
}


struct WarningItemView: View {
    let waringInfo: SwapTokenViewModel.WarningInfo
    @Binding
    var isExpand: Bool

    init(waringInfo: SwapTokenViewModel.WarningInfo, isExpand: Binding<Bool>) {
        self.waringInfo = waringInfo
        self._isExpand = isExpand
    }

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
                    .rotationEffect(.degrees(isExpand ? -180 : 0))
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
            Color.colorBorderPrimarySub.frame(height: 1)
                .padding(.top, .md)
            /*
            if showBottomLine {
                Color.colorBorderPrimarySub.frame(height: 1)
                    .padding(.top, .md)
            } else {
                Color.clear.frame(height: 1)
                    .padding(.top, .md)
            }
             */
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
