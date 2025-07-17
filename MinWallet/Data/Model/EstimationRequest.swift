import Foundation
import ObjectMapper
import Then


struct EstimationRequest: Then {
    var amount: String = ""
    var token_in: String = ""
    var token_out: String = ""
    var slippage: Double = 0
    var exclude_protocols: [AggregatorSource] = []
    var allow_multi_hops: Bool = true
    var amount_in_decimal: Bool = false
    
    init() {}
}


struct EstimationResponse: Mappable, Then {
    var tokenIn: String = ""
    var tokenOut: String = ""
    var amountIn: String = ""
    var amountOut: String = ""
    var minAmountOut: String = ""
    var totalLpFee: String = ""
    var totalDexFee: String = ""
    var aggregatorFee: String = ""
    var deposits: String = ""
    var avgPriceImpact: Double = 0.0
    var paths: [[SwapPath]] = []
    var amountInDecimal: Bool = false
    var percents: [Double] = []
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        tokenIn <- map["token_in"]
        tokenOut <- map["token_out"]
        amountIn <- map["amount_in"]
        amountOut <- map["amount_out"]
        minAmountOut <- map["min_amount_out"]
        totalLpFee <- map["total_lp_fee"]
        totalDexFee <- map["total_dex_fee"]
        aggregatorFee <- map["aggregator_fee"]
        deposits <- map["deposits"]
        avgPriceImpact <- (
            map["avg_price_impact"],
            GKMapFromJSONToDouble
        )
        paths <- map["paths"]
        amountInDecimal <- map["amount_in_decimal"]
        
        calculatePercentSwapPath()
    }
    
    private mutating func calculatePercentSwapPath() {
        
        let totalAmountIn = max(amountIn.gkDoubleValue, 1)
        percents = paths.map({ path in
            let amountIn = path.first?.amountIn.gkDoubleValue ?? 0.0
            return (amountIn / totalAmountIn) * 100
        })
        /* TODO: cuongnv test sau
        if let percent = percents[gk_safeIndex: paths.count - 1] {
            let sumAll = percents.reduce(0.0, +)
            if sumAll != 100 {
                percents[paths.count - 1]  =
            }
        }
         */
    }
}

struct SwapPath: Mappable, Identifiable {
    var id: UUID = .init()
    
    var lpToken: String = ""
    var tokenIn: String = ""
    var tokenOut: String = ""
    var amountIn: String = ""
    var amountOut: String = ""
    var minAmountOut: String = ""
    var lpFee: String = ""
    var dexFee: String = ""
    var deposits: String = ""
    var priceImpact: Double = 0.0
    var poolId: String = ""
    var protocolName: String = ""
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        lpToken <- map["lp_token"]
        tokenIn <- map["token_in"]
        tokenOut <- map["token_out"]
        amountIn <- map["amount_in"]
        amountOut <- map["amount_out"]
        minAmountOut <- map["min_amount_out"]
        lpFee <- map["lp_fee"]
        dexFee <- map["dex_fee"]
        deposits <- map["deposits"]
        priceImpact <- map["price_impact"]
        poolId <- map["pool_id"]
        protocolName <- map["protocol"]
    }
}
