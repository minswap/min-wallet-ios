import SwiftUI
import FlowStacks


struct ChangePasswordSuccessView: View {
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image(.icToken)
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
            /*
            ZStack {
                HStack(alignment: .top) {
                    Image(.icTokenDark)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 172)
                        .padding(.top, 16.0)
                        .padding(.leading, -72)
                    Spacer()
                    Image(.icToken)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120)
                        .padding(.top, -16.0)
                        .padding(.trailing, -50)
                }
            }
            */
            Spacer()

            CustomButton(
                title: "Got it",
                variant: .primary,
                action: {
                    navigator.push(.home)
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
    ChangePasswordSuccessView()
}
