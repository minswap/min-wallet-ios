import SwiftUI

struct AppIconButton: View {
  var icon: IconName

  var body: some View {
    Button(action: {}) {
      Group {
        AppIcon(name: icon, size: 24)
      }.padding(Spacing.md).clipShape(Circle())
        .overlay(
          Circle()
            .stroke(Color.appBorderPrimaryTertiary, lineWidth: 1)
        )
    }.buttonStyle(PlainButtonStyle())
  }
}

struct AppIconButton_Preview: PreviewProvider {
  static var previews: some View {
    VStack {
      AppIconButton(icon: .search)
    }
  }
}
