import SwiftUI
import UIKit
import SDWebImageSwiftUI

struct TestView: View {

    var body: some View {
        VStack {
            CustomWebImage(url: "https://nokiatech.github.io/heif/content/images/ski_jump_1440x960.heic", frameSize: .init(width: 50, height: 50))
        }
    }
}

#Preview {
    TestView()
}
