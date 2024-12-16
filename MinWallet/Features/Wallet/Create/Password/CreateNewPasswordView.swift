import SwiftUI
import FlowStacks


struct CreateNewPasswordView: View {
    enum ScreenType {
        case authenticationSetting
        case createWallet(seedPhrase: [String], nickName: String)
        case restoreWallet(seedPhrase: [String], nickName: String)
    }
    enum FocusedField: Hashable {
        case password, rePassword
    }

    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    var appSetting: AppSetting
    @EnvironmentObject
    var userInfo: UserInfo

    @State
    private var password: String = ""
    @State
    private var rePassword: String = ""
    @FocusState
    private var focusedField: FocusedField?

    @State
    var screenType: ScreenType

    var onCreatePasswordSuccess: ((String) -> Void)?

    @State
    private var passwordValidationMatched: [PasswordValidation] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Create your password")
                .font(.titleH5)
                .foregroundStyle(.colorBaseTent)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, .lg)
                .padding(.bottom, .xl)
                .padding(.horizontal, .xl)
            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: 4) {
                        Text("Password")
                            .font(.paragraphSmall)
                            .foregroundStyle(.colorBaseTent)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, .xl)
                            .padding(.top, .lg)
                        SecurePasswordTextField(placeHolder: "Create new spending password", text: $password)
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
                    if !password.isEmpty && passwordValidationMatched.count != PasswordValidation.allCases.count {
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
                        Text("Confirm")
                            .font(.paragraphSmall)
                            .foregroundStyle(.colorBaseTent)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, .xl)
                        SecurePasswordTextField(placeHolder: "Confirm spending password", text: $rePassword)
                            .focused($focusedField, equals: .rePassword)
                            .frame(height: 44)
                            .overlay(
                                RoundedRectangle(cornerRadius: BorderRadius.full)
                                    .stroke(focusedField == .rePassword ? .colorBorderPrimaryPressed : .colorBorderPrimaryDefault, lineWidth: focusedField == .rePassword ? 2 : 1)
                            )
                            .padding(.horizontal, .xl)
                    }
                    .padding(.vertical, .xl)
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
                    }
                }
            }

            Spacer()
            let combinedBinding = Binding<Bool>(
                get: { (passwordValidationMatched.count == PasswordValidation.allCases.count) && (password == rePassword) },
                set: { newValue in }
            )
            CustomButton(title: "Confirm", isEnable: combinedBinding) {
                switch screenType {
                case .authenticationSetting:
                    onCreatePasswordSuccess?(password)
                    navigator.pop()
                case let .createWallet(seedPhrase, nickName):
                    appSetting.authenticationType = .password
                    appSetting.isLogin = true
                    let seedPhrase = seedPhrase.joined(separator: " ")
                    let wallet = createWallet(phrase: seedPhrase, password: password, networkEnv: AppSetting.NetworkEnv.mainnet.rawValue)
                    userInfo.saveWalletInfo(seedPhrase: seedPhrase, nickName: nickName, walletAddress: wallet.address)

                    navigator.push(.createWallet(.createNewWalletSuccess))
                case let .restoreWallet(seedPhase, nickName):
                    //TODO: cuongnv restore wallet
                    appSetting.authenticationType = .password
                    appSetting.isLogin = true

                    navigator.push(.restoreWallet(.createNewWalletSuccess))
                }
            }
            .frame(height: 56)
            .padding(.horizontal, .xl)

            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        Text("")
                        Spacer()
                        Button("Done") {
                            focusedField = nil
                        }
                        .foregroundStyle(.colorLabelToolbarDone)
                    }
                }
            }
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
    CreateNewPasswordView(screenType: .authenticationSetting)
}
