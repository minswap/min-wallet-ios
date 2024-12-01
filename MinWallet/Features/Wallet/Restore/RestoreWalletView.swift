import SwiftUI
import FlowStacks


struct RestoreWalletView: View {
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Restore wallet")
                .font(.titleH5)
                .foregroundStyle(.color050B18FFFFFF78)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, .lg)
                .padding(.bottom, .xl)
                .padding(.horizontal, .xl)
            HStack(alignment: .top, spacing: .md) {
                Image(.icChecked)
                    .padding(.top, 2)
                VStack(alignment: .leading) {
                    Text("Seedphrase")
                        .font(.titleH7)
                        .foregroundStyle(.color050B18FFFFFF78)
                    Text("Restore using seed phrase")
                        .font(.paragraphSmall)
                        .foregroundStyle(.color050B1856FFFFFF48)
                }
                Spacer()
            }
            .padding(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(.color001947FFFFFF, lineWidth: 2))
            .contentShape(.rect)
            .padding(.horizontal, .xl)
            .padding(.top, .lg)
          
            Spacer()
            CustomButton(title: "Restore") {
                navigator.push(.restoreWallet(.seedPhrase))
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
    RestoreWalletView()
}
