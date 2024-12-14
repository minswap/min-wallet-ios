import Foundation
import Alamofire


// MARK: - Domain Adapter
protocol GDomainAdapter {
    var baseURLString: String { get }
    var accessToken: String { get }
    func defaultHeaders(context: GDomainHeadersContext?) -> HTTPHeaders
    func adaptHeaders(context: GDomainHeadersContext?, headers: HTTPHeaders) -> HTTPHeaders
}

extension GDomainAdapter {
    func defaultHeaders(context: GDomainHeadersContext?) -> HTTPHeaders {
        adaptHeaders(context: context, headers: .init())
    }
}

// MARK: - Headers Context
protocol GDomainHeadersContext {}

//------------------------------------------------------------------------------
// MARK: - Default Adapter
public
    struct GDomainAdapterDefault: GDomainAdapter
{
    var baseURLString: String = ""
    var accessToken: String = ""
    func adaptHeaders(context: GDomainHeadersContext?, headers: HTTPHeaders) -> HTTPHeaders {
        headers
    }
}
