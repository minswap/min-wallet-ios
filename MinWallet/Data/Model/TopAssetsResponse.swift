import Then
import ObjectMapper
import Foundation


struct TopAssetsResponse: Then, Mappable {
    var search_after: [Any]?
    var assets: [AssetMetric] = []
    
    init() {}
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        search_after <- map["search_after"]
        assets <- map["asset_metrics"]
    }
}

extension TopAssetsResponse {
    struct AssetMetric: Then, Mappable, Hashable {
        var asset: AssetData = .init()
        
        var price_usd: Double = 0
        var price_change_1h: Double = 0
        var price_change_24h: Double = 0
        var price_change_7d: Double = 0
        var volume_usd_1h: Double = 0
        var volume_usd_24h: Double = 0
        var volume_usd_7d: Double = 0
        var liquidity_usd: Double = 0
        var market_cap_usd: Double = 0
        var fully_diluted_usd: Double = 0
        var total_supply: Double = 0
        var circulating_supply: Double = 0
        var created_at: String = ""
        var created_tx_id: String = ""
        var categories: [String] = []
        
        init() {}
        init?(map: Map) {}
        
        mutating func mapping(map: Map) {
            asset <- map["asset"]
            price_usd <- (map["price_usd"], GKMapFromJSONToDouble)
            price_change_1h <- (map["price_change_1h"], GKMapFromJSONToDouble)
            price_change_24h <- (map["price_change_24h"], GKMapFromJSONToDouble)
            price_change_7d <- (map["price_change_7d"], GKMapFromJSONToDouble)
            volume_usd_1h <- (map["volume_usd_1h"], GKMapFromJSONToDouble)
            volume_usd_24h <- (map["volume_usd_24h"], GKMapFromJSONToDouble)
            volume_usd_7d <- (map["volume_usd_7d"], GKMapFromJSONToDouble)
            liquidity_usd <- (map["liquidity_usd"], GKMapFromJSONToDouble)
            market_cap_usd <- (map["market_cap_usd"], GKMapFromJSONToDouble)
            fully_diluted_usd <- (map["fully_diluted_usd"], GKMapFromJSONToDouble)
            total_supply <- (map["total_supply"], GKMapFromJSONToDouble)
            circulating_supply <- (map["circulating_supply"], GKMapFromJSONToDouble)
            created_at <- map["created_at"]
            created_tx_id <- map["created_tx_id"]
            categories <- map["categories"]
        }
    }
}


extension TopAssetsResponse.AssetMetric: TokenProtocol {
    var currencySymbol: String { asset.currencySymbol }
    var tokenName: String { asset.tokenName }
    var isVerified: Bool { asset.is_verified }
    var ticker: String { asset.metadata?.ticker ?? UserInfo.TOKEN_NAME_DEFAULT[uniqueID] ?? "" }
    var projectName: String { asset.metadata?.name ?? "" }
    var percentChange: Double { price_change_24h }
    var priceValue: Double { price_usd }
    var subPriceValue: Double { 0 }
    
    var category: [String] { categories }
    
    var socialLinks: [SocialLinks: String] {
        let socialLinks = asset.social_links ?? .init()
        var links: [SocialLinks: String] = [:]
        if let coinGecko = socialLinks.coinGecko {
            links[.coinGecko] = coinGecko
        }
        if let coinMarketCap = socialLinks.coinMarketCap {
            links[.coinMarketCap] = coinMarketCap
        }
        if let discord = socialLinks.discord {
            links[.discord] = discord
        }
        if let telegram = socialLinks.telegram {
            links[.telegram] = telegram
        }
        if let telegram = socialLinks.telegram {
            links[.telegram] = telegram
        }
        if let twitter = socialLinks.twitter {
            links[.twitter] = twitter
        }
        if let website = socialLinks.website {
            links[.website] = website
        }
        links[.cardanoscan] = "https://cardanoscan.io/token/\(currencySymbol)\(tokenName)"
        links[.adaStat] = "https://adastat.net/tokens/\(currencySymbol)\(tokenName)"
        return links
    }
    
    var decimals: Int { asset.metadata?.decimals ?? 0 }
    var hasMetaData: Bool { asset.metadata != nil }
}
