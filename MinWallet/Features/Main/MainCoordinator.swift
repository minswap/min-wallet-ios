import SwiftUI
import FlowStacks


struct MainCoordinator: View {
    @StateObject
    private var viewModel = MainCoordinatorViewModel()

    @EnvironmentObject
    private var appSetting: AppSetting

    @StateObject
    private var createWalletViewModel: CreateNewWalletViewModel = .init()

    @StateObject
    private var restoreWalletViewModel: RestoreWalletViewModel = .init()

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

                    case let .createWallet(screen):
                        switch screen {
                        case .createWallet:
                            CreateNewWalletView().navigationBarHidden(true).environmentObject(createWalletViewModel)
                        case .seedPhrase:
                            CreateNewWalletSeedPhraseView().navigationBarHidden(true).environmentObject(createWalletViewModel)
                        case .reInputSeedPhrase:
                            ReInputSeedPhraseView().navigationBarHidden(true).environmentObject(createWalletViewModel)
                        case .setupNickName:
                            SetupNickNameView().navigationBarHidden(true).environmentObject(createWalletViewModel)
                                .environmentObject(viewModel)
                        case .biometricSetup:
                            BiometricSetupView().navigationBarHidden(true).environmentObject(createWalletViewModel)
                        case .createNewWalletSuccess:
                            CreateNewWalletSuccessView(screenType: .newWallet).navigationBarHidden(true).environmentObject(createWalletViewModel)
                        case .createNewPassword:
                            CreateNewPasswordView().navigationBarHidden(true).environmentObject(createWalletViewModel)
                        }

                    case let .restoreWallet(screen):
                        switch screen {
                        case .restoreWallet:
                            RestoreWalletView().navigationBarHidden(true).environmentObject(restoreWalletViewModel)
                        case .seedPhrase:
                            RestoreWalletSeedPhraseView().navigationBarHidden(true).environmentObject(restoreWalletViewModel)
                        case .createNewWalletSuccess:
                            CreateNewWalletSuccessView(screenType: .restoreWallet).navigationBarHidden(true).environmentObject(restoreWalletViewModel)
                        case .createNewPassword:
                            RestoreWalletPasswordView().navigationBarHidden(true).environmentObject(restoreWalletViewModel)
                        case .importFile:
                            RestoreWalletImportFileView().navigationBarHidden(true)
                        case .biometricSetup:
                            BiometricSetupView().navigationBarHidden(true).environmentObject(createWalletViewModel)
                        }

                    case let .walletSetting(screen):
                        switch screen {
                        case .walletAccount:
                            WalletAccountView().navigationBarHidden(true)
                        case .changePassword:
                            ChangePasswordView().navigationBarHidden(true)
                        case .changePasswordSuccess:
                            ChangePasswordSuccessView().navigationBarHidden(true)
                        case .disconnectWallet:
                            DisconnectWalletView().navigationBarHidden(true)
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
                            ForgotPasswordView().navigationBarHidden(true)
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
