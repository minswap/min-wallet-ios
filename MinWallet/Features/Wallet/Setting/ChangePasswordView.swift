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
    private var password: String = ""
    @State
    private var rePassword: String = ""
    @FocusState
    private var focusedField: FocusedField?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Change password")
                .font(.titleH5)
                .foregroundStyle(.colorBaseTent)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, .lg)
                .padding(.bottom, .xl)
                .padding(.horizontal, .xl)
            VStack(spacing: 4) {
                Text("Old Password")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorBaseTent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, .xl)
                    .padding(.top, .lg)
                SecurePasswordTextField(placeHolder: "Enter old password", text: $password)
                    .focused($focusedField, equals: .oldPassword)
                    .frame(height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: BorderRadius.full)
                            .stroke(.colorBorderPrimaryDefault, lineWidth: 1)
                    )
                    .padding(.horizontal, .xl)
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
                            .stroke(.colorBorderPrimaryDefault, lineWidth: 1)
                    )
                    .padding(.horizontal, .xl)
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
                            .stroke(.colorBorderPrimaryDefault, lineWidth: 1)
                    )
                    .padding(.horizontal, .xl)
            }
            .padding(.vertical, .xl)


            Spacer()
            CustomButton(title: "Change") {
                viewModel.password = password
                navigator.push(.createWallet(.createNewWalletSuccess))
            }
            .frame(height: 56)
            .padding(.horizontal, .xl)
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
        .onAppear(perform: {
            focusedField = .oldPassword
        })
        .modifier(
            BaseContentView(
                screenTitle: " ",
                actionLeft: {
                    navigator.pop()
                }))
    }
}

#Preview {
    ChangePasswordView()
        .environmentObject(CreateNewWalletViewModel())
}
