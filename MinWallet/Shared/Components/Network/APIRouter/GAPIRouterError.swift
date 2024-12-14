import Foundation


// MARK: - Protocol to hook error
protocol GAPIRouterErrorNormalizer {
    var publicIP: String? { get }
    func normalizer(_ error: Error, from router: GAPIRouter) -> Error
}

// MARK: - Error
enum GAPIRouterError: LocalizedError {
    static let GenericError = "Something went wrong"

    case serverUnauthenticated
    case excessiveRefresh
    case localError(message: String)
    case serverError(message: String)
    case invalidResponseError(message: String)

    var errorDescription: String? {
        switch self {
        case .serverUnauthenticated:
            return "Session expired"
        case .excessiveRefresh:
            return "Refresh failed"
        case .serverError(let message),
            .localError(let message),
            .invalidResponseError(let message):
            return message
        }
    }
}
