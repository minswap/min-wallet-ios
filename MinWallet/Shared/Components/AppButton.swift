import SwiftUI

enum ButtonVariant {
  case primary
  case secondary
}

enum ButtonSize {
  case md
  case lg
}

struct AppButton: View {
  var title: String
  var variant: ButtonVariant
  var fullWidth: Bool = false
  var icon: IconName?
  var size: ButtonSize? = .md
  var action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(spacing: Spacing.md) {
        if let icon = icon {
          AppIcon(name: icon)
        }
        Text(title).font(.labelMediumSecondary).foregroundColor(
          .appTentPrimary)
      }
      .frame(maxWidth: fullWidth ? .infinity : nil).padding(
        .horizontal, Spacing._3xl
      ).padding(.vertical, size == .lg ? Spacing.lg : Spacing.md).cornerRadius(
        BorderRadius.full
      ).background(
        variant == .primary ? Color.appPrimary : Color.appBaseBackground
      ).shadow(radius: 50).cornerRadius(BorderRadius.full)
      .overlay(
        RoundedRectangle(cornerRadius: BorderRadius.full)
          .stroke(
            variant == .primary ? .appPrimary : .appTentPrimary,
            lineWidth: 1)
      )
    }.buttonStyle(PlainButtonStyle())
  }
}

struct AppButton_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      AppButton(
        title: "Swap", variant: ButtonVariant.primary,
        icon: .arrowLeftDown, action: {})
      AppButton(
        title: "Swap", variant: ButtonVariant.secondary,
        fullWidth: true, icon: .arrowRightUp, action: {})
      AppButton(
        title: "Swap", variant: ButtonVariant.secondary,
        fullWidth: true, icon: .arrowRightUp, size: .lg, action: {})
    }.padding()
  }
}
