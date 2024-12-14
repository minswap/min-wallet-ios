import Foundation
import Alamofire


extension GDomainAPIRouter {
    func domainAdapter() -> GDomainAdapter? {
        MinWalletDomainAdapter.shared
    }
}

class MinWalletDomainAdapter: GDomainAdapter {

    static let shared = MinWalletDomainAdapter()

    private init() {}

    var baseURLString: String {
        ""
    }

    var accessToken: String {
        ""
    }

    private var defaultAdditionalHeaders: HTTPHeaders {
        var requestHeader = HTTPHeaders()

        if let text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            requestHeader["appVersion"] = text
        }

        return requestHeader
    }

    func adaptHeaders(context: GDomainHeadersContext?, headers: HTTPHeaders) -> HTTPHeaders {
        //guard UserDataManager.shared.isLogin else {  return headers }
        var requestHeader = headers

        requestHeader["Authorization"] = "Bearer " + "xxx"

        return requestHeader
    }
}
