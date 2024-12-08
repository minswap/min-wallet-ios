import SwiftUI
import FlowStacks


@MainActor
class MainCoordinatorViewModel: ObservableObject {
    @Published var routes: Routes<Screen> = []

    init() {}
}

extension MainCoordinatorViewModel {
    enum Screen: Hashable {
        case home
        case policy
        case gettingStarted
        case tokenDetail(token: Token)
        case about
        case language
        case createWallet(_ screen: CreateWalletScreen)
        case restoreWallet(_ screen: RestoreWalletScreen)
        case walletSetting(_ screen: WalletSettingScreen)
        case sendToken(_ screen: SendTokenScreen)
        case selectToken
        case receiveToken
        case swapToken(_ screen: SwapTokenScreen)
        case searchToken
        case securitySetting(_ screen: SecuritySetting)
    }
}

enum CreateWalletScreen: Hashable {
    case createWallet
    case seedPhrase
    case reInputSeedPhrase
    case setupNickName
    case biometricSetup
    case createNewWalletSuccess
    case createNewPassword
}

enum RestoreWalletScreen: Hashable {
    case restoreWallet
    case seedPhrase
    case importFile
    case biometricSetup
    case createNewPassword
    case createNewWalletSuccess
}

enum WalletSettingScreen: Hashable {
    case walletAccount
    case changePassword
    case changePasswordSuccess
    case disconnectWallet
}

enum SendTokenScreen: Hashable {
    case sendToken
    case toWallet
    case confirm
    case signContract
}

enum SwapTokenScreen: Hashable {
    case swapToken
}

enum SecuritySetting: Hashable {
    case authentication
    case createPassword(onCreatePassSuccess: CreatePassSuccess)
    case forgotPassword
}

extension SecuritySetting {
    struct CreatePassSuccess: Hashable {
        private var id = UUID().uuidString

        var onCreatePassSuccess: ((String) -> Void)?

        init(onCreatePassSuccess: ((String) -> Void)?) {
            self.onCreatePassSuccess = onCreatePassSuccess
        }

        static func == (lhs: SecuritySetting.CreatePassSuccess, rhs: SecuritySetting.CreatePassSuccess) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}
