import SwiftUI
import MinWalletAPI


struct SwapTokenSetting {
    var safeMode: Bool = true
    var autoRouter: Bool = true
    var slippageTolerance: String = ""
    var slippageSelected: SwapTokenSettingView.Slippage? = ._01
    var excludedPools: [AggregatorSource] = []
    
    init() {}
    
    /// Returns the selected slippage value as a Double.
    /// If a predefined slippage option is selected, its value is returned; otherwise, the custom slippage tolerance string is converted to a Double.
    func slippageSelectedValue() -> Double {
        guard let slippageSelected = slippageSelected
        else {
            return slippageTolerance.doubleValue
        }
        
        return slippageSelected.rawValue
    }
}

struct WrapRouting: Identifiable {
    var id: UUID = UUID()
    
    var title: LocalizedStringKey?
    let routing: RoutedPoolsByPairQuery.Data.RoutedPoolsByPair.Routing
    var pools: [RoutedPoolsByPairQuery.Data.RoutedPoolsByPair.Pool] = []
    var poolsAsset: [RoutedPoolsByPairQuery.Data.RoutedPoolsByPair.Pool.PoolAsset] = []
    
    init(routing: RoutedPoolsByPairQuery.Data.RoutedPoolsByPair.Routing) {
        self.routing = routing
    }
    
    /// Calculates and updates the sequence of pool assets involved in the routing path based on the provided input and output tokens and the routing mode.
    /// - Parameters:
    ///   - tokenX: The input token for the swap route.
    ///   - tokenZ: The output token for the swap route.
    ///   - isAutoRoute: Indicates whether to use automatic routing logic. If false, only pools directly containing the input and output tokens are considered; if true, pools are chained stepwise to form a complete route.
    mutating func calculateRoute(tokenX: TokenProtocol?, tokenZ: TokenProtocol?, isAutoRoute: Bool) {
        var assets: [RoutedPoolsByPairQuery.Data.RoutedPoolsByPair.Pool.PoolAsset?] = []
        
        var poolsDoing = pools
        if !isAutoRoute {
            let poolX = poolsDoing.first { pool in
                pool.poolAssets.first { inside in
                    inside.uniqueID == tokenX?.uniqueID
                } != nil
            }
            
            assets.append(poolX?.poolAssets.first(where: { $0.uniqueID == tokenX?.uniqueID }))
            
            let poolZ = poolsDoing.first { pool in
                pool.poolAssets.first { inside in
                    inside.uniqueID == tokenZ?.uniqueID
                } != nil
            }
            
            assets.append(poolZ?.poolAssets.first(where: { $0.uniqueID == tokenZ?.uniqueID }))
        } else {
            for (idx, _) in pools.enumerated() {
                if idx == 0 {
                    let pool = poolsDoing.first { pool in
                        pool.poolAssets.first { inside in
                            inside.uniqueID == tokenX?.uniqueID
                        } != nil
                    }
                    
                    assets.append(pool?.poolAssets.first(where: { $0.uniqueID == tokenX?.uniqueID }))
                    assets.append(pool?.poolAssets.first(where: { $0.uniqueID != tokenX?.uniqueID }))
                    poolsDoing.removeAll {
                        $0.poolAssets.map { $0.uniqueID }.joined(separator: "_") == pool?.poolAssets.map({ $0.uniqueID }).joined(separator: "_")
                    }
                } else {
                    let previousPool = assets.last
                    let pool = poolsDoing.first { pool in
                        pool.poolAssets.first { inside in
                            inside.uniqueID == previousPool??.uniqueID
                        } != nil
                    }
                    assets.append(pool?.poolAssets.first(where: { $0.uniqueID != previousPool??.uniqueID }))
                    poolsDoing.removeAll {
                        $0.poolAssets.map { $0.uniqueID }.joined(separator: "_") == pool?.poolAssets.map({ $0.uniqueID }).joined(separator: "_")
                    }
                }
            }
        }
        self.poolsAsset = assets.compactMap({ $0 })
    }
}

extension WrapRouting {
    var uniqueID: String {
        routing.routing.map { $0.uniqueID }.joined(separator: "_") + pools.flatMap({ $0.poolAssets }).map({ $0.uniqueID }).joined(separator: "_")
    }
}
