import SwiftUI
import FlowStacks


struct ChangePasswordSuccessView: View {
    enum ScreenType {
        case setting
        case walletSetting
    }

    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>

    var screenType: ScreenType

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image(.icChangePasswordSuccess)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
                .padding(.top, 56)
            Text("Password Changed")
                .font(.titleH4)
                .padding(.top, .xl)
                .foregroundStyle(.colorBaseTent)
            Text("Your password has been successfully changed.")
                .font(.labelMediumSecondary)
                .foregroundStyle(.colorBaseTent)
                .multilineTextAlignment(.center)
                .padding(.top, .xl)
                .padding(.horizontal, 16.0)
            Spacer()
            CustomButton(
                title: "Got it",
                variant: .primary,
                action: {
                    switch screenType {
                    case .setting:
                        if !navigator.popTo(.home) {
                            navigator.popToRoot()
                        }
                    case .walletSetting:
                        break
                    }
                }
            )
            .frame(height: 56)
            .padding(.horizontal, Spacing.xl)
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 0)
            }
        }
        .background(.colorBaseBackground)
    }
}

#Preview {
    ChangePasswordSuccessView(screenType: .setting)
}
