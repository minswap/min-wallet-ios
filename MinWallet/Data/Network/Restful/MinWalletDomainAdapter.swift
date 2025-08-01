import Foundation
import Alamofire


extension DomainAPIRouter {
    /// Returns the shared instance of `MinWalletDomainAdapter` as the domain adapter.
    func domainAdapter() -> DomainAdapter? {
        MinWalletDomainAdapter.shared
    }
}

fileprivate class MinWalletDomainAdapter: DomainAdapter {
    
    static let shared = MinWalletDomainAdapter()
    
    private init() {}
    
    var baseURLString: String { MinWalletConstant.minAggURL }
    
    var accessToken: String { "" }
    
    private var defaultAdditionalHeaders: HTTPHeaders {
        var requestHeader = HTTPHeaders()
        
        if let text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            requestHeader["appVersion"] = text
        }
        
        return requestHeader
    }
    
    /// Merges default HTTP headers with the provided headers, giving precedence to the provided values.
    /// - Parameters:
    ///   - context: Optional context for header adaptation (not used in this implementation).
    ///   - headers: The HTTP headers to merge with the defaults.
    /// - Returns: The combined set of HTTP headers.
    func adaptHeaders(context: DomainHeadersContext?, headers: HTTPHeaders) -> HTTPHeaders {
        var mergedHeaders = defaultAdditionalHeaders
        headers.forEach { mergedHeaders[$0.name] = $0.value }
        return mergedHeaders
    }
}
