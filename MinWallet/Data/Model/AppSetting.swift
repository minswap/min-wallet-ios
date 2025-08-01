import SwiftUI
import Combine
import OneSignalFramework


class AppSetting: ObservableObject {
    static let USER_NAME = "minWallet"
    
    static let shared: AppSetting = .init()
    
    var extraSafeArea: CGFloat {
        safeArea > 44 ? 32 : 12
    }
    
    lazy var biometricAuthentication: BiometricAuthentication = .init()
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    var safeArea: CGFloat = UIApplication.safeArea.top
    var swipeEnabled = true
    
    var rootScreen: MainCoordinatorViewModel.Screen = .policy(.splash)
    {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("first_time", defaultValue: true)
    var isFirstTimeRunApp: Bool {
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
    
    @UserDefault("enable_notification", defaultValue: true)
    var enableNotification: Bool {
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
    
    lazy var bip0039: [String] = {
        guard let fileURL = Bundle.main.url(forResource: "bip0039", withExtension: "txt") else { return [] }
        do {
            return try String(contentsOf: fileURL, encoding: .utf8).split(separator: "\n").map { String($0) }
        } catch {
            return []
        }
    }()

    private lazy var suspiciousToken: [String] = []
    
    private init() {
        if enableBiometric {
            enableBiometric = biometricAuthentication.canEvaluatePolicy()
        }
        
        rootScreen = isLogin ? .home : (isFirstTimeRunApp ? .policy(.splash) : .gettingStarted)
        
        getAdaPrice()
    }
    
    /// Logs out the user and resets all account-related data and settings.
    /// 
    /// Marks the user as logged out, clears authentication tokens, removes stored passwords, resets user data and notifications, logs out from notification services, and restores default authentication and notification settings after a short delay.
    @MainActor func deleteAccount() {
        isLogin = false
        
        TokenManager.reset()
        try? AppSetting.deletePasswordToKeychain(username: AppSetting.USER_NAME)
        UserDataManager.shared.tokenRecentSearch = []
        UserDataManager.shared.tokenFav = []
        UserDataManager.shared.notificationGenerateAuthHash = nil
        OneSignal.Notifications.clearAll()
        OneSignal.logout()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.authenticationType = .biometric
            self.enableNotification = true
            self.timeZone = TimeZone.local.rawValue
        }
    }
    
    /// Asynchronously determines whether a given currency symbol is listed as suspicious.
    /// - Parameter currencySymbol: The symbol of the currency to check.
    /// - Returns: `true` if the currency symbol is found in the suspicious tokens list; otherwise, `false`.
    /// 
    /// If the suspicious tokens list is not cached, it is fetched from a remote source and cached for future checks. Returns `false` if the symbol is empty, the list cannot be fetched, or an error occurs.
    func isSuspiciousToken(currencySymbol: String) async -> Bool {
        guard !currencySymbol.isEmpty else { return false }
        guard suspiciousToken.isEmpty else { return suspiciousToken.contains(currencySymbol) }
        guard let url = URL(string: MinWalletConstant.suspiciousTokenURL) else { return false }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let tokensScam = String(decoding: data, as: UTF8.self).split(separator: "\n").map { String($0) }
            AppSetting.shared.suspiciousToken = tokensScam
            return tokensScam.contains(currencySymbol)
        } catch {
            return false
        }
    }
}


//MARK: Theme
extension AppSetting {
    var appearance: Appearance {
        Appearance(rawValue: userInterfaceStyle) ?? .system
    }
    
    /// Applies the stored appearance style to all app windows based on the current user interface style setting.
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
    
    /// Applies the selected appearance style to all app windows and updates the stored user interface style.
    /// - Parameter selectedAppearance: The desired appearance style to apply.
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
    /// Retrieves the password for the specified username from the keychain, falling back to UserDefaults if unavailable or blank.
    /// - Parameter username: The username whose password is to be retrieved.
    /// - Returns: The password associated with the username, or an empty string if not found.
    static func getPasswordFromKeychain(username: String) throws -> String {
        do {
            let passwordItem = GKeychainStore(
                service: MinWalletConstant.keyChainService,
                key: username,
                accessGroup: MinWalletConstant.keyChainAccessGroup
            )
            let keychainPassword = try passwordItem.read()
            return keychainPassword.isBlank ? (UserDefaults.standard.string(forKey: username) ?? "") : keychainPassword
        } catch {
            return UserDefaults.standard.string(forKey: username) ?? ""
        }
    }
    
    /// Saves the given password for the specified username to the keychain.
    /// Falls back to storing the password in UserDefaults if keychain access fails.
    /// - Parameters:
    ///   - username: The username associated with the password.
    ///   - password: The password to be saved.
    /// - Throws: An error if saving to the keychain fails and fallback to UserDefaults is not possible.
    static func savePasswordToKeychain(username: String, password: String) throws {
        do {
            let passwordItem = GKeychainStore(
                service: MinWalletConstant.keyChainService,
                key: username,
                accessGroup: MinWalletConstant.keyChainAccessGroup
            )
            
            try passwordItem.save(password)
        } catch {
            UserDefaults.standard.set(password, forKey: username)
        }
    }
    
    /// Deletes the password associated with the specified username from the keychain and removes it from UserDefaults as a fallback.
    /// - Parameter username: The username whose password should be deleted.
    /// - Throws: An error if the keychain deletion fails for reasons other than those handled by the fallback.
    static func deletePasswordToKeychain(username: String) throws {
        do {
            let passwordItem = GKeychainStore(
                service: MinWalletConstant.keyChainService,
                key: username,
                accessGroup: MinWalletConstant.keyChainAccessGroup
            )
            
            try passwordItem.deleteItem()
            UserDefaults.standard.removeObject(forKey: username)
        } catch {
            UserDefaults.standard.removeObject(forKey: username)
        }
    }
    
    /// Reinitializes biometric authentication and attempts to authenticate the user asynchronously.
    /// - Throws: An error if biometric authentication fails.
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
