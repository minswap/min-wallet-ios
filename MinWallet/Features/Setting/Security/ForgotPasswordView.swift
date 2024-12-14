import SwiftUI
import FlowStacks


struct ForgotPasswordView: View {
    enum ScreenType {
        case enterPassword
        case changeYourPassword(ChangePasswordView.ScreenType)
    }

    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    private var appSetting: AppSetting
    @EnvironmentObject
    private var userInfo: UserInfo
    @State
    private var conditionOne: Bool = false
    @State
    private var conditionTwo: Bool = false
    @State
    var screenType: ScreenType

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Forgot password")
                .font(.titleH5)
                .foregroundStyle(.colorBaseTent)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, .lg)
                .padding(.bottom, .xl)
                .padding(.horizontal, .xl)
            Text("Unlock your wallet using Face ID recognition or a password.")
                .font(.paragraphSmall)
                .foregroundStyle(.colorBaseTent)
                .padding(.horizontal, .xl)
                .padding(.top, .lg)
                .padding(.bottom, ._3xl)

            VStack(alignment: .leading, spacing: .xl) {
                HStack(spacing: .xl) {
                    Image(conditionOne ? .icChecked : .icUnchecked).resizable().frame(width: 20, height: 20)
                    Text("The seed phrase is only stored on your phone, and Minswap has no access to it to help you retrieve it")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                }
                .padding(.horizontal, .xl)
                .contentShape(.rect)
                .onTapGesture {
                    conditionOne.toggle()
                }
                Color.colorBorderPrimarySub.frame(height: 1)
                    .padding(.horizontal, .xl)
                HStack(spacing: .xl) {
                    Image(conditionTwo ? .icChecked : .icUnchecked).resizable().frame(width: 20, height: 20)
                    Text("The seed phrase is only stored on your phone, and Minswap has no access to it to help you retrieve it")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                }
                .padding(.horizontal, .xl)
                .contentShape(.rect)
                .onTapGesture {
                    conditionTwo.toggle()
                }
            }

            Spacer()
            let combinedBinding = Binding<Bool>(
                get: { conditionOne && conditionTwo },
                set: { newValue in
                    conditionOne = newValue
                    conditionTwo = newValue
                }
            )

            CustomButton(title: "Restore", isEnable: combinedBinding) {
                userInfo.deleteAccount()
                appSetting.deleteAccount()
                appSetting.rootScreen = .gettingStarted
                navigator.popToRoot()
                /*
                switch screenType {
                case .enterPassword:
                    break
                case .changeYourPassword(let screenType):
                    switch screenType {
                    case .setting:
                        userInfo.deleteAccount()
                        appSetting.deleteAccount()
                        appSetting.rootScreen = .gettingStarted
                        navigator.popToRoot()
                    case .walletSetting:
                        userInfo.deleteAccount()
                        appSetting.deleteAccount()
                        appSetting.rootScreen = .gettingStarted
                        navigator.popToRoot()
                    }
                }
                 */
            }
            .frame(height: 56)
            .padding(.horizontal, .xl)
            .disabled(!conditionOne || !conditionTwo)
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
    ForgotPasswordView(screenType: .enterPassword)
}
