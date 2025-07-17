import Foundation
import Then
import MinWalletAPI


struct Token: Then, Hashable {
    var currencySymbol: String = ""
    var tokenName: String = ""
    var ticker: String = ""
    var project: String = ""
    var decimals: Int = 6
    var isVerified: Bool = false
    
    var url: URL?
}


extension TopAssetsInput: @retroactive Then {}
extension TopAssetsSortInput: @retroactive Then {}
extension AssetsInput: @retroactive Then {}
