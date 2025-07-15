import Foundation
import Alamofire


extension DomainAPIRouter {
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

    func adaptHeaders(context: DomainHeadersContext?, headers: HTTPHeaders) -> HTTPHeaders {
        return headers
    }
}
