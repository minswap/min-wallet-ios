import Foundation
import ObjectMapper
import Then

extension OrderHistory {
    struct Asset: Then, Hashable {
        var tokenId: String = ""
        var logo: String = ""
        private var ticker: String = ""
        var isVerified: Bool = false
        var priceByAda: Double = 0
        var project_name: String = ""
        var decimals: Int = 0
        
        var adaName: String = ""
        var token: TokenDefault?
        
        init() {}
    }
}

extension OrderHistory.Asset: Mappable {
    init?(map: Map) {}
    
    /// Maps JSON data from the provided map to the properties of the `Asset` struct.
    ///
    /// Populates asset fields such as identifiers, display information, verification status, pricing, and token details from the mapped JSON values. The `adaName` is set to the ticker if available, otherwise derived from the token ID. The `token` property is initialized and updated with the mapped values.
    mutating func mapping(map: Map) {
        tokenId <- map["token_id"]
        logo <- map["logo"]
        ticker <- map["ticker"]
        isVerified <- (map["is_verified"], GKMapFromJSONToBool)
        priceByAda <- (map["price_by_ada"], GKMapFromJSONToDouble)
        project_name <- map["project_name"]
        decimals <- (map["decimals"], GKMapFromJSONToInt)
        
        adaName = {
            if !ticker.isBlank { return ticker }
            return tokenId.tokenDefault.adaName
        }()
        
        token = (tokenId.tokenDefault as? TokenDefault)?
            .with({
                $0.mDecimals = decimals
                $0.mIsVerified = isVerified
                $0.mTicker = ticker
                $0.minName = project_name
            })
    }
}
