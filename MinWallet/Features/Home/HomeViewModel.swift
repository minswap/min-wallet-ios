import Foundation
import MinWalletAPI


@MainActor
class HomeViewModel: ObservableObject {

    @Published
    var tabType: TokenListView.TabType = .market

    @Published
    var tokens: [TopAssetQuery.Data.TopAssets.TopAsset] = []

    @Published
    var showSkeleton: Bool = true

    private var input: TopAssetsInput = .init()
    private var searchAfter :[String]? = nil
    private var hasLoadMore: Bool = true
    private let limit: Int = 20
    
    init() {}
    
    func getTokens(isLoadMore: Bool = false) {
        showSkeleton = true
        input = TopAssetsInput().with({
            $0.limit = .some(limit)
            if let searchAfter = searchAfter, isLoadMore {
                $0.searchAfter = .some(searchAfter)
            } else {
                $0.searchAfter = nil
            }
            $0.onlyVerified = .some(true)
            $0.sortBy = .some(TopAssetsSortInput(column: .case(.volume24H), type: .case(.desc)))
        })
        
        Task {
            let tokens = try? await MinWalletService.shared.fetch(query: TopAssetQuery(input: .some(input)))
            let _tokens = tokens?.topAssets.topAssets ?? []
            if isLoadMore {
                self.tokens += _tokens
            } else {
                self.tokens = _tokens
            }
            self.searchAfter = tokens?.topAssets.searchAfter
            self.hasLoadMore = _tokens.count >= self.limit
            showSkeleton = false
        }
    }
    
    func loadMoreData(item: TopAssetQuery.Data.TopAssets.TopAsset) {
        guard hasLoadMore else { return }
        let thresholdIndex = tokens.index(tokens.endIndex, offsetBy: -5)
        if tokens.firstIndex(where: { ($0.asset.currencySymbol + $0.asset.tokenName) == (item.asset.currencySymbol + $0.asset.tokenName) }) == thresholdIndex {
            getTokens(isLoadMore: true)
        }
    }
}
