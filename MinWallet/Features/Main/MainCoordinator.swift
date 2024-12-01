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
                            CreateNewWalletSuccessView(screenType: .restoreWallet).navigationBarBackButtonHidden(true).environmentObject(restoreWalletViewModel)
                        case .createNewPassword:
                            RestoreWalletPasswordView().navigationBarBackButtonHidden(true).environmentObject(restoreWalletViewModel)
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
