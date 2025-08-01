import Foundation
import Alamofire


protocol DomainAPIRouter: APIRouter {}

extension DomainAPIRouter {
    /// Returns the base URL for API requests.
/// - Returns: An empty string by default. Override to specify a domain-specific base URL.
    func baseUrl() -> String { "" }
    /// Returns an empty set of HTTP headers for the request.
func headers() -> HTTPHeaders { .init() }
    /// Returns the default parameter encoding for network requests.
    
    func encoding() -> ParameterEncoding { defaultEncoding }
    
    /// Constructs a `URLRequest` using the default configuration.
/// - Throws: An error if the request cannot be created.
/// - Returns: A configured `URLRequest` instance.
func asURLRequest() throws -> URLRequest { try defaultAsURLRequest() }
    
    /// Returns the domain-specific headers context, or nil if none is provided by default.
    
    func domainHeadersContext() -> DomainHeadersContext? { nil }
    
    /// Returns the default authentication retrier for domain requests, or nil if not set.
/// By default, this provides a shared no-op authentication retrier instance.
func domainAuthRetrier() -> GDomainAuthRetrier? { GDomainRefreshRetrierNoOpDefault.sharedAuthRetrier }
}
