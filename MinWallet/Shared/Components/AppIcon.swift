import SwiftUI

enum IconName: String {
  case arrowLeftDown = "arrow-left-down"
  case arrowRightUp = "arrow-right-up"
  case search = "search"
  case qrCode = "qr-code"
  case fileCopy = "file-copy"

  var image: Image {
    return Image(self.rawValue)
  }
}

struct AppIcon: View {
  var name: IconName
  var color: Color = Color.appTent
  var size: CGFloat = 20

  var body: some View {
    name.image.resizable().aspectRatio(contentMode: .fit).frame(
      width: size, height: size
    ).foregroundColor(.black)
  }
}
