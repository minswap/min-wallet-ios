import SwiftUI
import FlowStacks
import MinWalletAPI


struct MainCoordinator: View {
    @StateObject
    private var viewModel = MainCoordinatorViewModel()
    @StateObject
    private var portfolioOverviewViewModel = PortfolioOverviewViewModel()
    @EnvironmentObject
    private var appSetting: AppSetting

    var body: some View {
        FlowStack($viewModel.routes, withNavigation: true) {
            SplashView()
                .environmentObject(portfolioOverviewViewModel)
                .flowDestination(for: MainCoordinatorViewModel.Screen.self) { screen in
                    switch screen {
                    case .home:
                        HomeView().navigationBarHidden(true)
                            .environmentObject(portfolioOverviewViewModel)
                    case .policy:
                        PolicyConfirmView().navigationBarHidden(true)
                    case .gettingStarted:
                        GettingStartedView().navigationBarHidden(true)
                    case let .tokenDetail(token):
                        TokenDetailView(viewModel: TokenDetailViewModel(token: token.base)).navigationBarHidden(true)
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
                                .environmentObject(portfolioOverviewViewModel)
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
                                .environmentObject(portfolioOverviewViewModel)
                        case .changePassword:
                            ChangePasswordView(screenType: .walletSetting).navigationBarHidden(true)
                        case .changePasswordSuccess:
                            ChangePasswordSuccessView(screenType: .walletSetting).navigationBarHidden(true)
                        case .editNickName:
                            SetupNickNameView(screenType: .walletSetting).navigationBarHidden(true)
                        }

                    case let .sendToken(screen):
                        switch screen {
                        case .sendToken:
                            SendTokenView().navigationBarHidden(true)
                        case .toWallet:
                            ToWalletAddressView().navigationBarHidden(true)
                        case .confirm:
                            ConfirmSendTokenView().navigationBarHidden(true)
                        case .signContract:
                            SignContractView()
                                .presentationDragIndicator(.visible)
                        }

                    case .selectToken:
                        SelectTokenView().presentationDragIndicator(.visible)

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
