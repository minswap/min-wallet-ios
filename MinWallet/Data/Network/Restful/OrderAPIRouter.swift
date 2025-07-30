import Foundation
import Alamofire


enum OrderAPIRouter: DomainAPIRouter {
    case getOrders(address: String, limit: Int, cursor: String)
    
    func path() -> String {
        switch self {
        case .getOrders:
            return "/aggregator/orders"
        }
    }
    
    func method() -> HTTPMethod {
        return .post
    }
    
    func parameters() -> Parameters {
        var params = Parameters()
        
        switch self {
            case let .getOrders(address, limit, cursor):
            params["owner_address"] = address
            params["limit"] = limit
            params["cursor"] = cursor
            params["amount_in_decimal"] = false
        }
        return params
    }
}
