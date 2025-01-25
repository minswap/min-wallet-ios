import SwiftUI
import FlowStacks
import MinWalletAPI


struct MainCoordinator: View {
    @StateObject
    private var viewModel = MainCoordinatorViewModel()
    @EnvironmentObject
    private var appSetting: AppSetting

    var body: some View {
        FlowStack($viewModel.routes, withNavigation: true) {
            SplashView()
                .flowDestination(for: MainCoordinatorViewModel.Screen.self) { screen in
                    switch screen {
                    case .home:
                        HomeView().navigationBarHidden(true)
                    case let .policy(screenType):
                        PolicyConfirmView(screenType: screenType).navigationBarHidden(true)
                    case .gettingStarted:
                        GettingStartedView().navigationBarHidden(true)
                    case let .tokenDetail(token):
                        TokenDetailView(viewModel: TokenDetailViewModel(token: token)).navigationBarHidden(true)
                    case .about:
                        AboutView().navigationBarHidden(true)
                    case .language:
                        LanguageView().interactiveDismissDisabled(false)
                    case .changePassword:
                        ChangePasswordView(screenType: .setting).navigationBarHidden(true)
                    case let .changePasswordSuccess(screenType):
                        ChangePasswordSuccessView(screenType: screenType).navigationBarHidden(true)
                    case let .forgotPassword(screenType):
                        ForgotPasswordView(screenType: .changeYourPassword(screenType)).navigationBarHidden(true)
                    case let .createWallet(screen):
                        switch screen {
                        case .createWallet:
                            CreateNewWalletView().navigationBarHidden(true)
                        case .seedPhrase:
                            CreateNewWalletSeedPhraseView().navigationBarHidden(true)
                        case let .reInputSeedPhrase(seedPhrase):
                            ReInputSeedPhraseView(screenType: .createWallet(seedPhrase: seedPhrase)).navigationBarHidden(true)
                        case let .setupNickName(seedPhrase):
                            SetupNickNameView(screenType: .createWallet(seedPhrase: seedPhrase)).navigationBarHidden(true)
                        case let .biometricSetup(seedPhrase, nickName):
                            BiometricSetupView(screenType: .createWallet(seedPhase: seedPhrase, nickName: nickName)).navigationBarHidden(true)
                        case let .createNewPassword(seedPhrase, nickName):
                            CreateNewPasswordView(screenType: .createWallet(seedPhrase: seedPhrase, nickName: nickName)).navigationBarHidden(true)
                        case .createNewWalletSuccess:
                            CreateNewWalletSuccessView(screenType: .newWallet).navigationBarHidden(true)
                        }

                    case let .restoreWallet(screen):
                        switch screen {
                        case .restoreWallet:
                            RestoreWalletView().navigationBarHidden(true)
                        case .seedPhrase:
                            ReInputSeedPhraseView(screenType: .restoreWallet).navigationBarHidden(true)
                        case .createNewWalletSuccess:
                            CreateNewWalletSuccessView(screenType: .restoreWallet).navigationBarHidden(true)
                        case let .createNewPassword(fileContent, seedPhrase, nickName):
                            CreateNewPasswordView(screenType: .restoreWallet(fileContent: fileContent, seedPhrase: seedPhrase, nickName: nickName)).navigationBarHidden(true)
                        case .importFile:
                            RestoreWalletImportFileView().navigationBarHidden(true)
                        case let .biometricSetup(fileContent, seedPhrase, nickName):
                            BiometricSetupView(screenType: .restoreWallet(fileContent: fileContent, seedPhase: seedPhrase, nickName: nickName)).navigationBarHidden(true)
                        }

                    case let .walletSetting(screen):
                        switch screen {
                        case .walletAccount:
                            WalletAccountView().navigationBarHidden(true)
                        case .changePassword:
                            ChangePasswordView(screenType: .walletSetting).navigationBarHidden(true)
                        case .changePasswordSuccess:
                            ChangePasswordSuccessView(screenType: .walletSetting).navigationBarHidden(true)
                        case .editNickName:
                            SetupNickNameView(screenType: .walletSetting).navigationBarHidden(true)
                        }

                    case let .sendToken(screen):
                        switch screen {
                        case let .sendToken(tokenSelected):
                            SendTokenView(viewModel: .init(tokens: tokenSelected)).navigationBarHidden(true)
                        case let .toWallet(tokens):
                            ToWalletAddressView(viewModel: ToWalletAddressViewModel(tokens: tokens)).navigationBarHidden(true)
                        case let .confirm(tokens, address):
                            ConfirmSendTokenView(viewModel: ConfirmSendTokenViewModel(tokens: tokens, address: address)).navigationBarHidden(true)
                        case let .selectToken(tokensSelected, screenType, onSelectToken):
                            SelectTokenView(viewModel: SelectTokenViewModel(tokensSelected: tokensSelected, screenType: screenType), onSelectToken: onSelectToken)
                                .navigationBarHidden(true)
                        }

                    //TODO: Cuongnv chuyen sang present bt
                    case let .selectToken(tokensSelected, onSelectToken):
                        SelectTokenView(viewModel: SelectTokenViewModel(tokensSelected: tokensSelected, screenType: .sendToken), onSelectToken: onSelectToken)
                    //                            .presentationDragIndicator(.visible)

                    case .receiveToken:
                        ReceiveTokenView().navigationBarHidden(true)

                    case let .swapToken(screen):
                        switch screen {
                        case .swapToken:
                            SwapTokenView().navigationBarHidden(true)
                        }

                    case .searchToken:
                        SearchTokenView().navigationBarHidden(true)

                    case let .securitySetting(screen):
                        switch screen {
                        case .authentication:
                            AuthenticationSettingView().navigationBarHidden(true)
                        case let .createPassword(onCreatePassSuccess):
                            CreateNewPasswordView(
                                screenType: .authenticationSetting,
                                onCreatePasswordSuccess: { password in
                                    onCreatePassSuccess.onCreatePassSuccess?(password)
                                }
                            )
                            .navigationBarHidden(true)
                        case .forgotPassword:
                            ForgotPasswordView(screenType: .enterPassword).navigationBarHidden(true)
                        }
                    case let .orderHistoryDetail(order):
                        OrderHistoryDetailView(order: order).navigationBarHidden(true)
                    case .orderHistory:
                        OrderHistoryView().navigationBarHidden(true)
                    }
                }
                .navigationBarHidden(true)
                .environment(\.locale, .init(identifier: appSetting.language))
        }
    }
}

#Preview {
    MainCoordinator()
        .environmentObject(AppSetting.shared)
}
