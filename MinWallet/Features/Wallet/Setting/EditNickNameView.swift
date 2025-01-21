import SwiftUI
import Combine
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
                TextField("", text: $nickName.max(10))
                    .placeholder("Enter your wallet nickname", when: nickName.isEmpty)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    .focused($isFocus)
                    .frame(height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: BorderRadius.full)
                            .stroke(isFocus ? .colorBorderPrimaryPressed : .colorBorderPrimaryDefault, lineWidth: isFocus ? 2 : 1)
                    )
                    .onReceive(Just(nickName)) { _ in
                        if nickName.count > 40 {
                            nickName = String(nickName.prefix(40))
                        }
                    }
            }
            if !nickName.isEmpty && nickName.count < 3 {
                Text("A wallet name must be 3-40 characters")
                    .font(.paragraphSmall)
                    .foregroundStyle(.red)
                    .padding(.top, .md)
                    .padding(.horizontal, .xl)
            }
            HStack(spacing: .xl) {
                CustomButton(title: "Cancel", variant: .secondary) {
                    hideKeyboard()
                    showEditNickName = false
                }
                .frame(height: 56)
                let combinedBinding = Binding<Bool>(
                    get: { nickName.trimmingCharacters(in: .whitespacesAndNewlines).count >= 3 },
                    set: { _ in }
                )
                CustomButton(title: "Confirm", isEnable: combinedBinding) {
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
