import SwiftUI
import FlowStacks


struct BiometricSetupView: View {
    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    private var appSetting: AppSetting

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .center, spacing: 16) {
                Image(.icFaceId)
                Text("Choose your best way to log-in")
                    .font(.titleH5)
                    .foregroundStyle(.colorBaseTent)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, .xl)
                Text("Please write down your 24 words seed phrase and store it in a secured place.")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorBaseTent)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, .xl)
            }
            .padding(.top, 24)
            Spacer()
            CustomButton(title: "Use FaceID") {
                Task {
                    do {
                        try await appSetting.biometricAuthentication.authenticateUser()
                        appSetting.authenticationType = .biometric
                        navigator.push(.createWallet(.createNewWalletSuccess))
                    } catch {
                        error
                        //TODOZ: cuongnv show error
                        appSetting.authenticationType = .password
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
        .modifier(
            BaseContentView(
                screenTitle: " ",
                actionLeft: {
                    navigator.pop()
                }))
    }
}

#Preview {
    BiometricSetupView()
}
