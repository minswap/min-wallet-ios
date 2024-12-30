import SwiftUI
import FlowStacks


struct EditNickNameView: View {
    @EnvironmentObject
    private var userInfo: UserInfo
    @EnvironmentObject
    private var appSetting: AppSetting
    @State
    private var nickName: String = ""
    @Binding
    var showEditNickName: Bool
    @FocusState
    var isFocus: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Edit nickname")
                .font(.titleH5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 60)
            VStack(spacing: 4) {
                Text("Nickname")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorBaseTent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, .lg)
                TextField("", text: $nickName)
                    .placeholder("Enter your wallet nickname", when: nickName.isEmpty)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    .focused($isFocus)
                    .frame(height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: BorderRadius.full)
                            .stroke(isFocus ? .colorBorderPrimaryPressed : .colorBorderPrimaryDefault, lineWidth: isFocus ? 2 : 1)
                    )
            }
            HStack(spacing: .xl) {
                CustomButton(title: "Cancel", variant: .secondary) {
                    hideKeyboard()
                    showEditNickName = false
                }
                .frame(height: 56)
                CustomButton(title: "Confirm") {
                    let nickName = nickName.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard let minWallet = userInfo.minWallet, !nickName.isBlank else { return }
                    guard let minWallet = changeWalletName(wallet: minWallet, password: appSetting.password, newWalletName: nickName.trimmingCharacters(in: .whitespacesAndNewlines)) else { return }
                    userInfo.saveWalletInfo(walletInfo: minWallet)
                    showEditNickName = false
                }
                .frame(height: 56)
            }
            .padding(.bottom, .md)
            .padding(.top, 40)
        }
        .padding(.horizontal, .xl)
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    VStack {
        EditNickNameView(showEditNickName: .constant(false))
        Spacer()
    }
}
