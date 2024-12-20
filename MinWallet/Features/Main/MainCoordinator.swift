import SwiftUI
import FlowStacks


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
                    case .policy:
                        PolicyConfirmView().navigationBarHidden(true)
                    case .gettingStarted:
                        GettingStartedView().navigationBarHidden(true)
                    case let .tokenDetail(token):
                        TokenDetailView().navigationBarHidden(true)
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
                            ReInputSeedPhraseView(seedPhrase: seedPhrase).navigationBarHidden(true)
                        case let .setupNickName(seedPhrase):
                            SetupNickNameView(seedPhrase: seedPhrase, screenType: .createWallet).navigationBarHidden(true)
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
                            //TODO: cuongnv check seed phrase from somewhere
                            ReInputSeedPhraseView(seedPhrase: CreateNewWalletSeedPhraseView.generateRandomWords(count: 20, minLength: 4, maxLength: 8)).navigationBarHidden(true)
                        case .createNewWalletSuccess:
                            CreateNewWalletSuccessView(screenType: .restoreWallet).navigationBarHidden(true)
                        case let .createNewPassword(seedPhrase, nickName):
                            CreateNewPasswordView(screenType: .restoreWallet(seedPhrase: seedPhrase, nickName: nickName)).navigationBarHidden(true)
                        case .importFile:
                            RestoreWalletImportFileView().navigationBarHidden(true)
                        case let .biometricSetup(seedPhrase, nickName):
                            BiometricSetupView(screenType: .restoreWallet(seedPhase: seedPhrase, nickName: nickName)).navigationBarHidden(true)
                        }

                    case let .walletSetting(screen):
                        switch screen {
                        case .walletAccount:
                            WalletAccountView().navigationBarHidden(true)
                        case .changePassword:
                            ChangePasswordView(screenType: .walletSetting).navigationBarHidden(true)
                        case .changePasswordSuccess:
                            ChangePasswordSuccessView(screenType: .walletSetting).navigationBarHidden(true)
                        case .disconnectWallet:
                            DisconnectWalletView().navigationBarHidden(true)
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
                    }
                }
                .navigationBarHidden(true)
                .environment(\.locale, .init(identifier: appSetting.language))
        }
    }
}

#Preview {
    MainCoordinator()
        .environmentObject(AppSetting())
}
