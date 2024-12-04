import SwiftUI
import FlowStacks


struct AuthenticationSettingView: View {
    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    
    @EnvironmentObject
    private var appSetting: AppSetting
    @State
    private var isShowEnterYourPassword: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Authentication")
                .font(.titleH5)
                .foregroundStyle(.colorBaseTent)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, .lg)
                .padding(.bottom, .xl)
                .padding(.horizontal, .xl)
            Text("Unlock your wallet using \(appSetting.biometricAuthentication.displayName.toString()) recognition or a password.")
                .font(.paragraphSmall)
                .foregroundStyle(.colorBaseTent)
                .padding(.horizontal, .xl)
                .padding(.top, .lg)
                .padding(.bottom, ._3xl)
            
            HStack {
                Text(appSetting.biometricAuthentication.displayName)
                    .font(.paragraphSmall)
                    .foregroundStyle(appSetting.authenticationType == .biometric ? .colorInteractiveToneHighlight: .colorBaseTent)
                Spacer()
                if appSetting.authenticationType == .biometric {
                    Image(.icChecked)
                }
            }
            .padding(.horizontal, .xl)
            .frame(height: 52)
            .contentShape(.rect)
            .onTapGesture {
                guard appSetting.authenticationType != .biometric else { return }
            }
            HStack {
                Text("Password")
                    .font(.paragraphSmall)
                    .foregroundStyle(appSetting.authenticationType == .password ? .colorInteractiveToneHighlight: .colorBaseTent)
                Spacer()
                if appSetting.authenticationType == .password {
                    Image(.icChecked)
                }
            }
            .padding(.horizontal, .xl)
            .frame(height: 52)
            .contentShape(.rect)
            .onTapGesture {
                guard appSetting.authenticationType != .biometric else { return }
                let password: String = (try? AppSetting.getPasswordFromKeychain(username: AppSetting.USER_NAME)) ?? ""
                
                if password.isEmpty {
                    navigator.push(.securitySetting(.createPassword))
                } else {
                    isShowEnterYourPassword = true
                }
            }
            
            Spacer()
        }
        .modifier(BaseContentView(
            screenTitle: " ",
            actionLeft: {
                navigator.pop()
            }))
        .presentSheet(isPresented: $isShowEnterYourPassword, height: 600) {
            EnterYourPasswordView(isShowEnterYourPassword: $isShowEnterYourPassword, onForgotPassword: {
                isShowEnterYourPassword = false
                DispatchQueue.main.async {
                    navigator.push(.securitySetting(.forgotPassword))
                }
            })
        }
    }
}

#Preview {
    AuthenticationSettingView()
        .environmentObject(AppSetting())
}
