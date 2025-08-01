import Foundation
import Alamofire


// MARK: - Domain Adapter
protocol DomainAdapter {
    var baseURLString: String { get }
    var accessToken: String { get }
    func defaultHeaders(context: DomainHeadersContext?) -> HTTPHeaders
    func adaptHeaders(context: DomainHeadersContext?, headers: HTTPHeaders) -> HTTPHeaders
}

extension DomainAdapter {
    /// Returns the default HTTP headers for a request, optionally using the provided context.
    /// - Parameter context: Optional contextual information for customizing the headers.
    /// - Returns: The default HTTP headers, potentially adapted based on the context.
    func defaultHeaders(context: DomainHeadersContext?) -> HTTPHeaders {
        adaptHeaders(context: context, headers: .init())
    }
}

// MARK: - Headers Context
protocol DomainHeadersContext {}

//------------------------------------------------------------------------------
// MARK: - Default Adapter
public
    struct DomainAdapterDefault: DomainAdapter
{
    var baseURLString: String = ""
    var accessToken: String = ""
    /// Returns the provided HTTP headers without modification.
    /// - Parameters:
    ///   - context: Optional contextual information for header adaptation.
    ///   - headers: The original HTTP headers to be adapted.
    /// - Returns: The unmodified HTTP headers.
    func adaptHeaders(context: DomainHeadersContext?, headers: HTTPHeaders) -> HTTPHeaders {
        headers
    }
}
