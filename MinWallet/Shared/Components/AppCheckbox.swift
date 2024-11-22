import SwiftUI

struct AppCheckbox: View {
  var label: String?
  @Binding var isChecked: Bool

  var body: some View {
    Button(action: {
      isChecked.toggle()
    }) {
      HStack(spacing: Spacing.md) {
        HStack {
          if isChecked {
            AppIcon(name: .check, size: 20, color: .white)
          } else {
            Color.clear.frame(width: 20, height: 20)
          }
        }
        .padding(Spacing.xxs)
        .background(isChecked ? Color.appToneHighlight : .appBaseBackground)
        .cornerRadius(BorderRadius.sm)
        .overlay(
          RoundedRectangle(cornerRadius: BorderRadius.sm)
            .stroke(
              isChecked ? Color.appToneHighlight : Color.appBorderPrimarySub,
              lineWidth: 1)
        )

        if let label = label {
          Text(label).font(.paragraphSmall).foregroundColor(.appTentPrimarySub)
        }

      }

    }.buttonStyle(PlainButtonStyle())
  }
}

#Preview {
  AppCheckbox(isChecked: .constant(true))
  AppCheckbox(isChecked: .constant(false))
  AppCheckbox(label: "yeah....", isChecked: .constant(false))
  AppCheckbox(label: "Sample label", isChecked: .constant(true))
}
