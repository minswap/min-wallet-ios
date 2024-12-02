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
