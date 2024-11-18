import SwiftUI

enum IconName: String {
    case arrowLeftDown = "arrow-left-down"
    case arrowRightUp = "arrow-right-up"
    
    var image: Image {
        return Image(self.rawValue)
    }
}

struct Icon: View {
    var name: IconName
    var color: Color = Color.appTent
    var size: CGFloat = 20
    
    var body: some View {
        name.image.resizable().aspectRatio(contentMode: .fit).frame(width: 20, height: size).foregroundColor(.black)
    }
}
