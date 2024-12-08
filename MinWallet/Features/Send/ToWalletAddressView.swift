import SwiftUI
import FlowStacks


struct ToWalletAddressView: View {
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>

    @FocusState
    private var focusedField: Bool

    @State
    private var address: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("To wallet address:")
                .font(.titleH5)
                .foregroundStyle(.colorBaseTent)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, .lg)
                .padding(.bottom, .xl)
                .padding(.horizontal, .xl)

            HStack(spacing: .md) {
                TextField("", text: $address)
                    .placeholder("Search, enter address or ADAHandle", when: address.isEmpty)
                    .lineLimit(1)
                    .focused($focusedField)
            }
            .padding(.horizontal, .xl)
            .padding(.vertical, .lg)
            .overlay(RoundedRectangle(cornerRadius: BorderRadius.full).stroke(.colorBorderPrimaryDefault, lineWidth: 1))
            .padding(.horizontal, .xl)
            .padding(.top, .lg)

            Spacer()
            CustomButton(title: "Next") {
                navigator.push(.sendToken(.confirm))
            }
            .frame(height: 56)
            .padding(.horizontal, .xl)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()

                Button("Done") {
                    focusedField = false
                }
                .foregroundStyle(.colorLabelToolbarDone)
            }
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
    ToWalletAddressView()
}
