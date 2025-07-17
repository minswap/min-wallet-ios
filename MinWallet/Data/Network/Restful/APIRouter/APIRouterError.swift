import Foundation


// MARK: - Protocol to hook error
protocol APIRouterErrorNormalizer {
    var publicIP: String? { get }
    func normalizer(_ error: Error, from router: APIRouter) -> Error
}

// MARK: - Error
enum APIRouterError: LocalizedError {
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
