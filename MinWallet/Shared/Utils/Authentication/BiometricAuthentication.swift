import SwiftUI
import LocalAuthentication


class BiometricAuthentication {
    private let context = LAContext()
    
    private var loginReason: LocalizedStringKey {
        switch biometricType {
        case .touchID:
            return "Touch ID"
        case .faceID:
            return "Face ID"
        #if swift(>=5.9)
            case .opticID:
                return "Optic ID"
        #endif
        case .none:
            return ""
        @unknown default:
            return ""
        }
    }
    
    var displayName: LocalizedStringKey {
        switch biometricType {
        case .touchID:
            return "Touch ID"
        case .faceID:
            return "Face ID"
        #if swift(>=5.9)
            case .opticID:
                return "Optic ID"
        #endif
        case .none:
            return ""
        @unknown default:
            return ""
        }
    }
    
    var biometricType: LABiometryType {
        canEvaluatePolicy()
        
        return context.biometryType
    }
    
    init() {}
    
    /// Determines whether biometric or device owner authentication is available on the device.
    /// - Returns: `true` if authentication can be evaluated; otherwise, `false`.
    @discardableResult
    func canEvaluatePolicy() -> Bool {
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
    }
    
    /// Initiates biometric authentication and invokes the completion handler with an LAError if authentication fails, or nil on success.
    /// - Parameter completion: A closure called on the main thread with an optional LAError indicating the result of authentication.
    private func authenticateUser(completion: @escaping ((_ error: LAError?) -> Void)) {
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: self.loginReason.toString()) { (success, error) in
            DispatchQueue.main.async {
                guard !success, let laError = error as? LAError else {
                    completion(nil)
                    return
                }
                
                completion(laError)
            }
        }
    }
    
    /// Performs biometric authentication asynchronously.
    /// 
    /// Initiates biometric authentication and suspends until the user completes authentication or an error occurs. Throws a localized error if authentication fails.
    func authenticateUser() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            self.authenticateUser { error in
                let errorMessage: ErrorType? = error.map {
                    switch $0 {
                    case LAError.authenticationFailed:
                        return .authenticationFailed
                    case LAError.userCancel:
                        return .userCancel
                    case LAError.userFallback:
                        return .userFallback
                    case LAError.passcodeNotSet:
                        return .passcodeNotSet
                    case LAError.biometryNotAvailable:
                        return .biometryNotAvailable
                    case LAError.biometryNotEnrolled:
                        return .biometryNotEnrolled
                    case LAError.biometryLockout:
                        return .biometryLockout
                    default:
                        return .biometryNotAvailable
                    }
                }

                if let errorMessage = errorMessage {
                    continuation.resume(throwing: AppGeneralError.localErrorLocalized(message: errorMessage.rawValue))
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
}

extension BiometricAuthentication {
    enum ErrorType: LocalizedStringKey, CaseIterable {
        case userCancel = "Please accept with Face ID/Touch ID"
        case userFallback = "Enter password to continue"
        case passcodeNotSet = "Authentication cannot be initiated because a passcode has not been set up on the device."
        case authenticationFailed = "Authentication invalid, please try again later"
        case biometryNotAvailable = "Face ID/Touch ID not available"
        case biometryNotEnrolled = "Face ID/Touch ID not installed"
        case biometryLockout = "Face ID/Touch ID is locked"
        case touchIDNotAvailable = "Touch ID not available"
        case permissions = "Please grant biometric permission to the app to enable Face ID/Touch ID login"
        case requireLogin = "You must log in with a successful password to use this feature."
    }
}
