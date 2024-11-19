import SwiftUI

enum ButtonVariant {
    case primary
    case secondary
}

struct AppButton: View {
    var title: String
    var variant: ButtonVariant
    var fullWidth: Bool = false
    var icon: IconName?
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.SpacingMd) {
                if let icon = icon {
                    AppIcon(name: icon)
                }
                Text(title).font(.labelMediumSecondary).foregroundColor(
                    Color.appTent)
            }
            .frame(maxWidth: fullWidth ? .infinity : nil).padding(
                .horizontal, Spacing.Spacing3Xl
            ).padding(.vertical, Spacing.SpacingMd).cornerRadius(
                BorderRadius.BorderRadiusFull
            ).background(
                variant == .primary ? Color.appPrimary : Color.appSecondary
            ).shadow(radius: 50).cornerRadius(BorderRadius.BorderRadiusFull)
            .overlay(
                RoundedRectangle(cornerRadius: BorderRadius.BorderRadiusFull)
                    .stroke(
                        variant == .primary ? Color.appPrimary : Color.appTent,
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
        }.padding()
    }
}
