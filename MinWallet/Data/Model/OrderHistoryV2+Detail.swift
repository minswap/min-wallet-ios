import Foundation
import ObjectMapper
import Then

extension OrderHistory {
    enum Direction: String {
        case aToB = "A_TO_B"
        case bToA = "B_TO_A"
    }
    
    enum OrderType: String {
        case swap = "SWAP"
        case limit = "LIMIT"
        case oco = "OCO"
        case stopLoss = "STOP_LOSS"
        case partialSwap = "PARTIAL_SWAP"
        case deposit = "DEPOSIT"
        case withdraw = "WITHDRAW"
        case zapIn = "ZAP_IN"
        case zapOut = "ZAP_OUT"
        case donation = "DONATION"
    }

    struct Detail: Then {
        var orderType: OrderType = .partialSwap
        var direction: Direction = .aToB
        var inputAmount: Double = 0 
        var executedAmount: Double = 0
        var minimumAmount: Double = 0
        var tradingFee: Double = 0
        var fillOrKill: Bool = false
        var routes: [Route] = []

        init() { }
    }
    
    struct Route: Then {
        var lpAssetId: String = ""
        var assets: [Asset] = []
        
        init() {}
    }
}

extension OrderHistory.Detail: Mappable {
    init?(map: Map) { }

    mutating func mapping(map: Map) {
        orderType <- map["order_type"]
        direction <- map["direction"]
        inputAmount <- (map["input_amount"], GKMapFromJSONToDouble)
        executedAmount <- (map["executed_amount"], GKMapFromJSONToDouble)
        tradingFee <- (map["trading_fee"], GKMapFromJSONToDouble)
        minimumAmount <- (map["minimum_amount"], GKMapFromJSONToDouble)
        fillOrKill <- map["fill_or_kill"]
        routes <- map["routes"]
    }
}


extension OrderHistory.Route: Mappable {
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        assets <- map["assets"]
        lpAssetId <- (map["lp_asset.token_id"], GKMapFromJSONToString)
    }
}
