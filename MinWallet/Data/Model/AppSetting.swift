import SwiftUI
import Combine


class AppSetting: ObservableObject {
    static let USER_NAME = "minWallet"

    static let shared: AppSetting = .init()

    var extraSafeArea: CGFloat {
        safeArea > 44 ? 32 : 12
    }

    lazy var biometricAuthentication: BiometricAuthentication = .init()

    let objectWillChange = PassthroughSubject<Void, Never>()

    var safeArea: CGFloat = UIApplication.safeArea.top

    var rootScreen: MainCoordinatorViewModel.Screen = .policy
    {
        willSet {
            objectWillChange.send()
        }
    }

    @UserDefault("enable_audio", defaultValue: false)
    var enableAudio: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @UserDefault("language", defaultValue: Language.english.rawValue)
    var language: String {
        willSet {
            objectWillChange.send()
        }
    }

    @UserDefault("currency", defaultValue: Currency.usd.rawValue)
    var currency: String {
        willSet {
            objectWillChange.send()
        }
    }

    @UserDefault("timezone", defaultValue: TimeZone.local.rawValue)
    var timeZone: String {
        willSet {
            objectWillChange.send()
        }
    }

    @UserDefault("userInterfaceStyle", defaultValue: Appearance.system.rawValue)
    var userInterfaceStyle: Int {
        willSet {
            objectWillChange.send()
        }
    }

    /*
    @UserDefault("enable_notification", defaultValue: false)
    var enableNotification: Bool {
        willSet {
            objectWillChange.send()
        }
    }
     */

    @UserDefault("enable_biometric", defaultValue: false)
    private var enableBiometric: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @UserDefault("security_type", defaultValue: 0)
    private var securityType: Int {
        willSet {
            objectWillChange.send()
        }
    }

    @UserDefault("is_login", defaultValue: false)
    var isLogin: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    ///symbol + . +  token name
    @UserDefault("token_fav", defaultValue: [])
    var tokenFav: [String] {
        willSet {
            objectWillChange.send()
        }
    }

    var authenticationType: AuthenticationType {
        get { AuthenticationType(rawValue: securityType) ?? .biometric }
        set { securityType = newValue.rawValue }
    }

    var currencyInADA: Double = 1 {
        willSet {
            Task {
                await MainActor.run {
                    objectWillChange.send()
                }
            }
        }
    }

    private init() {
        if enableBiometric {
            enableBiometric = biometricAuthentication.canEvaluatePolicy()
        }

        rootScreen = isLogin ? .home : .policy

        getAdaPrice()
    }

    func deleteAccount() {
        isLogin = false
        tokenFav = []
        authenticationType = .biometric
        try? AppSetting.deletePasswordToKeychain(username: AppSetting.USER_NAME)
    }
}


//MARK: Theme
extension AppSetting {
    var appearance: Appearance {
        Appearance(rawValue: userInterfaceStyle) ?? .system
    }

    func initAppearanceStyle() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                switch Appearance(rawValue: userInterfaceStyle) {
                case .system:
                    window.overrideUserInterfaceStyle = .unspecified
                case .light:
                    window.overrideUserInterfaceStyle = .light
                case .dark:
                    window.overrideUserInterfaceStyle = .dark
                default:
                    window.overrideUserInterfaceStyle = .unspecified
                }
            }
        }
    }

    func applyAppearanceStyle(_ selectedAppearance: Appearance) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                switch selectedAppearance {
                case .system:
                    userInterfaceStyle = Appearance.system.rawValue
                    window.overrideUserInterfaceStyle = .unspecified
                case .light:
                    userInterfaceStyle = Appearance.light.rawValue
                    window.overrideUserInterfaceStyle = .light
                case .dark:
                    userInterfaceStyle = Appearance.dark.rawValue
                    window.overrideUserInterfaceStyle = .dark
                }
            }
        }
    }
}


extension AppSetting {
    static func getPasswordFromKeychain(username: String) throws -> String {
        let passwordItem = GKeychainStore(
            service: MinWalletConstant.keyChainService,
            key: username,
            accessGroup: MinWalletConstant.keyChainAccessGroup
        )
        let keychainPassword = try passwordItem.read()
        return keychainPassword
    }

    static func savePasswordToKeychain(username: String, password: String) throws {
        let passwordItem = GKeychainStore(
            service: MinWalletConstant.keyChainService,
            key: username,
            accessGroup: MinWalletConstant.keyChainAccessGroup
        )

        try passwordItem.save(password)
    }

    static func deletePasswordToKeychain(username: String) throws {
        let passwordItem = GKeychainStore(
            service: MinWalletConstant.keyChainService,
            key: username,
            accessGroup: MinWalletConstant.keyChainAccessGroup
        )

        try passwordItem.deleteItem()
    }

    func reAuthenticateUser() async throws {
        biometricAuthentication = .init()
        try await biometricAuthentication.authenticateUser()
    }

    var password: String {
        switch authenticationType {
        case .password:
            (try? AppSetting.getPasswordFromKeychain(username: AppSetting.USER_NAME)) ?? ""
        case .biometric:
            MinWalletConstant.passDefaultForFaceID
        }
    }
}

extension AppSetting {
    enum AuthenticationType: Int {
        case biometric
        case password
    }
}
