import SwiftUI
import FlowStacks

struct PolicyConfirmView: View {

    enum ScreenType {
        case splash
        case about
    }

    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    private var preloadWebVM: PreloadWebViewModel
    @State
    var screenType: ScreenType = .splash

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
            /*
            ProgressView(value: preloadWebVM.progress, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle())
                .padding(.horizontal, .xl)
                .opacity(preloadWebVM.progress != 1 ? 1 : 0)
             */
            PreloadWebViewPolicy(preloadWebVM: preloadWebVM)
                .padding(.top, Spacing.md)
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
