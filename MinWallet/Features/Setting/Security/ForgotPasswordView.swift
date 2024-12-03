import SwiftUI
import FlowStacks


struct ForgotPasswordView: View {
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Authentication")
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
                    Image(.icChecked).resizable().frame(width: 20, height: 20)
                    Text("The seed phrase is only stored on your phone, and Minswap has no access to it to help you retrieve it")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                }
                .padding(.horizontal, .xl)
                Color.colorBorderPrimarySub.frame(height: 1)
                    .padding(.horizontal, .xl)
                HStack(spacing: .xl) {
                    Image(.icUnchecked).resizable().frame(width: 20, height: 20)
                    Text("The seed phrase is only stored on your phone, and Minswap has no access to it to help you retrieve it")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                }
                .padding(.horizontal, .xl)
            }
            
            Spacer()
            CustomButton(title: "Restore") {
            }
            .frame(height: 56)
            .padding(.horizontal, .xl)
        }
        .modifier(BaseContentView(
            screenTitle: " ",
            actionLeft: {
                navigator.pop()
            }))
    }
}

#Preview {
    ForgotPasswordView()
}
