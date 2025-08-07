import SwiftUI
import FlowStacks


struct TermOfServiceView: View {
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @StateObject
    private var webViewModel = WebViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            ProgressView(value: webViewModel.progress, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle())
                .padding(.horizontal, .xl)
                .padding(.top, .md)
                .opacity(webViewModel.progress != 1 ? 1 : 0)
            WebView(urlString: MinWalletConstant.minPolicyURL + "/headless/terms-of-service", viewModel: webViewModel)
        }
        .modifier(
            BaseContentView(
                screenTitle: " ",
                actionLeft: {
                    navigator.pop()
                })
        )
    }
}

#Preview {
    TermOfServiceView()
}
