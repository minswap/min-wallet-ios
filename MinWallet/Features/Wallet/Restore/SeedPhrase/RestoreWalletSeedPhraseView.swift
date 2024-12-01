import SwiftUI
import FlowStacks


struct RestoreWalletSeedPhraseView: View {
    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    private var viewModel: RestoreWalletViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Reinput seedphase")
                .font(.titleH5)
                .foregroundStyle(.color050B18FFFFFF78)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, .lg)
                .padding(.bottom, .xl)
                .padding(.horizontal, .xl)
            SeedPhraseContentView()
            Spacer()
            CustomButton(title: "Next") {
                navigator.push(.restoreWallet(.createNewPassword))
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
    RestoreWalletSeedPhraseView()
        .environmentObject(RestoreWalletViewModel())
        .frame(width: .infinity)
}

private struct SeedPhraseContentView: View {
    @EnvironmentObject
    private var viewModel: RestoreWalletViewModel
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text("Please write your seed phrase in the right order. You can paste directly from clipboard.")
                    .font(.paragraphSmall)
                    .foregroundStyle(.color050B18FFFFFF78)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, .xl)
                    .padding(.top, .lg)
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(0..<viewModel.seedPhrase.count, id: \.self) { index in
                        HStack() {
                            Text(String(index + 1))
                                .font(.paragraphSmall)
                                .foregroundStyle(.color050B1840FFFFFF38)
                                .frame(width: 20, alignment: .leading)
                            Text(viewModel.seedPhrase[index])
                                .font(.paragraphSmall)
                                .foregroundStyle(.color050B18FFFFFF78)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, 12)
                        .frame(height: 36)
                        .overlay(RoundedRectangle(cornerRadius: BorderRadius.full).stroke(.color050B1816FFFFFF16, lineWidth: 1))
                        .contentShape(.rect)
                        .padding(.bottom, .xl)
                    }
                }
                .padding(.top, .xl)
                .padding(.horizontal, .xl)
                .padding(.bottom, .xl)
            }
        }
    }
}
