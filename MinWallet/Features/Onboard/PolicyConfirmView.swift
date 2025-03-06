import SwiftUI
import FlowStacks

struct PolicyConfirmView: View {

    enum ScreenType {
        case splash
        case about
    }

    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>

    @State
    var screenType: ScreenType = .splash
    @StateObject
    private var webViewModel = WebViewModel()

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 5) {
                Image(.icSplash).resizable().frame(width: 32, height: 32)
                Text("minswap").font(.titleH6)
                    .foregroundStyle(.colorBaseSecond)
                Spacer()
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.top, .xl)
            ProgressView(value: webViewModel.progress, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle())
                .padding(.horizontal, .xl)
                .opacity(webViewModel.progress != 1 ? 1 : 0)
            WebView(urlString: MinWalletConstant.minAboutURL + "/headless/privacy-policy", viewModel: webViewModel)
                .padding(.top, Spacing.xl)
            CustomButton(
                title: "Confirm",
                variant: .primary,
                action: {
                    switch screenType {
                    case .splash:
                        navigator.push(.gettingStarted)
                    case .about:
                        navigator.pop()
                    }
                }
            )
            .frame(height: 56)
            .padding(.top, 24)
            .padding(.horizontal, Spacing.xl)
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 0)  // Adds 20 points of spacing at the bottom
        }
        .background(Color.colorBaseBackground)
    }
}

#Preview {
    PolicyConfirmView()
}
