import SwiftUI
import UniformTypeIdentifiers

struct RevealSeedPhrase: View {
  var onBack: () -> Void
  var onNext: () -> Void

  @State private var userConfirmed: Bool = false
  @State private var step: Step = .initial

  var body: some View {

    VStack {
      VStack(alignment: .leading, spacing: Spacing.lg) {
        Text("Please write down your 24 words seed phrase and store it in a secured place.")
          .font(
            .paragraphSmall
          ).foregroundColor(.appTentPrimary).frame(maxWidth: .infinity, alignment: .leading)

        switch step {
        case .initial:
          VStack {
            AppButton(
              title: "Reveal SeedPhrase", variant: .primary, fullWidth: true, icon: .eye,
              size: .lg,
              action: revealSeedPhrase
            ).padding(.horizontal, Spacing._3xl)
          }.frame(maxWidth: .infinity, maxHeight: 479).background(.appSurfacePrimaryDisabled)
            .cornerRadius(Spacing.xl)
        case .revealed:
          LazyVGrid(columns: columns, spacing: Spacing.lg) {
            ForEach(Array(words.enumerated()), id: \.element) { index, word in
              AppTextField(
                text: .constant(word),
                prefix: String(index + 1),
                disabled: true)
            }
          }
        }
      }.padding(.horizontal, Spacing.xl).padding(.vertical, Spacing.lg)

      Spacer()

      switch step {
      case .initial:
        Group {
          AppButton(
            title: "Reveal SeedPhrase", variant: .primary, fullWidth: true, size: .lg,
            action: revealSeedPhrase)
        }.padding(.horizontal, Spacing.xl).padding(.top, Spacing._3xl)
      case .revealed:
        VStack(spacing: Spacing.xl) {
          AppCheckbox(
            label: "I have written the seed phrase and stored it in a secured place.",
            isChecked: $userConfirmed)

          HStack {
            AppButton(
              title: "Copy", variant: .secondary, fullWidth: true, size: .lg, action: copySeedPhrase
            )
            AppButton(title: "Next", variant: .primary, fullWidth: true, size: .lg, action: onNext)
          }

        }.padding(.horizontal, Spacing.xl).padding(.top, Spacing._3xl)
      }
    }

  }

  private func revealSeedPhrase() {
    step = .revealed
  }

  private func copySeedPhrase() {
    UIPasteboard.general.string = words.joined(separator: " ")
  }
}

private let words = [
  "apple",
  "banana",
  "cherry",
  "date",
  "elderberry",
  "fig",
  "grape",
  "honeydew",
  "kiwi",
  "lemon",
  "mango",
  "nectarine",
  "orange",
  "papaya",
  "quince",
  "raspberry",
  "strawberry",
  "tangerine",
  "ugli",
  "vanilla",
  "watermelon",
  "xigua",
  "yellowfruit",
  "zucchini",
]

private enum Step {
  case initial
  case revealed
}

private let columns = [
  GridItem(.flexible()),
  GridItem(.flexible()),
]

#Preview {
  RevealSeedPhrase(onBack: {}, onNext: {})
}
