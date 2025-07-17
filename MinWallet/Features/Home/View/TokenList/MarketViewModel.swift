import SwiftUI
import Foundation
import Combine
import MinWalletAPI
import OneSignalFramework


@MainActor
class MarketViewModel: ObservableObject {
    
    @Published
    var tokens: [TokenProtocol] = []
    @Published
    var showSkeleton: Bool? = nil
    
    private var input: TopAssetsInput = .init()
    private var searchAfter: [String]? = nil
    private var hasLoadMore = false
    private var isFetching: Bool = false
    private let limit: Int = 20
    
    init() {}
    
    private var isFirstTime: Bool = true
    
    func getTokens(isLoadMore: Bool = false) async {
        if showSkeleton == nil {
            showSkeleton = true
        }
        isFetching = true
        
        input = TopAssetsInput()
            .with({
                $0.limit = .some(limit)
                $0.onlyVerified = .some(false)
                $0.favoriteAssets = nil
                $0.sortBy = .some(TopAssetsSortInput(column: .case(.volume24H), type: .case(.desc)))
                if isLoadMore, let searchAfter = searchAfter {
                    $0.searchAfter = .some(searchAfter)
                }
            })
        
        if isFirstTime {
            async let tokenRaw = try? await MinWalletService.shared.fetch(query: TopAssetsQuery(input: .some(input)))
            async let getPortfolioOverviewAndYourToken: Void? = try? await TokenManager.shared.getPortfolioOverviewAndYourToken()
            
            let results = await (tokenRaw, getPortfolioOverviewAndYourToken)
            let tokens = results.0
            
            let _tokens = tokens?.topAssets.topAssets ?? []
            self.tokens = _tokens
            searchAfter = tokens?.topAssets.searchAfter
            hasLoadMore = _tokens.count >= limit || searchAfter != nil
        } else {
            let tokenRaw = try? await MinWalletService.shared.fetch(query: TopAssetsQuery(input: .some(input)))
            
            let _tokens = tokenRaw?.topAssets.topAssets ?? []
            if isLoadMore {
                tokens += _tokens
            } else {
                tokens = _tokens
            }
            searchAfter = tokenRaw?.topAssets.searchAfter
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
