import Foundation
import ObjectMapper
import Then

extension OrderHistory {
    struct Asset: Then, Hashable {
        var tokenId: String = ""
        var logo: String = ""
        var ticker: String = ""
        var isVerified: Bool = false
        var priceByAda: Double = 0
        var project_name: String = ""
        var decimals: Int = 0

        init() { }
    }
}

extension OrderHistory.Asset: Mappable {
    init?(map: Map) { }

    mutating func mapping(map: Map) {
        tokenId <- map["token_id"]
        logo <- map["logo"]
        ticker <- map["ticker"]
        isVerified <- (map["is_verified"], GKMapFromJSONToBool)
        priceByAda <- (map["price_by_ada"], GKMapFromJSONToDouble)
        project_name <- map["project_name"]
        decimals <- (map["decimals"], GKMapFromJSONToInt)
    }
}
