import SwiftUI

struct AppIconButton: View {
  var icon: IconName
  var action: () -> Void

  var body: some View {
    Button(action: action) {
      Group {
        AppIcon(name: icon, size: 24, color: Color.appInteractiveTentSecondaryDefault)
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
      AppIconButton(icon: .search, action: {})
    }
  }
}
