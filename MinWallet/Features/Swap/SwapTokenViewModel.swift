import SwiftUI


class SwapTokenViewModel: ObservableObject {

    @Published
    var tokenPay: TokenProtocol?
    @Published
    var tokenReceive: TokenProtocol?
    @Published
    var isShowInfo: Bool = false
    @Published
    var isShowRouting: Bool = false
    @Published
    var isShowSwapSetting: Bool = false

    init() {

    }

    func swapToken() {

    }
}
