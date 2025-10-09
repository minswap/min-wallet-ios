import SwiftUI
import Foundation
import Combine
import OneSignalFramework
import ObjectMapper
import Then


@MainActor
class MarketViewModel: ObservableObject {
    
    @Published
    var tokens: [TokenProtocol] = []
    @Published
    var showSkeleton: Bool? = nil
    
    private var input: TopAssetsInput = .init()
    private var searchAfter: [Any]? = nil
    private var hasLoadMore = false
    private var isFetching: Bool = false
    private let limit: Int = 20
    
    private var bag = Set<AnyCancellable>()
    
    init() {
        NotificationCenter.default.publisher(for: .favDidChange)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task {
                    await self.getTokens()
                }
            }
            .store(in: &bag)
    }
    
    private var isFirstTime: Bool = true
    
    func getTokens(isLoadMore: Bool = false) async {
        if showSkeleton == nil {
            showSkeleton = true
        }
        isFetching = true
        
        input = TopAssetsInput()
            .with({
                $0.limit = limit
                $0.only_verified = false
                $0.favorite_asset_ids = nil
                $0.sort_field = .volume_usd_24h
                $0.sort_direction = .desc
                if isLoadMore, let searchAfter = searchAfter {
                    $0.search_after = searchAfter
                }
            })
        
        let favTokenIds = UserInfo.shared.tokensFav.map { $0.uniqueID }
        
        if isFirstTime {
            async let tokenRaw = try? await MinWalletAPIRouter.topAssets(input: input).async_request()
            async let getPortfolioOverviewAndYourToken: Void? = try? await TokenManager.shared.getPortfolioOverviewAndYourToken()
            async let tokenFavRaw = Self.getTopAssetsFav()
            
            let results = await (tokenRaw, getPortfolioOverviewAndYourToken, tokenFavRaw)
            let tokens = (Mapper<TopAssetsResponse>().map(JSON: results.0?.dictionaryObject ?? [:])) ?? .init()
            
            let _tokens = results.2 + tokens.assets.filter({ !favTokenIds.contains($0.uniqueID) })
            self.tokens = _tokens
            searchAfter = tokens.search_after
            hasLoadMore = _tokens.count >= limit || searchAfter != nil
        } else {
            async let jsonDataRaw = try? await MinWalletAPIRouter.topAssets(input: input).async_request()
            async let tokenFavRaw = Self.getTopAssetsFav()
            
            let result = await (jsonDataRaw, tokenFavRaw)
            
            let tokenRaw = Mapper<TopAssetsResponse>().map(JSON: result.0?.dictionaryObject ?? [:]) ?? .init()
            
            let _tokens = result.1 + tokenRaw.assets.filter({ !favTokenIds.contains($0.uniqueID) })
            
            if isLoadMore {
                tokens += _tokens
            } else {
                tokens = _tokens
            }
            searchAfter = tokenRaw.search_after
            hasLoadMore = _tokens.count >= limit || searchAfter != nil
        }
        showSkeleton = false
        isFetching = false
        isFirstTime = false
    }
    
    func loadMoreData(item: TokenProtocol) {
        guard hasLoadMore, !isFetching else { return }
        let thresholdIndex = tokens.index(tokens.endIndex, offsetBy: -5)
        if tokens.firstIndex(where: { $0.uniqueID == item.uniqueID }) == thresholdIndex {
            Task {
                await getTokens(isLoadMore: true)
            }
        }
    }
}


extension MarketViewModel {
    static func getTopAssetsFav() async -> [TopAssetsResponse.AssetMetric] {
        let favAssetIds: [String] = UserInfo.shared.tokensFav.sorted(by: { $0.dateAdded > $1.dateAdded }).map { $0.currencySymbol + $0.tokenName }
        guard !favAssetIds.isEmpty else { return [] }
        
        let input = TopAssetsInput()
            .with({
                $0.limit = 100
                $0.only_verified = false
                $0.favorite_asset_ids = favAssetIds
            })
        
        let tokenRaw = try? await MinWalletAPIRouter.topAssets(input: input).async_request()
        let tokens = Mapper<TopAssetsResponse>.init().map(JSON: tokenRaw?.dictionaryObject ?? [:]) ?? .init()
        
        guard !tokens.assets.isEmpty else { return [] }
        
        let indexMap = Dictionary(uniqueKeysWithValues: favAssetIds.enumerated().map { ($1, $0) })
        let sortedAssets = tokens.assets.sorted {
            let lhs = indexMap[$0.currencySymbol + $0.tokenName] ?? Int.max
            let rhs = indexMap[$1.currencySymbol + $1.tokenName] ?? Int.max
            return lhs < rhs
        }
        return sortedAssets
    }
}
