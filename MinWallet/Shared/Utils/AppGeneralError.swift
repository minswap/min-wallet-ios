import SwiftUI


enum AppGeneralError: LocalizedError {
    static let GenericError = "Có lỗi xảy ra"
    
    case serverUnauthenticated
    case localError(message: LocalizedStringKey)
    case serverError(message: LocalizedStringKey)
    case invalidResponseError(message: LocalizedStringKey)
    
    var errorDescription: LocalizedStringKey? {
        switch self {
        case .serverUnauthenticated:
            return "Phiên đăng nhập của bạn đã hết. Vui lòng đăng nhập lại để tiếp tục sử dụng."
        case .localError(let message),
                .serverError(let message),
                .invalidResponseError(let message):
            return message
        }
    }
}
