import SwiftUI
import Then
import MinWalletAPI


extension TopAssetQuery.Data.TopAsset: TokenProtocol {
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
    
    var projectName: String {
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
    
    var hasMetaData: Bool {
        asset.metadata != nil
    }
}

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
    
    var projectName: String {
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
    
    var hasMetaData: Bool {
        asset.metadata != nil
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
    
    var projectName: String {
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
    
    var hasMetaData: Bool {
        amountAsset.asset.metadata != nil
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
    
    var projectName: String {
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
    
    var hasMetaData: Bool {
        amountLPAsset.asset.metadata != nil
    }
}


extension WalletAssetsQuery.Data.GetWalletAssetsPositions.Nft: TokenProtocol {
    var currencySymbol: String { asset.currencySymbol }
    var tokenName: String { asset.tokenName }
    var isVerified: Bool { false }
    var ticker: String { "" }
    var projectName: String { "" }
    var percentChange: Double { 0 }
    var priceValue: Double { 0 }
    var amount: Double { 0 }
    var subPriceValue: Double { 0 }
    var category: [String] { [] }
    var socialLinks: [SocialLinks: String] { [:] }
    var decimals: Int { 0 }
    
    var nftDisplayName: String { displayName ?? "" }
    var nftImage: String { image ?? "" }
    var hasMetaData: Bool { true }
}


struct TokenProtocolDefault: TokenProtocol {
    var currencySymbol: String {
        "0c787a604cc2ec986455f289013fae122f7a808a23e07ca09e16a2b0"
    }
    
    var tokenName: String {
        "0014df1061647366"
    }
    
    var isVerified: Bool {
        true
    }
    
    var ticker: String {
        "Ticker"
    }
    
    var projectName: String {
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
    
    var hasMetaData: Bool {
        true
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
    
    var projectName: String {
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
    
    var hasMetaData: Bool {
        metadata != nil
    }
}


extension RiskCategory: @retroactive Identifiable {
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
    
    var order: Int {
        switch self {
        case .coinGecko:
            0
        case .coinMarketCap:
            1
        case .discord:
            2
        case .telegram:
            3
        case .twitter:
            4
        case .website:
            5
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
    
    var projectName: String { minName }
    
    var category: [String] { [] }
    
    var percentChange: Double { 0 }
    
    var priceValue: Double {
        netValue
    }
    
    var subPriceValue: Double {
        netSubValue
    }
    
    var socialLinks: [SocialLinks: String] { [:] }
    
    var decimals: Int { mDecimals }
    
    var symbol: String = ""
    var tName: String = ""
    var minName: String = ""
    var netValue: Double = 0
    var netSubValue: Double = 0
    var mDecimals: Int = 0
    var amount: Double {
        netValue
    }
    
    var hasMetaData: Bool {
        true
    }
    
    init(
        symbol: String,
        tName: String,
        minName: String = "",
        netValue: Double = 0,
        netSubValue: Double = 0,
        decimal: Int = 0
    ) {
        self.symbol = symbol
        self.tName = tName
        self.minName = minName
        self.netValue = netValue
        self.netSubValue = netSubValue
        self.mDecimals = decimal
    }
}

extension TokenProtocol {
    private func isIPFSUrl(_ ipfs: String) -> Bool {
        return ipfs.hasPrefix(MinWalletConstant.IPFS_PREFIX)
    }
    
    private func buildIPFSFromUrl(_ ipfsUrl: String) -> String? {
        guard let data = ipfsUrl.components(separatedBy: MinWalletConstant.IPFS_PREFIX).last else {
            return nil
        }
        return MinWalletConstant.IPFS_GATEWAY + data
    }
    
    func buildNFTURL() -> String? {
        isIPFSUrl(nftImage) ? buildIPFSFromUrl(nftImage) : nil
    }
    
    var isAdaHandleName: Bool {
        currencySymbol == UserInfo.POLICY_ID
    }
}
