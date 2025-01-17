import SwiftUI
import Then
import MinWalletAPI


extension TopAssetsQuery.Data.TopAssets.TopAsset: TokenProtocol {
    var currencySymbol: String {
        asset.currencySymbol
    }

    var tokenName: String {
        asset.tokenName
    }

    var isVerified: Bool {
        asset.metadata?.isVerified ?? false
    }

    var ticker: String {
        asset.metadata?.ticker ?? UserInfo.TOKEN_NAME_DEFAULT[uniqueID] ?? ""
    }

    var name: String {
        asset.metadata?.name ?? ""
    }

    var percentChange: Double {
        Double(priceChange24h) ?? 0
    }

    var priceValue: Double {
        Double(price) ?? 0
    }

    var subPriceValue: Double {
        0
    }

    var category: [String] {
        asset.details?.categories ?? []
    }

    var socialLinks: [SocialLinks: String] {
        guard let socialLinks = asset.details?.socialLinks else { return [:] }
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
        return links
    }

    var decimals: Int {
        asset.metadata?.decimals ?? 0
    }
}


extension WalletAssetsQuery.Data.GetWalletAssetsPositions.Asset: TokenProtocol {
    var currencySymbol: String {
        amountAsset.asset.currencySymbol
    }

    var tokenName: String {
        amountAsset.asset.tokenName
    }

    var isVerified: Bool {
        amountAsset.asset.metadata?.isVerified ?? false
    }

    var ticker: String {
        amountAsset.asset.metadata?.ticker ?? UserInfo.TOKEN_NAME_DEFAULT[uniqueID] ?? ""
    }

    var name: String {
        amountAsset.asset.metadata?.name ?? ""
    }

    var priceValue: Double {
        let decimals = pow(10.0, Double(amountAsset.asset.metadata?.decimals ?? 0))
        let price = (Double(amountAsset.amount) ?? 0) / decimals
        return price
    }

    var amount: Double {
        priceValue
    }

    var percentChange: Double {
        Double(pnl24H) ?? 0
    }

    var subPriceValue: Double {
        Double(valueInAda) ?? 0
    }

    var category: [String] {
        amountAsset.asset.details?.categories ?? []
    }

    var socialLinks: [SocialLinks: String] {
        guard let socialLinks = amountAsset.asset.details?.socialLinks else { return [:] }
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
        return links
    }

    var decimals: Int {
        amountAsset.asset.metadata?.decimals ?? 0
    }
}

extension WalletAssetsQuery.Data.GetWalletAssetsPositions.LpToken: TokenProtocol {
    var currencySymbol: String {
        amountLPAsset.asset.currencySymbol
    }

    var tokenName: String {
        amountLPAsset.asset.tokenName
    }

    var isVerified: Bool {
        amountLPAsset.asset.metadata?.isVerified ?? false
    }

    var ticker: String {
        amountLPAsset.asset.metadata?.ticker ?? UserInfo.TOKEN_NAME_DEFAULT[uniqueID] ?? ""
    }

    var name: String {
        amountLPAsset.asset.metadata?.name ?? ""
    }

    var percentChange: Double {
        Double(pnl24H) ?? 0
    }

    var priceValue: Double {
        let decimals = pow(10.0, Double(amountLPAsset.asset.metadata?.decimals ?? 0))
        let price = (Double(amountLPAsset.amount) ?? 0) / decimals
        return price
    }

    var amount: Double {
        priceValue
    }

    var subPriceValue: Double {
        Double(lpAdaValue) ?? 0
    }

    var category: [String] {
        amountLPAsset.asset.details?.categories ?? []
    }
    var socialLinks: [SocialLinks: String] {
        guard let socialLinks = amountLPAsset.asset.details?.socialLinks else { return [:] }
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
        return links
    }

    var decimals: Int {
        amountLPAsset.asset.metadata?.decimals ?? 0
    }
}


struct TokenProtocolDefault: TokenProtocol {
    var currencySymbol: String {
        "d71432b5e54b92cde0748af0903b90cc3758a40e0283aabd7e734c99"
    }

    var tokenName: String {
        "0014df104d696e696f6e204368726973746d6173"
    }

    var isVerified: Bool {
        true
    }

    var ticker: String {
        "Ticker"
    }

    var name: String {
        "Name"
    }

    var percentChange: Double {
        20.00
    }

    var priceValue: Double {
        0.000002
    }

    var subPriceValue: Double {
        10000
    }

    var category: [String] {
        ["DEX", "DeFi", "Smart contract", "Staking", "Staking", "Staking", "Staking"]
    }

    var socialLinks: [SocialLinks: String] {
        return [.coinGecko: ""]
    }
    var decimals: Int {
        2
    }

    init() {}
}


extension AssetsQuery.Data.Assets.Asset: TokenProtocol {
    var isVerified: Bool {
        metadata?.isVerified ?? false
    }

    var ticker: String {
        metadata?.ticker ?? UserInfo.TOKEN_NAME_DEFAULT[uniqueID] ?? ""
    }

    var name: String {
        metadata?.name ?? ""
    }

    var priceValue: Double {
        /* TODO: price value
        let decimals = pow(10.0, Double(amountAsset.asset.metadata?.decimals ?? 0))
        let price = (Double(amountAsset.amount) ?? 0) / decimals
        return price
         */
        return 0
    }

    var percentChange: Double {
        0
    }

    var subPriceValue: Double {
        0
    }

    var category: [String] {
        details?.categories ?? []
    }

    var socialLinks: [SocialLinks: String] {
        guard let socialLinks = details?.socialLinks else { return [:] }
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
        return links
    }

    var decimals: Int {
        metadata?.decimals ?? 0
    }
}


extension RiskCategory: Identifiable {
    public var id: UUID {
        UUID()
    }

    var textColor: Color {
        switch self {
        case .a, .aa, .aaa:
            return Color.colorDecorativeLeafSub
        case .b, .bb, .bbb:
            return .colorDecorativeYellowSub
        case .c, .cc, .ccc:
            return .colorDecorativeCreamSub
        case .d:
            return .colorBaseTent
        }
    }

    var backgroundColor: Color {
        switch self {
        case .a, .aa, .aaa:
            return Color.colorDecorativeLeaf
        case .b, .bb, .bbb:
            return .colorDecorativeYellowDefault
        case .c, .cc, .ccc:
            return .colorDecorativeCream
        case .d:
            return .colorInteractiveDangerDefault
        }
    }
}

enum SocialLinks: String {
    case coinGecko
    case coinMarketCap
    case discord
    case telegram
    case twitter
    case website

    var image: ImageResource {
        switch self {
        case .coinGecko:
            return .icCoingecko
        case .coinMarketCap:
            return .icCoincap
        case .discord:
            return .icDiscord
        case .telegram:
            return .icTelegram
        case .twitter:
            return .icTwitter
        case .website:
            return .icWebsite
        }
    }
}

extension RoutedPoolsByPairQuery.Data.RoutedPoolsByPair.Pool.PoolAsset {
    var uniqueID: String {
        if currencySymbol.isEmpty && tokenName.isEmpty {
            return "lovelace"
        }
        return currencySymbol + "." + tokenName
    }
}

extension RoutedPoolsByPairQuery.Data.RoutedPoolsByPair.Routing.Routing {
    var uniqueID: String {
        if currencySymbol.isEmpty && tokenName.isEmpty {
            return "lovelace"
        }
        return currencySymbol + "." + tokenName
    }
}

struct TokenDefault: TokenProtocol {
    var currencySymbol: String {
        symbol
    }

    var tokenName: String {
        tName
    }

    var isVerified: Bool { false }

    var ticker: String { "" }

    var name: String { "" }

    var category: [String] { [] }

    var percentChange: Double { 0 }

    var priceValue: Double { 0 }

    var subPriceValue: Double { 0 }

    var socialLinks: [SocialLinks: String] { [:] }

    var decimals: Int { 0 }

    var symbol: String = ""
    var tName: String = ""

    init(symbol: String, tName: String) {
        self.symbol = symbol
        self.tName = tName
    }
}
