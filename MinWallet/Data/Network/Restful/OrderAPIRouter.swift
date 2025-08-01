import Foundation
import Alamofire


enum OrderAPIRouter: DomainAPIRouter {
    case getOrders(request: OrderHistory.Request)
    
    /// Returns the API endpoint path for the current order-related request case.
    func path() -> String {
        switch self {
        case .getOrders:
            return "/aggregator/orders"
        }
    }
    
    /// Returns the HTTP method used for the API request, which is always POST.
    func method() -> HTTPMethod {
        return .post
    }
    
    /// Constructs and returns the parameters dictionary for the API request based on the associated `OrderHistory.Request`.
    /// - Returns: A dictionary of parameters including mandatory and optional fields required for fetching order history.
    func parameters() -> Parameters {
        var params = Parameters()
        
        switch self {
        case let .getOrders(request):
            params["owner_address"] = request.ownerAddress
            params["limit"] = request.limit
            if let cursor = request.cursor {
                params["cursor"] = cursor
            }
            params["amount_in_decimal"] = false
            if let status = request.status {
                params["status"] = status.rawValue
            }
            if let source = request.source {
                params["protocol"] = source.rawId
            }
            if let type = request.type {
                params["type"] = type.rawValue
            }
            if let token = request.token {
                params["token"] = token
            }
            if let txId = request.txId {
                params["tx_id"] = txId
            }
            if let fromTime = request.fromTime {
                params["from_time"] = fromTime
            }
            if let toTime = request.toTime {
                params["to_time"] = toTime
            }
        }
        return params
    }
}
