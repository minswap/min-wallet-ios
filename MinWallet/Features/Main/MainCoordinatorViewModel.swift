import SwiftUI
import FlowStacks


@MainActor
class MainCoordinatorViewModel: ObservableObject {
    @Published var routes: Routes<Screen> = []
    
    init() { }
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
    case createNewPassword
    case createNewWalletSuccess
}
