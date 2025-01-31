import SwiftUI
import SDWebImageSwiftUI


struct CustomWebImage<Placeholder: View>: View {
    let url: String?
    let frameSize: CGSize
    let placeholder: () -> Placeholder

    init(
        url: String?,
        frameSize: CGSize,
        @ViewBuilder placeholder: @escaping () -> Placeholder = {
            Image(.ada)
                .resizable()
                .scaledToFill()
                .background(.pink)
                .clipped()
        }
    ) {
        self.url = url
        self.frameSize = frameSize
        self.placeholder = placeholder
    }

    var body: some View {
        WebImage(url: URL(string: url ?? "")) { image in
            image
                .resizable()
                .scaledToFill()  // Fill the frame
        } placeholder: {
            placeholder()
        }
        .indicator(.activity)  // Show loading activity indicator
        .transition(.fade(duration: 0.5))  // Smooth fade transition
        .frame(width: frameSize.width, height: frameSize.height)
        .clipped()
    }
}
