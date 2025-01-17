import SwiftUI
import FlowStacks


struct ReInputSeedPhraseView: View {
    enum ScreenType {
        case createWallet(seedPhrase: [String])
        case restoreWallet
    }

    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @FocusState
    private var isFocus: Bool
    @State
    private var inputSeedPhrase: String = ""
    @State
    var screenType: ScreenType

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
                            inputSeedPhrase = clipBoardText + " "
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
            let enableNext = Binding<Bool>(
                get: { !inputSeedPhrase.isBlank },
                set: { newValue in }
            )
            CustomButton(title: "Next", isEnable: enableNext) {
                switch screenType {
                case let .createWallet(seedPhrase):
                    guard inputSeedPhrase.trimmingCharacters(in: .whitespacesAndNewlines) == seedPhrase.joined(separator: " ") else { return }
                    navigator.push(.createWallet(.setupNickName(seedPhrase: seedPhrase)))
                case .restoreWallet:
                    guard !inputSeedPhrase.isBlank else { return }
                    navigator.push(.restoreWallet(.biometricSetup(fileContent: "", seedPhrase: inputSeedPhrase.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: " ").map({ String($0) }), nickName: "")))
                }
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
    ReInputSeedPhraseView(screenType: .restoreWallet)
}
