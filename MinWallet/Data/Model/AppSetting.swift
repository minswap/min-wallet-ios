import SwiftUI
import Combine


class AppSetting: ObservableObject {
    lazy var biometricAuthentication: BiometricAuthentication = .init()
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
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
    
    @UserDefault("enable_notification", defaultValue: false)
    var enableNotification: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("enable_biometric", defaultValue: false)
    var enableBiometric: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    init() {
        if enableBiometric {
            enableBiometric = biometricAuthentication.canEvaluatePolicy()
        }
    }
}


//MARK: Theme
extension AppSetting {
    var appearance: Appearance  {
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
