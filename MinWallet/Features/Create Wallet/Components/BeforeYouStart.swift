import SwiftUI

struct BeforeYouStart: View {
  private let tips = [
    "If I lose my seed phrase, my assets will be lost forever.",
    "If I share my seed phrase with others, my assets will be stolen.",
    "The seed phrase is only stored on my computer, and Minswap has no access to it.",
    "If I clear my local storage without backing up the seed phrase, Minswap cannot retrieve it for me.",
  ]

  var onNext: () -> Void

  var body: some View {
    VStack {
      VStack(alignment: .leading, spacing: Spacing.lg) {
        Text("Before you start, please read and keep the following security tips in mind.").font(
          .paragraphSmall
        ).foregroundColor(.appTentPrimary).frame(maxWidth: .infinity, alignment: .leading)

        ForEach(tips, id: \.self) { tip in
          HStack(alignment: .top) {
            HStack {
              AppIcon(name: .check, size: 20, color: .white)
            }.padding(Spacing.xxs).background(.appToneHighlight).cornerRadius(BorderRadius.full)

            Text(tip).font(.paragraphSmall).foregroundColor(.appTentPrimarySub)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(Spacing.xl)
          .cornerRadius(BorderRadius._3xl)
          .overlay(
            RoundedRectangle(cornerRadius: BorderRadius._3xl)
              .stroke(
                Color.appBorderPrimarySub,
                lineWidth: 1)
          )
        }
      }.padding(.horizontal, Spacing.xl).padding(.vertical, Spacing.lg)

      Spacer()

      Group {
        AppButton(title: "Next", variant: .primary, fullWidth: true, size: .lg, action: onNext)
      }.padding(.horizontal, Spacing.xl).padding(.top, Spacing._3xl)
    }
  }
}

#Preview {
  BeforeYouStart(onNext: {})
}
