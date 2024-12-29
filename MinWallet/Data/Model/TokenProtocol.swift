import Foundation
import Then
import MinWalletAPI


protocol TokenProtocol {
    var currencySymbol: String { get }
    var tokenName: String { get }
    var isVerified: Bool { get }
    var ticker: String { get }
    var price: String { get }
    var name: String { get }
    var changePercent: Double { get }
    var priceChange24h: String { get }
    var subPrice: String { get }
}

extension TopAssetQuery.Data.TopAssets.TopAsset: TokenProtocol {
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
    
    var changePercent: Double {
        Double(priceChange24h) ?? 0
    }
    
    var subPrice: String {
        ""
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
    
    var price: String {
        //TODO: amount
        ""
    }
    
    var name: String {
        amountAsset.asset.metadata?.name ?? ""
    }
    
    var changePercent: Double {
        0
    }
    
    var priceChange24h: String {
        pnl24H
    }
    
    var subPrice: String {
        valueInAda
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
    
    var price: String {
        ""
    }
    
    var name: String {
        amountLPAsset.asset.metadata?.name ?? ""
    }
    
    var changePercent: Double {
        0
    }
    
    var priceChange24h: String {
        pnl24H
    }
    
    var subPrice: String {
        lpAdaValue
    }
    
}
