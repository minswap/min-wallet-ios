import SwiftUI
import FlowStacks


struct SignContractView: View {
    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    private var userInfo: UserInfo
    @State
    private var password: String = ""
    @FocusState
    private var isFocus: Bool

    var onSignSuccess: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Sign the contract")
                .font(.titleH5)
                .foregroundStyle(.colorBaseTent)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 30)
                .padding(.bottom, .xl)
                .padding(.horizontal, .xl)
            VStack(spacing: 4) {
                Text("Password")
                    .font(.labelSmallSecondary)
                    .foregroundStyle(.colorBaseTent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, .xl)
                    .padding(.top, .lg)
                SecurePasswordTextField(placeHolder: "Enter your password", text: $password)
                    .focused($isFocus)
                    .frame(height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: BorderRadius.full)
                            .stroke(.colorBorderPrimaryDefault, lineWidth: 1)
                    )
                    .padding(.horizontal, .xl)
            }
            Spacer()
            HStack(spacing: .xl) {
                CustomButton(title: "Cancel", variant: .secondary) {

                }
                .frame(height: 56)
                CustomButton(title: "Confirm") {
                    guard let minWallet = userInfo.minWallet, !password.isBlank else { return }
                    let _ = signTx(wallet: minWallet, password: password, accountIndex: minWallet.accountIndex, txRaw: "")
                    navigator.dismiss()
                    onSignSuccess?()
                }
                .frame(height: 56)
            }
            .padding(.horizontal, .xl)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isFocus = false
                }
                .foregroundStyle(.colorLabelToolbarDone)
            }
        }
    }
}

#Preview {
    SignContractView()
}
