import Foundation
import Then
import MinWalletAPI


protocol TokenProtocol {
    var currencySymbol: String { get }
    var tokenName: String { get }
    var isVerified: Bool { get }
    var ticker: String { get }
    var name: String { get }
    
    var percentChange: Double { get }
    
    var priceValue: Double { get }
    var subPriceValue: Double { get }
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
        asset.metadata?.ticker ?? ""
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
        amountAsset.asset.metadata?.ticker ?? ""
    }
    
    var name: String {
        amountAsset.asset.metadata?.name ?? ""
    }
    
    var priceValue: Double {
        let decimals = pow(10.0, Double(amountAsset.asset.metadata?.decimals ?? 0))
        let price = (Double(amountAsset.amount) ?? 0) / decimals
        return price
    }
    
    var percentChange: Double {
        Double(pnl24H) ?? 0
    }
    
    var subPriceValue: Double {
        Double(valueInAda) ?? 0
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
        amountLPAsset.asset.metadata?.ticker ?? ""
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
    
    var subPriceValue: Double {
        Double(lpAdaValue) ?? 0
    }
}


struct TokenProtocolDefault: TokenProtocol {
    var currencySymbol: String {
        "0254a6ffa78edb03ea8933dbd4ca078758dbfc0fc6bb0d28b7a9c89f"
    }
    
    var tokenName: String {
        "444a4544"
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
    
    init() { }
}
