import SwiftUI


class BannerState: ObservableObject {
    @Published
    var isShowingBanner: Bool = false

    @Published
    var infoContent: (() -> AnyView)?

    init() {}
}
