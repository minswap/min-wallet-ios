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


struct EstimationResponse: Mappable {
    var tokenIn: String = ""
    var tokenOut: String = ""
    var amountIn: String = ""
    var amountOut: String = ""
    var minAmountOut: String = ""
    var totalLpFee: String = ""
    var totalDexFee: String = ""
    var deposits: String = ""
    var avgPriceImpact: Double = 0.0
    var paths: [[SwapPath]] = []
    var amountInDecimal: Bool = false
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        tokenIn         <- map["token_in"]
        tokenOut        <- map["token_out"]
        amountIn        <- map["amount_in"]
        amountOut       <- map["amount_out"]
        minAmountOut    <- map["min_amount_out"]
        totalLpFee      <- map["total_lp_fee"]
        totalDexFee     <- map["total_dex_fee"]
        deposits        <- map["deposits"]
        avgPriceImpact  <- (map["avg_price_impact"], 
                            GKMapFromJSONToDouble)
        paths           <- map["paths"]
        amountInDecimal <- map["amount_in_decimal"]
    }
}

struct SwapPath: Mappable {
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
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        lpToken         <- map["lp_token"]
        tokenIn         <- map["token_in"]
        tokenOut        <- map["token_out"]
        amountIn        <- map["amount_in"]
        amountOut       <- map["amount_out"]
        minAmountOut    <- map["min_amount_out"]
        lpFee           <- map["lp_fee"]
        dexFee          <- map["dex_fee"]
        deposits        <- map["deposits"]
        priceImpact     <- map["price_impact"]
        poolId          <- map["pool_id"]
        protocolName    <- map["protocol"]
    }
}


/*
{
    "token_in": "lovelace",
    "token_out": "29d222ce763455e3d7a09a665ce554f00ac89d2e99a1a83d267170c64d494e",
    "amount_in": "1",
    "amount_out": "36.706439",
    "min_amount_out": "36.523819",
    "total_lp_fee": "0.003",
    "total_dex_fee": "0.9",
    "deposits": "2",
    "avg_price_impact": 0.30014266734933054,
    "paths": [
        [
            {
            "lp_token": "e4214b7cce62ac6fbba385d164df48e157eae5863521b4b67ca71d866aa2153e1ae896a95539c9d62f76cedcdabdcdf144e564b8955f609d660cf6a2",
            "token_in": "lovelace",
            "token_out": "29d222ce763455e3d7a09a665ce554f00ac89d2e99a1a83d267170c64d494e",
            "amount_in": "1",
            "amount_out": "36.706439",
            "min_amount_out": "36.523819",
            "lp_fee": "0.003",
            "dex_fee": "0.9",
            "deposits": "2",
            "price_impact": 0.30014266734933054,
            "pool_id": "lovelace.29d222ce763455e3d7a09a665ce554f00ac89d2e99a1a83d267170c64d494e",
            "protocol": "Minswap"
            }
        ]
    ],
    "amount_in_decimal": true
}
*/
