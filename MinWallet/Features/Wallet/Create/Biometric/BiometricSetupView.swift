import SwiftUI
import FlowStacks


struct BiometricSetupView: View {
    enum ScreenType {
        case createWallet(seedPhase: [String], nickName: String)
        case restoreWallet(seedPhase: [String], nickName: String)
    }

    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    private var appSetting: AppSetting
    @EnvironmentObject
    private var userInfo: UserInfo

    @State
    var screenType: ScreenType?
    @State
    private var showingAlert: Bool = false
    @State
    private var msg: String = ""

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
                        switch screenType {
                        case .createWallet(let seedPhrase, let nickName):
                            let seedPhrase = seedPhrase.joined(separator: " ")
                            let wallet = createWallet(phrase: seedPhrase, password: MinWalletConstant.passDefaultForFaceID, networkEnv: AppSetting.NetworkEnv.mainnet.rawValue, walletName: "FIX ME")
                            userInfo.saveWalletInfo(seedPhrase: seedPhrase, nickName: nickName, walletAddress: wallet.address)
                            appSetting.isLogin = true

                        case .restoreWallet:
                            //TODO: cuongnv check restore wallet
                            break
                        default:
                            break
                        }
                        navigator.push(.createWallet(.createNewWalletSuccess))

                    } catch {
                        msg = error.localizedDescription
                        showingAlert = true
                        appSetting.authenticationType = .password
                    }
                }
            }
            .frame(height: 56)
            .padding(.horizontal, .xl)
            CustomButton(title: "Create password", variant: .secondary) {
                switch screenType {
                case .createWallet(let seedPhase, let nickName):
                    navigator.push(.createWallet(.createNewPassword(seedPhrase: seedPhase, nickName: nickName)))

                case .restoreWallet(let seedPhase, let nickName):
                    navigator.push(.restoreWallet(.createNewPassword(seedPhrase: seedPhase, nickName: nickName)))

                default:
                    break
                }
            }
            .frame(height: 56)
            .padding(.horizontal, .xl)
        }
        .modifier(
            BaseContentView(
                screenTitle: " ",
                actionLeft: {
                    navigator.pop()
                })
        )
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Something went wrong!"), message: Text(msg), dismissButton: .default(Text("Got it!")))
        }
    }
}

#Preview {
    BiometricSetupView()
}
