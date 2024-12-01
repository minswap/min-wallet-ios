import SwiftUI
import FlowStacks


struct RestoreWalletPasswordView: View {
    enum FocusedField: Hashable {
        case nickName, password, rePassword
    }
    
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    
    @EnvironmentObject
    private var viewModel: RestoreWalletViewModel
    
    @State
    private var password: String = ""
    @State
    private var rePassword: String = ""
    @FocusState
    private var focusedField: FocusedField?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Create new wallet")
                .font(.titleH5)
                .foregroundStyle(.color050B18FFFFFF78)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, .lg)
                .padding(.bottom, .xl)
                .padding(.horizontal, .xl)
            VStack(spacing: 8) {
                Text("Give your wallet a nickname")
                    .font(.paragraphSmall)
                    .foregroundStyle(.color050B18FFFFFF78)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, .xl)
                    .padding(.top, .lg)
                TextField("", text: $viewModel.nickName)
                    .placeholder("Wallet 1", when: viewModel.nickName.isEmpty)
                    .font(.paragraphSmall)
                    .focused($focusedField, equals: .nickName)
                    .padding(.horizontal, .lg)
                    .frame(height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: BorderRadius.full).stroke(.color050B1816FFFFFF16, lineWidth: 1)
                    )
                    .padding(.horizontal, .xl)
            }
            VStack(spacing: 4) {
                /*
                Text("Password")
                    .font(.paragraphSmall)
                    .foregroundStyle(.color050B18FFFFFF78)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, .xl)
                    .padding(.top, .lg)
                 */
                SecurePasswordTextField(placeHolder: "Create new spending password", text: $password)
                    .focused($focusedField, equals: .password)
                    .frame(height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: BorderRadius.full).stroke(.color050B1816FFFFFF16, lineWidth: 1)
                    )
                    .padding(.horizontal, .xl)
            }
            .padding(.top, .xl)
            VStack(spacing: 4) {
                /*
                Text("Confirm")
                    .font(.paragraphSmall)
                    .foregroundStyle(.color050B18FFFFFF78)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, .xl)
                 */
                SecurePasswordTextField(placeHolder: "Confirm spending password", text: $rePassword)
                    .focused($focusedField, equals: .rePassword)
                    .frame(height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: BorderRadius.full)
                            .stroke(.color050B1816FFFFFF16, lineWidth: 1)
                    )
                    .padding(.horizontal, .xl)
            }
            .padding(.vertical, .xl)
            
            Spacer()
            CustomButton(title: "Confirm") {
                viewModel.password = password
                navigator.push(.createWallet(.createNewWalletSuccess))
            }
            .frame(height: 56)
            .padding(.horizontal, .xl)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button("Done") {
                    focusedField = nil
                }
                .foregroundStyle(.color000000FFFFFF)
            }
        }
        .onAppear(perform: {
            //focusedField = .nickName
        })
        .modifier(BaseContentView(
            screenTitle: " ",
            actionLeft: {
                navigator.pop()
            }))
    }
}

#Preview {
    RestoreWalletPasswordView()
        .environmentObject(RestoreWalletViewModel())
}
