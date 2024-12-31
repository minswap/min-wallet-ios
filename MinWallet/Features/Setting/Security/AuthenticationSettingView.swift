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
                Task {
                    do {
                        try await appSetting.reAuthenticateUser()
                        appSetting.authenticationType = .biometric
                    } catch {
                        hudState.showMsg(msg: error.localizedDescription)
                    }
                }
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
                let password: String = (try? AppSetting.getPasswordFromKeychain(username: AppSetting.USER_NAME)) ?? ""
                if password.isEmpty {
                    let createPasswordSuccess: ((String) -> Void)? = { password in
                        appSetting.authenticationType = .password
                        do {
                            try AppSetting.savePasswordToKeychain(username: AppSetting.USER_NAME, password: password)
                        } catch {
                            hudState.showMsg(msg: error.localizedDescription)
                        }
                    }
                    navigator.push(.securitySetting(.createPassword(onCreatePassSuccess: SecuritySetting.CreatePassSuccess(onCreatePassSuccess: createPasswordSuccess))))
                } else {
                    isShowEnterYourPassword = true
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
        .popupSheet(
            isPresented: $isShowEnterYourPassword,
            content: {
                EnterYourPasswordView(isShowEnterYourPassword: $isShowEnterYourPassword).padding(.top, .xl)
            }
        )
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
