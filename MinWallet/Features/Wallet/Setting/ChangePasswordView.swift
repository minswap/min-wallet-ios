import SwiftUI
import FlowStacks


struct ChangePasswordView: View {
    enum FocusedField: Hashable {
        case oldPassword, password, rePassword
    }

    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>

    @EnvironmentObject
    private var viewModel: CreateNewWalletViewModel

    @State
    private var oldPassword: String = ""
    @State
    private var password: String = ""
    @State
    private var rePassword: String = ""
    @FocusState
    private var focusedField: FocusedField?

    @State
    private var passwordValidationMatched: [PasswordValidation] = []

    @State
    private var currentPassword: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Change password")
                .font(.titleH5)
                .foregroundStyle(.colorBaseTent)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, .lg)
                .padding(.bottom, .xl)
                .padding(.horizontal, .xl)
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(spacing: 4) {
                        Text("Old Password")
                            .font(.paragraphSmall)
                            .foregroundStyle(.colorBaseTent)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, .xl)
                            .padding(.top, .lg)
                        SecurePasswordTextField(placeHolder: "Enter old password", text: $oldPassword)
                            .focused($focusedField, equals: .oldPassword)
                            .frame(height: 44)
                            .overlay(
                                RoundedRectangle(cornerRadius: BorderRadius.full)
                                    .stroke(focusedField == .oldPassword ? .colorBorderPrimaryPressed : .colorBorderPrimaryDefault, lineWidth: focusedField == .oldPassword ? 2 : 1)
                            )
                            .padding(.horizontal, .xl)
                    }
                    if !oldPassword.isEmpty && currentPassword != oldPassword {
                        HStack(spacing: .xs) {
                            Image(.icWarning)
                                .resizable()
                                .frame(width: 16, height: 16)
                            Text("Password incorrect")
                                .font(.paragraphXSmall)
                                .foregroundStyle(.colorInteractiveToneDanger)
                            Spacer()
                        }
                        .padding(.horizontal, .xl)
                        .padding(.top, .md)
                    }
                    VStack(spacing: 4) {
                        Text("New Password")
                            .font(.paragraphSmall)
                            .foregroundStyle(.colorBaseTent)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, .xl)
                            .padding(.top, .lg)
                        SecurePasswordTextField(placeHolder: "Enter new password", text: $password)
                            .focused($focusedField, equals: .password)
                            .frame(height: 44)
                            .overlay(
                                RoundedRectangle(cornerRadius: BorderRadius.full)
                                    .stroke(focusedField == .password ? .colorBorderPrimaryPressed : .colorBorderPrimaryDefault, lineWidth: focusedField == .password ? 2 : 1)
                            )
                            .padding(.horizontal, .xl)
                            .onChange(of: password) { newValue in
                                passwordValidationMatched = PasswordValidation.validateInput(password: newValue)
                            }
                    }
                    if !password.isEmpty {
                        VStack(spacing: 10) {
                            Text("Your password must contain:")
                                .font(.paragraphXSmall)
                                .foregroundStyle(.colorBaseTent)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            ForEach(PasswordValidation.allCases) { validation in
                                HStack(spacing: .md) {
                                    Image(passwordValidationMatched.contains(validation) ? .icChecked : .icUnchecked)
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                    Text(validation.rawValue)
                                        .font(.paragraphXSmall)
                                        .foregroundStyle(!passwordValidationMatched.contains(validation) ? .colorInteractiveTentPrimarySub : .colorBaseTent)
                                    Spacer()
                                }
                            }
                        }
                        .padding(.horizontal, .xl)
                        .padding(.top, .xl)
                    }
                    VStack(spacing: 4) {
                        Text("Confirm new password")
                            .font(.paragraphSmall)
                            .foregroundStyle(.colorBaseTent)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, .xl)
                        SecurePasswordTextField(placeHolder: "Enter new password", text: $rePassword)
                            .focused($focusedField, equals: .rePassword)
                            .frame(height: 44)
                            .overlay(
                                RoundedRectangle(cornerRadius: BorderRadius.full)
                                    .stroke(focusedField == .rePassword ? .colorBorderPrimaryPressed : .colorBorderPrimaryDefault, lineWidth: focusedField == .rePassword ? 2 : 1)
                            )
                            .padding(.horizontal, .xl)
                            .ignoresSafeArea(.keyboard, edges: .bottom)
                    }
                    .padding(.top, .xl)
                    .padding(.bottom, rePassword.isEmpty ? .xl : .md)
                    if !rePassword.isEmpty {
                        HStack(spacing: .xs) {
                            Image(password == rePassword ? .icChecked : .icWarning)
                                .resizable()
                                .frame(width: 16, height: 16)
                            Text(password == rePassword ? "Password is match" : "Password is not match")
                                .font(.paragraphXSmall)
                                .foregroundStyle(password == rePassword ? .colorBaseSecond : .colorInteractiveToneDanger)
                            Spacer()
                        }
                        .padding(.horizontal, .xl)
                        .padding(.bottom, .xl)
                    }
                    Button(
                        action: {
                        },
                        label: {
                            Text("Forgot password?")
                                .font(.paragraphSemi)
                                .foregroundStyle(.colorInteractiveToneHighlight)
                        }
                    )
                    .padding(.horizontal, .xl)
                    .padding(.bottom, 40)
                }
            }
            Spacer()
            if focusedField == nil {
                CustomButton(title: "Change") {
                    viewModel.password = password
                    navigator.push(.createWallet(.createNewWalletSuccess))
                }
                .frame(height: 56)
                .padding(.horizontal, .xl)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()

                Button("Done") {
                    focusedField = nil
                }
                .foregroundStyle(.colorLabelToolbarDone)
            }
        }
        .modifier(
            BaseContentView(
                screenTitle: " ",
                actionLeft: {
                    navigator.pop()
                })
        )
        .task {
            print("WTF ?? ddd")
            currentPassword = "123"
        }
    }
}

#Preview {
    ChangePasswordView()
        .environmentObject(CreateNewWalletViewModel())
}
