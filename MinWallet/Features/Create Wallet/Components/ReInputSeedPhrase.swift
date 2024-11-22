import SwiftUI
import UniformTypeIdentifiers

struct ReInputSeedPhrase: View {
  var onBack: () -> Void
  var onNext: () -> Void

  @State private var text: String = ""

  var body: some View {

    VStack {
      VStack(alignment: .leading, spacing: Spacing.lg) {
        Text("Please write down your 24 words seed phrase and store it in a secured place.")
          .font(
            .paragraphSmall
          ).foregroundColor(.appTentPrimary).frame(maxWidth: .infinity, alignment: .leading)

        LazyVGrid(columns: columns, spacing: Spacing.lg) {
          ForEach(0..<24, id: \.self) { index in
            AppTextField(
              text: .constant(""),
              prefix: String(index + 1)
            )
          }
        }
      }.padding(.horizontal, Spacing.xl).padding(.vertical, Spacing.lg)

      Spacer()

      Group {
        AppButton(
          title: "Next", variant: .primary, fullWidth: true, size: .lg,
          action: onNext)
      }.padding(.horizontal, Spacing.xl).padding(.top, Spacing._3xl)
    }

  }
}

private let columns = [
  GridItem(.flexible()),
  GridItem(.flexible()),
]

#Preview {
  ReInputSeedPhrase(onBack: {}, onNext: {})
}
