import SwiftUI

enum IconName: String {
  case arrowLeftDown = "arrow-left-down"
  case arrowRightUp = "arrow-right-up"
  case arrowUpS = "arrow-up-s"
  case verifiedBadge = "verified-badge"
  case search = "search"
  case qrCode = "qr-code"
  case fileCopy = "file-copy"

  var image: Image {
    return Image(self.rawValue)
  }
}

struct AppIcon: View {
  var name: IconName
  var size: CGFloat = 20
  var color: Color?

  var body: some View {
    name.image.resizable().renderingMode(.template).aspectRatio(contentMode: .fit).frame(
      width: size, height: size
    ).foregroundColor(color)
  }
}
