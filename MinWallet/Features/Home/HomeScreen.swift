import SwiftUI

struct HomeScreen: View {
  var body: some View {
    NavigationView {
      VStack(alignment: .leading) {

        AppBar()

        VStack(alignment: .leading, spacing: Spacing.xs) {
          Button(action: {}) {
            HStack(spacing: 4) {
              Text(shortenAddress("Addrasdlfkjasdf12231123")).font(.paragraphXSmall)
                .foregroundColor(
                  .appInteractiveTentPrimarySub)
              AppIcon(name: .fileCopy, size: 16, color: .appInteractiveTentPrimarySub)
            }
          }.buttonStyle(PlainButtonStyle())

          HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text("0").font(.titleH3)
            Text(".00 ₳").font(.titleH5).foregroundColor(.appTentPrimaryDisabled)
          }
        }.padding(.vertical, Spacing.lg).padding(.horizontal, Spacing.xl)

        HStack {
          AppButton(title: "Receive", variant: .primary, icon: .arrowLeftDown) {}
          AppButton(title: "Send", variant: .secondary, icon: .arrowRightUp) {}
          AppButton(title: "QR", variant: .secondary, icon: .qrCode) {}
        }.padding(.vertical, Spacing.md).padding(
          .horizontal, Spacing.xl)

        Group {
          Carousel()
        }.padding(.vertical, Spacing.md).padding(
          .horizontal, Spacing.xl)

        Spacer()
      }
    }.toolbar(.hidden)
  }
}

struct HomeScreen_Preview: PreviewProvider {
  static var previews: some View {
    HomeScreen()
  }
}
