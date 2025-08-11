import SwiftUI
import FlowStacks


struct SendTokenView: View {
    enum ScreenType {
        case scanQRCode(address: String)
        case normal
    }
    
    enum Focusable: Hashable {
        case none
        case row(id: String)
    }
    
    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    private var appSetting: AppSetting
    @StateObject
    private var tokenManager: TokenManager = TokenManager.shared
    @FocusState
    private var focusedField: Focusable?
    @State
    private var amount: String = ""
    @StateObject
    private var viewModel: SendTokenViewModel
    @State
    private var isShowSelectToken: Bool = false
    @State
    private var ignoresKeyboard: Bool = false
    @State
    private var keyboardHeight: CGFloat = 0
    
    init(viewModel: SendTokenViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                VStack(
                    spacing: 0,
                    content: {
                        Text("You want to send:")
                            .font(.titleH5)
                            .foregroundStyle(.colorBaseTent)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, .lg)
                            .padding(.bottom, .xl)
                            .padding(.horizontal, .xl)
                        /*
                        HStack(spacing: .md) {
                            AmountTextField(value: $viewModel.amountDefault)
                                .focused($focusedField, equals: Focusable.row(id: "-1"))
                            Text("Max")
                                .font(.labelMediumSecondary)
                                .foregroundStyle(.colorInteractiveToneHighlight)
                                .onTapGesture {
                        
                                }
                            Image(.ada)
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("ADA")
                                .font(.labelSemiSecondary)
                                .foregroundStyle(.colorBaseTent)
                        }
                        .padding(.horizontal, .xl)
                        .padding(.vertical, .lg)
                        .overlay(RoundedRectangle(cornerRadius: BorderRadius.full).stroke(.colorBorderPrimaryDefault, lineWidth: 1))
                        .padding(.horizontal, .xl)
                        .padding(.top, .lg)
                         */
                        ForEach($viewModel.tokens) { $item in
                            let item = $item.wrappedValue
                            HStack(spacing: .md) {
                                let minValueBinding = Binding<Double>(
                                    get: { pow(10, Double(item.token.isTokenADA ? 6 : item.token.decimals) * -1) },
                                    set: { _ in }
                                )
                                let maxValueBinding = Binding<Double?>(
                                    get: { item.token.isTokenADA ? (max(item.token.amount - self.tokenManager.minimumAdaValue, 0)) : item.token.amount },
                                    set: { _ in }
                                )
                                AmountTextField(
                                    value: $item.amount,
                                    minValue: minValueBinding,
                                    maxValue: maxValueBinding,
                                    minimumFractionDigits: .constant(item.token.isTokenADA ? 6 : item.token.decimals)
                                )
                                .focused($focusedField, equals: .row(id: item.token.uniqueID))
                                Text("Max")
                                    .font(.labelMediumSecondary)
                                    .foregroundStyle(.colorInteractiveToneHighlight)
                                    .onTapGesture {
                                        hideKeyboard()
                                        viewModel.setMaxAmount(item: item)
                                    }
                                TokenLogoView(currencySymbol: item.token.currencySymbol, tokenName: item.token.tokenName, isVerified: false, size: .init(width: 24, height: 24))
                                Text(item.token.adaName)
                                    .font(.labelSemiSecondary)
                                    .foregroundStyle(.colorBaseTent)
                            }
                            .padding(.horizontal, .xl)
                            .padding(.vertical, .lg)
                            .overlay(RoundedRectangle(cornerRadius: BorderRadius.full).stroke(.colorBorderPrimaryDefault, lineWidth: 1))
                            .padding(.horizontal, .xl)
                            .padding(.top, .lg)
                        }
                        Button(
                            action: {
                                hideKeyboard()
                                viewModel.selectTokenVM.selectToken(tokens: viewModel.tokens.map({ $0.token }))
                                ignoresKeyboard = true
                                $isShowSelectToken.showSheet()
                            },
                            label: {
                                Text("Add Token")
                                    .font(.labelSmallSecondary)
                                    .foregroundStyle(.colorInteractiveTentSecondaryDefault)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(content: {
                                        RoundedRectangle(cornerRadius: BorderRadius.full).fill(.colorSurfacePrimaryDefault)
                                    })
                            }
                        )
                        .frame(height: 36)
                        .padding(.horizontal, .xl)
                        .padding(.top, .md)
                        .buttonStyle(.plain)
                    })
            }
            Spacer()
            let combinedBinding = Binding<Bool>(
                get: { viewModel.isValidTokenToSend },
                set: { _ in }
            )
            
            if keyboardHeight == 0 {
                CustomButton(title: "Next", isEnable: combinedBinding) {
                    let tokens = viewModel.tokensToSend
                    guard !tokens.isEmpty else { return }
                    switch viewModel.screenType {
                    case .scanQRCode(let address):
                        navigator.push(.sendToken(.confirm(tokens: tokens, address: address)))
                    case .normal:
                        navigator.push(.sendToken(.toWallet(tokens: tokens)))
                    }
                }
                .frame(height: 56)
                .padding(.horizontal, .xl)
            }
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
                screenTitle: " ",
                actionLeft: {
                    /*
                    if appSetting.rootScreen != .home {
                        appSetting.rootScreen = .home
                    }
                    navigator.popToRoot()
                     */
                    navigator.pop()
                })
        )
        .presentSheet(
            isPresented: $isShowSelectToken,
            onDimiss: {
                ignoresKeyboard = false
                viewModel.selectTokenVM.resetState()
            },
            content: {
                SelectTokenView(
                    viewModel: viewModel.selectTokenVM,
                    onSelectToken: { tokens in
                        viewModel.addToken(tokens: tokens)
                    }
                )
                .frame(height: (UIScreen.current?.bounds.height ?? 0) * 0.85)
                .presentSheetModifier()
            }
        )
        .applyKeyboardSafeArea(ignores: ignoresKeyboard)
        .modifier(DismissingKeyboard())
        .onAppear {
            subscribeToKeyboard()
        }
        .onDisappear {
            unsubscribeFromKeyboard()
        }
    }
    
    private func subscribeToKeyboard() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                self.keyboardHeight = keyboardFrame.height
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.keyboardHeight = 0
        }
    }
    
    private func unsubscribeFromKeyboard() {
        NotificationCenter.default.removeObserver(self)
    }
}

#Preview {
    SendTokenView(viewModel: SendTokenViewModel(tokens: [TokenManager.shared.tokenAda], screenType: .normal))
        .environmentObject(TokenManager.shared)
}
