import SwiftUI
import FlowStacks


struct ReInputSeedPhraseView: View {
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @FocusState
    private var isFocus: Bool
    @State
    private var inputSeedPhrase: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Re-input your seed phrase")
                .font(.titleH5)
                .foregroundStyle(.colorBaseTent)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, .lg)
                .padding(.bottom, .xl)
                .padding(.horizontal, .xl)
            SeedPhraseTextField(
                text: $inputSeedPhrase,
                typingColor: .colorBaseTent,
                completedColor: .colorInteractiveToneHighlight
            )
            .focused($isFocus)
            .padding(.horizontal, .xl)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()

                    Button("Done") {
                        isFocus = false
                    }
                    .foregroundStyle(.colorLabelToolbarDone)
                }
            }
            Spacer()
            HStack {
                Spacer()
                Button(
                    action: {
                        if let clipBoardText = UIPasteboard.general.string {
                            inputSeedPhrase = clipBoardText
                        }
                    },
                    label: {
                        Text("Paste")
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorInteractiveTentSecondarySub)
                    }
                )
                .frame(height: 28)
                .padding(.horizontal, .lg)
                .background(.colorBaseBackground)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: BorderRadius.full).stroke(.colorBorderPrimarySub, lineWidth: 1)
                })
            }
            .padding(.bottom, 34)
            .padding(.top, .xl)
            .padding(.horizontal, .xl)

            CustomButton(title: "Next") {
                navigator.push(.createWallet(.setupNickName))
            }
            .frame(height: 56)
            .padding(.horizontal, .xl)
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
    ReInputSeedPhraseView()
        .environmentObject(CreateNewWalletViewModel())
}
