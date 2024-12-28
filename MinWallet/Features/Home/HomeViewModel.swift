import Foundation
import Combine
import MinWalletAPI


@MainActor
class HomeViewModel: ObservableObject {

    @Published
    var tabType: TokenListView.TabType = .market

    @Published
    private var tokensDic: [TokenListView.TabType: [TopAssetQuery.Data.TopAssets.TopAsset]] = [:]
    @Published
    private var showSkeletonDic: [TokenListView.TabType: Bool] = [:]

    private var input: TopAssetsInput = .init()
    private var searchAfter :[String]? = nil
    private var hasLoadMoreDic: [TokenListView.TabType: Bool] = [:]
    private let limit: Int = 20
    
    private var cancellables: Set<AnyCancellable> = []

    init() {
        $tabType
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.getTokens()
            }
            .store(in: &cancellables)
    }
    
    func getTokens(isLoadMore: Bool = false) {
        showSkeletonDic[tabType] = !isLoadMore
        input = TopAssetsInput().with({
            $0.limit = .some(limit)
            $0.onlyVerified = .some(true)
            $0.sortBy = .some(TopAssetsSortInput(column: .case(.volume24H), type: .case(.desc)))
        })
        
        Task {
            let tokens = try? await MinWalletService.shared.fetch(query: TopAssetQuery(input: .some(input)))
            let _tokens = tokens?.topAssets.topAssets ?? []
            var currentTokens  = tokensDic[tabType] ?? []
            if isLoadMore {
                currentTokens += _tokens
            } else {
                currentTokens = _tokens
            }
            self.searchAfter = tokens?.topAssets.searchAfter
            self.hasLoadMoreDic[tabType] = _tokens.count >= self.limit
            showSkeletonDic[tabType] = false
        }
    }
    
    func loadMoreData(item: TopAssetQuery.Data.TopAssets.TopAsset) {
        guard (hasLoadMoreDic[tabType] ?? true) else { return }
        let tokens = tokensDic[tabType] ?? []
        let thresholdIndex = tokens.index(tokens.endIndex, offsetBy: -5)
        if tokens.firstIndex(where: { ($0.asset.currencySymbol + $0.asset.tokenName) == (item.asset.currencySymbol + $0.asset.tokenName) }) == thresholdIndex {
            getTokens(isLoadMore: true)
        }
    }
}

extension HomeViewModel {
    var showSkeleton: Bool {
        showSkeletonDic[tabType] ?? true
    }
    
    var tokens: [TopAssetQuery.Data.TopAssets.TopAsset] {
        tokensDic[tabType] ?? []
    }
}
