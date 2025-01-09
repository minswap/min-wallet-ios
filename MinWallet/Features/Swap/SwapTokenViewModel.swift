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
    @Published
    var isShowBannerTransaction: Bool = false

    init() {

    }

    func swapToken(appSetting: AppSetting, signContract: (() -> Void)?, signSuccess: (() -> Void)?) {
        Task {
            switch appSetting.authenticationType {
            case .biometric:
                try await appSetting.reAuthenticateUser()
                signSuccess?()
            case .password:
                signSuccess?()
            }
        }
    }
}
