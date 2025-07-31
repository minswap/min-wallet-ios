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

    struct Detail: Then, Hashable {
        var lpAsset: Asset?
        var inputAsset: Asset?
        var receiveAsset: Asset?
        var orderType: OrderType = .partialSwap
        var direction: Direction?
        var inputAmount: Double = 0 
        var executedAmount: Double = 0
        var minimumAmount: Double = 0
        var limitAmount: Double = 0
        var minSwapAmount: Double = 0
        var changeAmount: Double = 0
        
        var receiveLpAmount: Double = 0
        var depositAmountA: Double = 0
        var depositAmountB: Double = 0
        
        var withdrawLpAmount: Double = 0
        var minimumAmountA: Double = 0
        var minimumAmountB: Double = 0
        var receiveAmountA: Double = 0
        var receiveAmountB: Double = 0
        var receiveAmount: Double = 0
        var lpAmount: Double = 0
        var swapAmount: Double = 0
        
        var maxSwapTime: Int = 0
        var tradingFee: Double = 0
        var fillOrKill: Bool = false
        var routes: [Route] = []
        var expireAt: String? = nil
        
        init() { }
    }
    
    struct Route: Then, Hashable {
        var lpAsset: Asset = .init()
        var assets: [Asset] = []
        
        init() {}
    }
}

extension OrderHistory.Detail: Mappable {
    init?(map: Map) { }

    mutating func mapping(map: Map) {
        orderType <- map["order_type"]
        lpAsset <- map["lp_asset"]
        inputAsset <- map["input_asset"]
        receiveAsset <- map["receive_asset"]
        direction <- map["direction"]
        inputAmount <- (map["input_amount"], GKMapFromJSONToDouble)
        executedAmount <- (map["executed_amount"], GKMapFromJSONToDouble)
        tradingFee <- (map["trading_fee"], GKMapFromJSONToDouble)
        minimumAmount <- (map["minimum_amount"], GKMapFromJSONToDouble)
        changeAmount <- (map["change_amount"], GKMapFromJSONToDouble)
        limitAmount <- (map["limit_amount"], GKMapFromJSONToDouble)
        minSwapAmount <- (map["min_swap_amount"], GKMapFromJSONToDouble)
        receiveLpAmount <- (map["receive_lp_amount"], GKMapFromJSONToDouble)
        depositAmountA <- (map["deposit_amount_a"], GKMapFromJSONToDouble)
        depositAmountB <- (map["deposit_amount_b"], GKMapFromJSONToDouble)
        withdrawLpAmount <- (map["withdraw_lp_amount"], GKMapFromJSONToDouble)
        minimumAmountA <- (map["minimum_amount_a"], GKMapFromJSONToDouble)
        minimumAmountB <- (map["minimum_amount_b"], GKMapFromJSONToDouble)
        receiveAmountA <- (map["receive_amount_a"], GKMapFromJSONToDouble)
        receiveAmountB <- (map["receive_amount_b"], GKMapFromJSONToDouble)
        lpAmount <- (map["lp_amount"], GKMapFromJSONToDouble)
        swapAmount <- (map["swap_amount"], GKMapFromJSONToDouble)
        receiveAmount <- (map["receive_amount"], GKMapFromJSONToDouble)
        
        fillOrKill <- map["fill_or_kill"]
        routes <- map["routes"]
        expireAt <- map["expire_at"]
        maxSwapTime <- (map["max_swap_time"], GKMapFromJSONToInt)
    }
}


extension OrderHistory.Route: Mappable {
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        assets <- map["assets"]
        lpAsset <- map["lp_asset"]
    }
}
