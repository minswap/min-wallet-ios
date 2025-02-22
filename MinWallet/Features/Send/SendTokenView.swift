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
    @EnvironmentObject
    private var tokenManager: TokenManager
    @FocusState
    private var focusedField: Focusable?
    @State
    private var amount: String = ""
    @StateObject
    private var viewModel: SendTokenViewModel
    @State
    private var isShowSelectToken: Bool = false

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
                                AmountTextField(value: $item.amount, minValue: pow(10, Double(item.token.decimals) * -1), maxValue: item.token.isTokenADA ? (max(item.token.amount - 10, 0)) : item.token.amount)
                                    .focused($focusedField, equals: .row(id: item.token.uniqueID))
                                Text("Max")
                                    .font(.labelMediumSecondary)
                                    .foregroundStyle(.colorInteractiveToneHighlight)
                                    .onTapGesture {
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
        .modifier(
            BaseContentView(
                screenTitle: " ",
                actionLeft: {
                    if appSetting.rootScreen != .home {
                        appSetting.rootScreen = .home
                    }
                    navigator.popToRoot()
                })
        )
        .presentSheet(
            isPresented: $isShowSelectToken,
            onDimiss: {
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
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    SendTokenView(viewModel: SendTokenViewModel(tokens: [TokenManager.shared.tokenAda], screenType: .normal))
        .environmentObject(TokenManager.shared)
}
