import SwiftUI
import FlowStacks


struct EnterYourPasswordView: View {
    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    private var appSetting: AppSetting
    @EnvironmentObject
    private var hudState: HUDState
    @State
    private var password: String = ""
    @Binding
    var isShowEnterYourPassword: Bool
    @FocusState
    var isFocus: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Enter your password")
                .font(.titleH5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 60)
            VStack(spacing: 4) {
                Text("Password")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorBaseTent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, .lg)
                SecurePasswordTextField(placeHolder: "Create new spending password", text: $password)
                    .focused($isFocus)
                    .frame(height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: BorderRadius.full)
                            .stroke(isFocus ? .colorBorderPrimaryPressed : .colorBorderPrimaryDefault, lineWidth: isFocus ? 2 : 1)
                    )
            }
            Button(
                action: {
                    isShowEnterYourPassword = false
                    navigator.push(.securitySetting(.forgotPassword))
                },
                label: {
                    Text("Forgot password?")
                        .font(.paragraphSemi)
                        .foregroundStyle(.colorInteractiveToneHighlight)
                }
            )
            .padding(.top, .xl)
            .padding(.bottom, 40)
            CustomButton(title: "Confirm") {
                let currentPassword: String = (try? AppSetting.getPasswordFromKeychain(username: AppSetting.USER_NAME)) ?? ""
                guard currentPassword == password
                else {
                    return
                }
                hideKeyboard()
                appSetting.authenticationType = .password
                isShowEnterYourPassword = false
            }
            .frame(height: 56)
            .padding(.bottom, .md)
        }
        .padding(.horizontal, .xl)
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    VStack {
        EnterYourPasswordView(isShowEnterYourPassword: .constant(false))
        Spacer()
    }
}
