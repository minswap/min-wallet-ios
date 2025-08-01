import Foundation
import Alamofire
import Combine


// MARK: - Domain Token Refresher
protocol GDomainTokenRefresher {
    /// refresh token dùng để gọid API refresh, nếu trống sẽ ko gọi `requestRefreshToken` mà lỗi luôn
    var refreshToken: String { get }
    /// biến quyết định có cần gọi refresh trước khi gọi API ko
    ///
    /// biến nên là `requiresRefresh` trước khi (access) token hết hạn một khoảng thời gian
    /// để hạn chế API bị gọi với token hết hạn và phải retry sau refresh
    ///
    /// ````
    /// func shouldRefreshTokenIfRequired(endpoint: APIRouter) -> RequiresRefreshResult {
    ///   if endpoint == <Refresh Token API endpoint> {
    ///     return .doesNotRequireRefresh
    ///   }
    ///
    ///   let date_now = ..
    ///   let date_to_refresh = date_token_expire - 5ph // vd token valid trong 30ph
    ///   // date_to_refresh => nên cache Date này cho so sánh nhanh
    ///   // thay vì dùng Date(), có thể dùng so sánh TimeInterval với ProcessInfo.processInfo.systemUptime
    ///   if date_now < date_to_refresh {
    ///     return doesNotRequireRefresh
    ///   }
    ///   return .requiresRefresh / requiresRefreshThenDelay(TimeInterval(0.25))
    /// }
    /// ````
    func shouldRefreshTokenIfRequired(endpoint: APIRouter) -> RequiresRefreshResult
    /// hàm gọi API refresh lấy (access) token mới
    func requestRefreshToken() async throws
    func requestRefreshToken() -> AnyPublisher<Void, Error>
}

extension GDomainTokenRefresher {
    /// Determines whether a token refresh is required before making the specified API call.
    /// - Parameter endpoint: The API endpoint to be accessed.
    /// - Returns: `.doesNotRequireRefresh`, indicating that a token refresh is not needed by default.
    func shouldRefreshTokenIfRequired(endpoint: APIRouter) -> RequiresRefreshResult {
        return .doesNotRequireRefresh
    }
}


// MARK: - Domain Retrier
protocol GDomainRetrier {
    func shouldRetry(endpoint: APIRouter, response: HTTPURLResponse?, data: Data?) throws -> RetryResult
}


//------------------------------------------------------------------------------
// MARK: - Domain Authentication Retrier (refresh token)
class GDomainAuthRetrier {
    private var refreshTask: Task<Void, Error>?
    
    let refreshTokenRetryCountMax: Int
    let refreshTokenRetryDelay: DispatchTimeInterval
    private(set)
        var refreshWindow: RefreshWindow?
    var refreshTimestamps: [TimeInterval] = []
    
    let domainRefreshRetrier: GDomainRetrier & GDomainTokenRefresher
    
    init(
        domainRefreshRetrier: GDomainRetrier & GDomainTokenRefresher,
        refreshTokenRetryCountMax: Int = 3,
        refreshTokenRetryDelay: DispatchTimeInterval = .milliseconds(250),
        refreshWindow: RefreshWindow? = RefreshWindow()
    ) {
        self.domainRefreshRetrier = domainRefreshRetrier
        self.refreshTokenRetryCountMax = refreshTokenRetryCountMax
        self.refreshTokenRetryDelay = refreshTokenRetryDelay
        self.refreshWindow = refreshWindow
    }
    
    /// Determines whether a token refresh is required before making a request to the specified API endpoint.
    /// - Parameter endpoint: The API endpoint to evaluate.
    /// - Returns: A `RequiresRefreshResult` indicating if a token refresh is needed, and if so, whether a delay should be applied.
    func shouldRefreshTokenIfRequired(endpoint: APIRouter) -> RequiresRefreshResult {
        domainRefreshRetrier.shouldRefreshTokenIfRequired(endpoint: endpoint)
    }
    
    /// Determines whether a request should be retried due to an authentication error, considering the availability of a refresh token.
    /// - Parameters:
    ///   - endpoint: The API endpoint being called.
    ///   - response: The HTTP response received, if any.
    ///   - data: The response data, if any.
    /// - Returns: A `RetryResult` indicating whether the request should be retried. If a retry is required but no refresh token is available, returns `.doNotRetry`.
    func shouldRetryDueToAuthenticationError(endpoint: APIRouter, response: HTTPURLResponse?, data: Data?) throws -> RetryResult {
        let retryResult = try domainRefreshRetrier.shouldRetry(endpoint: endpoint, response: response, data: data)
        if retryResult.retryRequired, domainRefreshRetrier.refreshToken.isEmpty { return .doNotRetry }
        return retryResult
    }
    
    /// Initiates a token refresh operation, ensuring concurrency control and rate limiting.
    /// - Throws: An error if the refresh operation fails or if excessive refresh attempts are detected.
    func refresh() async throws -> Void {
        return try await _refresh()
    }
    
    /// Performs a token refresh operation with concurrency control and rate limiting.
    /// - Throws: `APIRouterError.excessiveRefresh` if refresh attempts exceed the allowed rate, or any error thrown during the refresh process.
    func _refresh() async throws -> Void {
        guard !isRefreshExcessive() else {
            throw APIRouterError.excessiveRefresh
        }
        
        if let refreshTask = refreshTask {
            return try await refreshTask.value
        }
        
        let task = Task { () throws -> Void in
            defer { refreshTask = nil }
            
            refreshTimestamps.append(ProcessInfo.processInfo.systemUptime)
            try await attempts(maximumRetryCount: refreshTokenRetryCountMax, delayBeforeRetry: refreshTokenRetryDelay) {
                try await self.domainRefreshRetrier.requestRefreshToken()
            }
        }
        
        self.refreshTask = task
        
        return try await task.value
    }
    
    /// Determines whether the number of token refresh attempts within the configured refresh window exceeds the allowed maximum.
    /// - Returns: `true` if the refresh attempt limit has been reached within the specified interval; otherwise, `false`.
    func isRefreshExcessive() -> Bool {
        guard let refreshWindow = self.refreshWindow else { return false }
        
        let refreshWindowMin = ProcessInfo.processInfo.systemUptime - refreshWindow.interval
        
        refreshTimestamps = refreshTimestamps.filter({ refreshWindowMin <= $0 })
        let refreshAttemptsWithinWindow: Int = refreshTimestamps.count
        
        let isRefreshExcessive = refreshAttemptsWithinWindow >= refreshWindow.maximumAttempts
        
        return isRefreshExcessive
    }
}

//------------------------------------------------------------------------------
// MARK: - Default RefreshRetrier NoOp
class GDomainRefreshRetrierNoOpDefault: GDomainRetrier, GDomainTokenRefresher {
    
    static var sharedAuthRetrier = GDomainAuthRetrier(domainRefreshRetrier: GDomainRefreshRetrierNoOpDefault())
    
    /// Determines whether a request should be retried based on the HTTP response.
    /// - Returns: `.doNotRetryWithError` with a `serverUnauthenticated` error if the response status code is 401; otherwise, `.doNotRetry`.
    func shouldRetry(endpoint: APIRouter, response: HTTPURLResponse?, data: Data?) throws -> RetryResult {
        guard let response = response,
            response.statusCode == 401  // 403?
        else { return .doNotRetry }
        return .doNotRetryWithError(APIRouterError.serverUnauthenticated)
    }
    
    var refreshToken: String {
        ""
    }
    
    /// Throws an error indicating that token refresh is not implemented.
    func requestRefreshToken() async throws {
        throw APIRouterError.localError(message: APIRouterError.GenericError)
    }
    
    /// Returns a publisher that immediately fails with an error indicating token refresh is not implemented.
    /// - Returns: A publisher that fails with a local error for unimplemented token refresh functionality.
    func requestRefreshToken() -> AnyPublisher<Void, Error> {
        Fail<Void, Error>(error: APIRouterError.localError(message: "Token refresh not implemented"))
            .eraseToAnyPublisher()
    }
}


//------------------------------------------------------------------------------
// MARK: - Helper Types
enum RequiresRefreshResult {
    /// Retry should be attempted immediately.
    case requiresRefresh
    /// Retry should be attempted after the associated `TimeInterval`.
    case requiresRefreshThenDelay(TimeInterval)
    /// Do not retry.
    case doesNotRequireRefresh
}

extension RequiresRefreshResult {
    var requiresRefresh: Bool {
        switch self {
        case .requiresRefresh, .requiresRefreshThenDelay: return true
        default: return false
        }
    }
    
    var delay: TimeInterval? {
        switch self {
        case let .requiresRefreshThenDelay(delay): return delay
        default: return nil
        }
    }
}


//------------------------------------------------------------------------------
// MARK: - Alamofire 5.6.1
extension RetryResult {
    var retryRequired: Bool {
        switch self {
        case .retry, .retryWithDelay: return true
        default: return false
        }
    }
    
    var delay: TimeInterval? {
        switch self {
        case let .retryWithDelay(delay): return delay
        default: return nil
        }
    }
    
    var error: Error? {
        guard case let .doNotRetryWithError(error) = self else { return nil }
        return error
    }
}

/// Type that defines a time window used to identify excessive refresh calls. When enabled, prior to executing a
/// refresh, the `AuthenticationInterceptor` compares the timestamp history of previous refresh calls against the
/// `RefreshWindow`. If more refreshes have occurred within the refresh window than allowed, the refresh is
/// cancelled and an `AuthorizationError.excessiveRefresh` error is thrown.
struct RefreshWindow {
    /// `TimeInterval` defining the duration of the time window before the current time in which the number of
    /// refresh attempts is compared against `maximumAttempts`. For example, if `interval` is 30 seconds, then the
    /// `RefreshWindow` represents the past 30 seconds. If more attempts occurred in the past 30 seconds than
    /// `maximumAttempts`, an `.excessiveRefresh` error will be thrown.
    let interval: TimeInterval
    
    /// Total refresh attempts allowed within `interval` before throwing an `.excessiveRefresh` error.
    let maximumAttempts: Int
    
    /// Creates a `RefreshWindow` instance from the specified `interval` and `maximumAttempts`.
    ///
    /// - Parameters:
    ///   - interval:        `TimeInterval` defining the duration of the time window before the current time.
    ///   - maximumAttempts: The maximum attempts allowed within the `TimeInterval`.
    init(interval: TimeInterval = 30.0, maximumAttempts: Int = 5) {
        self.interval = interval
        self.maximumAttempts = maximumAttempts
    }
}
