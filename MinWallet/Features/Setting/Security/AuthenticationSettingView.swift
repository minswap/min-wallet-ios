import SwiftUI
import FlowStacks


struct AuthenticationSettingView: View {
    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    private var appSetting: AppSetting
    @EnvironmentObject
    private var hudState: HUDState
    @State
    private var isShowEnterYourPassword: Bool = false
    @FocusState
    private var isFocus: Bool
    @State
    private var authenticationTypeSelected: AppSetting.AuthenticationType = .password

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
                    .foregroundStyle(appSetting.authenticationType == .biometric ? .colorInteractiveToneHighlight : .colorBaseTent)
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
                authenticationTypeSelected = .biometric
                $isShowEnterYourPassword.showSheet()
            }
            HStack {
                Text("Password")
                    .font(.paragraphSmall)
                    .foregroundStyle(appSetting.authenticationType == .password ? .colorInteractiveToneHighlight : .colorBaseTent)
                Spacer()
                if appSetting.authenticationType == .password {
                    Image(.icChecked)
                }
            }
            .padding(.horizontal, .xl)
            .frame(height: 52)
            .contentShape(.rect)
            .onTapGesture {
                guard appSetting.authenticationType != .password else { return }
                Task {
                    do {
                        try await appSetting.reAuthenticateUser()
                        let createPasswordSuccess: ((String) -> Void)? = { password in
                            do {
                                try AppSetting.savePasswordToKeychain(username: AppSetting.USER_NAME, password: password)
                                appSetting.authenticationType = .password
                            } catch {
                                hudState.showMsg(msg: error.localizedDescription)
                            }
                        }
                        navigator.push(.securitySetting(.createPassword(onCreatePassSuccess: SecuritySetting.CreatePassSuccess(onCreatePassSuccess: createPasswordSuccess))))
                    } catch {
                        //TODO: print sau
                    }
                }
            }
            Spacer()
        }
        .modifier(
            BaseContentView(
                screenTitle: " ",
                actionLeft: {
                    navigator.pop()
                })
        )
        .presentSheet(isPresented: $isShowEnterYourPassword) {
            EnterYourPasswordView(authenticationType: $authenticationTypeSelected)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    hideKeyboard()
                }
                .foregroundStyle(.colorLabelToolbarDone)
            }
        }
    }
}

#Preview {
    AuthenticationSettingView()
        .environmentObject(AppSetting.shared)
}
