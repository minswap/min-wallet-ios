import SwiftUI

struct AppTextField: View {

  @Binding var text: String
  var prefix: String?
  var disabled: Bool?

  var body: some View {
    HStack(spacing: Spacing.md - Spacing.xxs) {
      if let prefix = prefix {
        Text(prefix).font(.paragraphSmall).foregroundColor(Color.appTentPrimaryDisabled)
      }
      TextField("", text: $text).padding(.leading, Spacing.xxs)
        .disabled(disabled ?? false).font(.paragraphSmall)
    }
    .cornerRadius(BorderRadius.full).padding(.horizontal, Spacing.lg).padding(
      .vertical, Spacing.md
    ).overlay(
      RoundedRectangle(cornerRadius: BorderRadius._3xl)
        .stroke(
          Color.appBorderPrimarySub,
          lineWidth: 1)
    ).frame(maxWidth: .infinity)
  }
}

#Preview {
  VStack {
    AppTextField(text: .constant("vessel"))
    AppTextField(text: .constant("vessel"), prefix: "1")
  }
}
