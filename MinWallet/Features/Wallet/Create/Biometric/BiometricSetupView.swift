import SwiftUI
import FlowStacks


struct BiometricSetupView: View {
    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    private var appSetting: AppSetting
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Spacer()
            VStack(alignment: .center, spacing: 16) {
                Image(.icFaceId)
                Text("Choose your best way to log-in")
                    .font(.titleH5)
                    .foregroundStyle(.color050B18FFFFFF78)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, .xl)
                Text("Please write down your 24 words seed phrase and store it in a secured place.")
                    .font(.paragraphSmall)
                    .foregroundStyle(.color050B18FFFFFF78)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, .xl)
            }
           
            Spacer()
            CustomButton(title: "Use FaceID") {
                Task {
                    do {
                        try await appSetting.biometricAuthentication.authenticateUser()
                        appSetting.enableBiometric = true
                        navigator.push(.createWallet(.createNewWalletSuccess))
                    } catch { error
                        //TODO: cuongnv show error
                        appSetting.enableBiometric = false
                    }
                }
            }
            .frame(height: 56)
            .padding(.horizontal, .xl)
            CustomButton(title: "Create password", variant: .secondary) {
                navigator.push(.createWallet(.createNewPassword))
            }
            .frame(height: 56)
            .padding(.horizontal, .xl)
        }
        .modifier(BaseContentView(
            screenTitle: " ",
            actionLeft: {
                navigator.pop()
            }))
    }
}

#Preview {
    BiometricSetupView()
}
