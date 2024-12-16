import SwiftUI
import FlowStacks


struct SetupNickNameView: View {
    enum ScreenType {
        case createWallet
        case walletSetting
    }

    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    private var userInfo: UserInfo

    @FocusState
    private var isInputActive: Bool
    @State
    var seedPhrase: [String] = []
    @State
    private var nickName: String = ""

    @State
    var screenType: ScreenType

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Set up nickname")
                .font(.titleH5)
                .foregroundStyle(.colorBaseTent)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, .lg)
                .padding(.bottom, .xl)
                .padding(.horizontal, .xl)
            TextField("Give your wallet a nickname ...", text: $nickName)
                .font(.paragraphSmall)
                .foregroundStyle(.colorBaseTent)
                .focused($isInputActive)
                .padding(.horizontal, .xl)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            isInputActive = false
                        }
                        .foregroundStyle(.colorLabelToolbarDone)
                    }
                }
            Spacer()
            CustomButton(title: screenType == .createWallet ? "Next" : "Change") {
                switch screenType {
                case .createWallet:
                    navigator.push(.createWallet(.biometricSetup(seedPhrase: seedPhrase, nickName: nickName.trimmingCharacters(in: .whitespacesAndNewlines))))
                case .walletSetting:
                    userInfo.setupNickName(nickName.trimmingCharacters(in: .whitespacesAndNewlines))
                    navigator.pop()
                }
            }
            .frame(height: 56)
            .padding(.horizontal, .xl)
        }
        .modifier(
            BaseContentView(
                screenTitle: " ",
                actionLeft: {
                    navigator.pop()
                })
        )
        .task {
            guard screenType == .walletSetting else { return }
            nickName = userInfo.nickName
        }
    }
}

#Preview {
    SetupNickNameView(screenType: .createWallet)
        .environmentObject(UserInfo())
}
