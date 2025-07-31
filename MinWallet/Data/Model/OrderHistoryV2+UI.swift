import Foundation
import Then


extension OrderHistory {
    struct InputOutput: Hashable, Then, Identifiable {
        var id: String {
            asset.tokenId
        }
        
        var asset: Asset = .init()
        var amount: Double = 0
        
        init(asset: Asset?, amount: Double) {
            self.asset = asset ?? .init()
            self.amount = amount.toExact(decimal: asset?.decimals ?? 0)
        }
    }
}


extension OrderHistory.InputOutput {
    var currency: String {
        asset.adaName
    }
    
    var currencySymbol: String {
        asset.token?.currencySymbol ?? ""
    }
    
    var tokenName: String {
        asset.token?.tokenName ?? ""
    }
    
    var isVerified: Bool {
        asset.isVerified
    }
}
