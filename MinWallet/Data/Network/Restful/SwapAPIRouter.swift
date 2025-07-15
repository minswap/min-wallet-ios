import Foundation
import Alamofire


enum SampleAPIRouter: DomainAPIRouter {
    case estimate
    case buildTX
    case signTX

    func path() -> String {
        switch self {
        case .estimate:
            return "/aggregator/wallet"
        case .buildTX:
            return "/aggregator/build-tx"
        case .signTX:
            return "/aggregator/finalize-and-submit-tx"
        }
    }

    func method() -> HTTPMethod {
        return .post
    }

    func parameters() -> Parameters {
        var params = Parameters()


        return params
    }
}
