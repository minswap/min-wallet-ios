import SwiftUI
import MinWalletAPI
import Then
import Combine


@MainActor
class SearchTokenViewModel: ObservableObject {
    @Published
    var tokens: [TopAssetQuery.Data.TopAssets.TopAsset] = []
    @Published
    var isDeleted: [Bool] = []
    @Published
    var offsets: [CGFloat] = []
    @Published
    var keyword: String = ""
    @Published
    var recentSearch: [String] = []
    
    private var input: TopAssetsInput = .init()
    private var searchAfter :[String]? = nil
    private var hasLoadMore: Bool = true
    private let limit: Int = 20
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        $keyword
            .removeDuplicates()
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] newData in
                self?.getTokens()
            }
            .store(in: &cancellables)
        
        recentSearch = UserDataManager.shared.tokenRecentSearch
    }
    
    func getTokens(isLoadMore: Bool = false) {
        input = TopAssetsInput().with({
            $0.limit = .some(limit)
            if let searchAfter = searchAfter, isLoadMore {
                $0.searchAfter = .some(searchAfter)
            } else {
                $0.searchAfter = nil
            }
            if !keyword.isBlank {
                $0.term = .some(keyword)
            } else {
                $0.term = nil
            }
            
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
            self.isDeleted = self.tokens.map({ _ in false })
            self.offsets = self.tokens.map({ _ in 0 })
        }
    }
    
    func loadMoreData(item: TopAssetQuery.Data.TopAssets.TopAsset) {
        guard hasLoadMore else { return }
        let thresholdIndex = tokens.index(tokens.endIndex, offsetBy: -5)
        if tokens.firstIndex(where: { ($0.asset.currencySymbol + $0.asset.tokenName) == (item.asset.currencySymbol + $0.asset.tokenName) }) == thresholdIndex {
            getTokens(isLoadMore: true)
        }
    }
    
    func clearRecentSearch() {
        recentSearch = []
        UserDataManager.shared.tokenRecentSearch = []
    }
    
    func addRecentSearch() {
        var recentSearch = recentSearch
        recentSearch.insert(keyword.trimmingCharacters(in: .whitespacesAndNewlines), at: 0)
        recentSearch = Set(recentSearch).map({ $0 })
        
        UserDataManager.shared.tokenRecentSearch = recentSearch
    }
}
