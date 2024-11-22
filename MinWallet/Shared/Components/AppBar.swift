import SwiftUI

struct AppBar: View {
  var body: some View {
    HStack {
      HStack {
        Image("avatar")
          .resizable()
          .scaledToFit()
          .frame(width: 36, height: 36)
          .clipShape(Circle())
      }
      .padding(2)
      .clipShape(Circle())
      .overlay(
        Circle().stroke(Color.appBorderPrimarySub, lineWidth: 1)
      )
      .shadow(
        color: Color(red: 0, green: 0.1, blue: 0.28).opacity(0.1),
        radius: 3, x: 0, y: 4
      )
      .shadow(
        color: Color(red: 0, green: 0.1, blue: 0.28).opacity(0.06),
        radius: 2, x: 0, y: 2)

      Spacer().frame(width: 10)

      Text("SassyCat").font(.labelMediumSecondary).foregroundColor(
        .appTentPrimary)

      Spacer()

      AppIconButton(icon: .search, action: {})
    }
    .padding(.horizontal, Spacing.xl)
    .padding(.vertical, Spacing.xs)
    .frame(maxWidth: .infinity)
  }
}

struct AppBar_Previews: PreviewProvider {
  static var previews: some View {
    HStack {
      AppBar()
    }
  }
}
