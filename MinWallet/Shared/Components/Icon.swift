import SwiftUI

enum IconName: String {
    case arrowLeftDown = "arrow-left-down"
    case arrowRightUp = "arrow-right-up"
    case arrowUpS = "arrow-up-s"
    case verifiedBadge = "verified-badge"
    
    var image: Image {
        return Image(self.rawValue)
    }
}

struct Icon: View {
    var name: IconName
    var color: Color = Color.appTent
    var size: CGFloat = 20
    
    var body: some View {
        name.image.resizable().renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/).aspectRatio(contentMode: .fit).frame(width: size, height: size).foregroundColor(color)
    }
}
