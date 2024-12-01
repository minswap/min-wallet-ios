import SwiftUI
import FlowStacks


struct SetupNickNameView: View {
    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    
    @EnvironmentObject
    private var viewModel: CreateNewWalletViewModel
    
    @FocusState
    private var isInputActive: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Set up nickname")
                .font(.titleH5)
                .foregroundStyle(.color050B18FFFFFF78)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, .lg)
                .padding(.bottom, .xl)
                .padding(.horizontal, .xl)
            
            TextField("Give your wallet a nickname ...", text: $viewModel.nickName)
                .font(.paragraphSmall)
                .foregroundStyle(.color050B18FFFFFF78)
                .focused($isInputActive)
                .padding(.horizontal, .xl)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        
                        Button("Done") {
                            isInputActive = false
                        }
                        .foregroundStyle(.color000000FFFFFF)
                    }
                }
            Spacer()
            CustomButton(title: "Next") {
                navigator.push(.createWallet(.biometricSetup))
            }
            .frame(height: 56)
            .padding(.horizontal, .xl)
        }
        .modifier(BaseContentView(
            screenTitle: " ",
            actionLeft: {
                viewModel.nickName = ""
                navigator.pop()
            }))
    }
}

#Preview {
    SetupNickNameView()
        .environmentObject(CreateNewWalletViewModel())
}
