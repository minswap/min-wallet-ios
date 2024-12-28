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
}
