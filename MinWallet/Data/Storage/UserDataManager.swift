import Foundation


class UserDataManager {
    static let DEVICE_TOKEN = "DEVICE_TOKEN"
    
    static let shared = UserDataManager()
    
    private var defaults: UserDefaults!
    
    private init() {
        defaults = UserDefaults.standard
    }
    
    var deviceToken: String? {
        get {
            return defaults!.string(forKey: Self.DEVICE_TOKEN)
        }
        set (newValue) {
            defaults!.set(newValue, forKey: Self.DEVICE_TOKEN)
        }
    }
}
