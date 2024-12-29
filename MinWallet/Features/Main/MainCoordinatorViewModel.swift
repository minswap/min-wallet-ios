import SwiftUI
import FlowStacks
import Apollo
import ApolloAPI
import MinWalletAPI


@MainActor
class MainCoordinatorViewModel: ObservableObject {
    @Published var routes: Routes<Screen> = []

    init() {
        Task {
            //            do {
            //                let data = try await MinWalletService.shared.fetch(query: TopAssetQuery(input: <#T##GraphQLNullable<TopAssetsInput>#>))
            //            } catch {
            //
            //            }
        }
    }
}

extension MainCoordinatorViewModel {
    enum Screen: Hashable {
        case home
        case policy
        case gettingStarted
        case tokenDetail(token: Token)
        case about
        case language
        case changePassword
        case changePasswordSuccess(_ screenType: ChangePasswordSuccessView.ScreenType)
        case forgotPassword(_ screenType: ChangePasswordView.ScreenType)
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
    case reInputSeedPhrase(seedPhrase: [String])
    case setupNickName(seedPhrase: [String])
    case biometricSetup(seedPhrase: [String], nickName: String)
    case createNewPassword(seedPhrase: [String], nickName: String)
    case createNewWalletSuccess
}

enum RestoreWalletScreen: Hashable {
    case restoreWallet
    case importFile
    case seedPhrase
    case biometricSetup(fileContent: String, seedPhrase: [String], nickName: String)
    case createNewPassword(fileContent: String, seedPhrase: [String], nickName: String)
    case createNewWalletSuccess
}

enum WalletSettingScreen: Hashable {
    case walletAccount
    case editNickName
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
