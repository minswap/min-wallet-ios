import SwiftUI

struct EnterYourPasswordView: View {
    
    @EnvironmentObject
    var appSetting: AppSetting
    
    @State
    private var password: String = ""
    
    @Binding
    var isShowEnterYourPassword: Bool
    
    var onForgotPassword: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Spacer()
                    Color.colorBorderPrimaryDefault.frame(width: 36, height: 4)
                        .padding(.vertical, .md)
                    Spacer()
                }
                
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
                        .frame(height: 44)
                        .overlay(
                            RoundedRectangle(cornerRadius: BorderRadius.full)
                                .stroke(.colorBorderPrimaryDefault, lineWidth: 1)
                        )
                }
                Button(action: {
                    onForgotPassword()
                }, label: {
                    Text("Forgot password?")
                        .font(.paragraphSemi)
                        .foregroundStyle(.colorInteractiveToneHighlight)
                })
                .padding(.top, .xl)
                .padding(.bottom, 40)
                CustomButton(title: "Confirm") {
                    let currentPassword: String = (try? AppSetting.getPasswordFromKeychain(username: AppSetting.USER_NAME)) ?? ""
                    guard currentPassword == password 
                    else {
                    //TODOz: cuongnv show error
                        return
                    }
                    appSetting.authenticationType = .password
                    isShowEnterYourPassword = false
                }
                .frame(height: 56)
            }
            .padding(.horizontal, .xl)
            .background(content: {
                RoundedRectangle(cornerRadius: 24).fill(Color.colorBaseBackground)
            })
        }
        .frame(width: .infinity)
    }
}

#Preview {
    VStack {
        EnterYourPasswordView(isShowEnterYourPassword: .constant(false), onForgotPassword: {})
        Spacer()
    }
    .background(Color.black)
}
