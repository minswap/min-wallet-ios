import SwiftUI
import FlowStacks


struct CreateNewWalletSeedPhraseView: View {
    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    private var viewModel: CreateNewWalletViewModel

    @State
    var copied: Bool = false
    @State
    var isRevealPhrase: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Create new wallet")
                .font(.titleH5)
                .foregroundStyle(.colorBaseTent)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, .lg)
                .padding(.bottom, .xl)
                .padding(.horizontal, .xl)
            SeedPhraseContentView(isRevealPhrase: $isRevealPhrase)
            Spacer()

            if isRevealPhrase {
                SeedPhraseCopyView(copied: $copied)
                    .padding(.horizontal, .xl)
            } else {
                SeedPhraseRevealView(isRevealPhrase: $isRevealPhrase)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, .xl)
                    //.mask(Rectangle().cornerRadius(40, corners: [.topLeft, .topRight]))
                    .overlay(
                        Rectangle().stroke(.colorBorderPrimarySub, lineWidth: 1)
                            .cornerRadius(20, corners: [.topRight, .topLeft])
                    )
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
    CreateNewWalletSeedPhraseView()
        .environmentObject(CreateNewWalletViewModel())
        .frame(width: .infinity)
    //    SeedPhraseRevealView()
}


private struct SeedPhraseRevealView: View {
    @Binding
    var isRevealPhrase: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(.icReveal)
                .resizable()
                .frame(width: 60, height: 60)
                .padding(.vertical, .xl)
                .onTapGesture {
                    withAnimation {
                        isRevealPhrase = true
                    }
                }
            Text("Tap to reveal seed phrase")
                .font(.titleH7)
                .foregroundStyle(.colorInteractiveToneHighlight)
                .padding(.bottom, .md)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Make sure no one is looking at your screen")
                .font(.paragraphSmall)
                .foregroundStyle(.colorInteractiveTentPrimarySub)
                .padding(.bottom, .xl)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}


private struct SeedPhraseCopyView: View {
    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>

    @Binding var copied: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 8) {
                Image(.icSquareCheckBox)
                Text("I have written the seed phrase and stored it in a secured place.")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            HStack(spacing: .xl) {
                CustomButton(
                    title: copied ? "Copied" : "Copy",
                    variant: .secondary,
                    iconRight: copied ? .icCheckMark : .icCopySeedPhrase
                ) {
                    copied = true
                }
                .frame(height: 56)

                CustomButton(title: "Next") {
                    navigator.push(.createWallet(.reInputSeedPhrase))
                }
                .frame(height: 56)
            }
        }
    }
}


private struct SeedPhraseContentView: View {
    @Binding
    var isRevealPhrase: Bool
    @EnvironmentObject
    private var viewModel: CreateNewWalletViewModel

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text("Please write down your 24 words seed phrase and store it in a secured place.")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorBaseTent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, .xl)
                    .padding(.top, .lg)
                    .padding(.bottom, ._3xl)
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(0..<viewModel.seedPhrase.count, id: \.self) { index in
                        HStack() {
                            Text(String(index + 1))
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorInteractiveTentPrimaryDisable)
                                .frame(width: 20, alignment: .leading)
                            Text(viewModel.seedPhrase[index])
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorBaseTent)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            if index % 2 == 0 {
                                Color.colorBorderPrimaryTer.frame(width: 1)
                                    .padding(.trailing, 4)
                            }
                        }
                        .frame(height: 32)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .overlay(content: {
                    ZStack {
                        if isRevealPhrase {
                            HStack {
                                Spacer()
                                Button(
                                    action: {
                                        withAnimation {
                                            isRevealPhrase = false
                                        }
                                    },
                                    label: {
                                        Text("Hide")
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
                                .offset(x: -20, y: -14)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            .zIndex(999)
                            RoundedRectangle(cornerRadius: 20).stroke(.colorBorderPrimarySub, lineWidth: 1)
                        } else {
                            Image(.icHiddenSeedPhrase)
                                .resizable()
                                .clipped()
                        }
                    }
                })
                .padding(.horizontal, .xl)
                .padding(.bottom, .xl)
            }
        }
    }
}
