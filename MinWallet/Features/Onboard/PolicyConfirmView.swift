import SwiftUI
import FlowStacks

struct PolicyConfirmView: View {

    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 5) {
                Image(.icSplash).resizable().frame(width: 32, height: 32)
                Text("minswap").font(.titleH6)
                    .foregroundStyle(.colorBaseSecond)
                Spacer()
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.top, .xl)
            ScrollView {
                Text("policy_content")
                    .font(.labelMediumSecondary)
                    .foregroundStyle(.colorBaseTent)
                    .padding(.horizontal, Spacing.xl)
                    .padding(.top, Spacing.xl)
            }
            CustomButton(
                title: "Confirm",
                variant: .primary,
                action: {
                    navigator.push(.gettingStarted)
                }
            )
            .frame(height: 56)
            .padding(.top, 24)
            .padding(.horizontal, Spacing.xl)
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 0)  // Adds 20 points of spacing at the bottom
        }
        .background(Color.colorBaseBackground)
    }
}

#Preview {
    PolicyConfirmView()
}
