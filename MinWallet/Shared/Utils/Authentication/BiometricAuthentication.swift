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
        }
    }

    var biometricType: LABiometryType {
        canEvaluatePolicy()

        return context.biometryType
    }

    init() {}

    @discardableResult
    func canEvaluatePolicy() -> Bool {
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }

    private func authenticateUser(completion: @escaping ((_ error: LAError?) -> Void)) {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: self.loginReason.toString()) { (success, error) in
            DispatchQueue.main.async {
                guard !success, let laError = error as? LAError else {
                    completion(nil)
                    return
                }

                completion(laError)
            }
        }
    }

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
                    continuation.resume(throwing: AppGeneralError.localError(message: errorMessage.rawValue))
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
}

extension BiometricAuthentication {
    enum ErrorType: LocalizedStringKey, CaseIterable {
        case userCancel = "Vui lòng chấp nhận đăng nhập bằng Face ID/Touch ID"
        case userFallback = "Nhập mật khẩu để tiếp tục"
        case passcodeNotSet = "Không thể bắt đầu xác thực vì mật mã chưa được cài đặt trên thiết bị"
        case authenticationFailed = "Xác thực không hợp lệ, vui lòng thử lại sau"
        case biometryNotAvailable = "Face ID/Touch ID không sẵn sàng"
        case biometryNotEnrolled = "Face ID/Touch ID chưa được cài đặt"
        case biometryLockout = "Face ID/Touch ID đang bị khoá"
        case touchIDNotAvailable = "Touch ID không sẵn sàng"
        case permissions = "Vui lòng cấp quyền sinh trắc học cho ứng dụng để kích hoạt đăng nhập bằng Face ID/Touch ID"
        case requireLogin = "Bạn phải đăng nhập với mật khẩu thành công mới có thể sử dụng tính năng này"
    }
}
