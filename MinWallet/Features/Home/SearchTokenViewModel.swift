import SwiftUI
import MinWalletAPI
import Then
import Combine


@MainActor
class SearchTokenViewModel: ObservableObject {
    @Published
    var tokens: [TopAssetsQuery.Data.TopAssets.TopAsset] = []
    @Published
    var tokensFav: [TokenProtocol] = []
    @Published
    var isDeleted: [Bool] = []
    @Published
    var offsets: [CGFloat] = []
    @Published
    var keyword: String = ""
    @Published
    var recentSearch: [String] = []
    
    private var input: TopAssetsInput = .init()
    private var searchAfter: [String]? = nil
    private var hasLoadMore: Bool = true
    private let limit: Int = 20
    private var isFetching: Bool = true
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published
    var showSkeleton: Bool = true
    
    init() {
        $keyword
            .removeDuplicates()
            .dropFirst()
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] newData in
                guard let self = self else { return }
                self.keyword = newData
                self.getTokens()
            }
            .store(in: &cancellables)
        $keyword
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] newData in
                self?.showSkeleton = true
            }
            .store(in: &cancellables)
        
        recentSearch = UserDataManager.shared.tokenRecentSearch
    }
    
    /// Fetches tokens based on the current search keyword and pagination state.
    /// - Parameter isLoadMore: Indicates whether to load additional tokens for pagination. Defaults to `false`.
    ///
    /// If the search keyword is blank, retrieves favorite tokens and resets related UI state. Otherwise, fetches tokens matching the keyword from the backend, updating the token list and pagination information accordingly. Updates UI loading indicators and prevents concurrent fetches.
    func getTokens(isLoadMore: Bool = false) {
        showSkeleton = !isLoadMore
        isFetching = true
        input = TopAssetsInput()
            .with({
                if let searchAfter = searchAfter, isLoadMore {
                    $0.searchAfter = .some(searchAfter)
                } else {
                    $0.searchAfter = nil
                }
                if !keyword.isBlank {
                    $0.term = .some(keyword.trimmingCharacters(in: .whitespacesAndNewlines))
                    $0.limit = .some(limit)
                } else {
                    $0.term = nil
                    $0.limit = .some(10)
                }
                $0.sortBy = .some(TopAssetsSortInput(column: .case(.volume24H), type: .case(.desc)))
            })
        
        Task {
            if keyword.isBlank {
                self.tokensFav = await self.getTokenFav()
                self.isDeleted = self.tokensFav.map({ _ in false })
                self.offsets = self.tokensFav.map({ _ in 0 })
            } else {
                self.tokensFav = []
                self.isDeleted = []
                self.offsets = []
            }
            let tokens = try? await MinWalletService.shared.fetch(query: TopAssetsQuery(input: .some(input)))
            let _tokens = tokens?.topAssets.topAssets ?? []
            if isLoadMore {
                self.tokens += _tokens
            } else {
                self.tokens = _tokens
            }
            self.searchAfter = tokens?.topAssets.searchAfter
            self.hasLoadMore = _tokens.count >= self.limit || self.searchAfter != nil
            self.showSkeleton = false
            self.isFetching = false
        }
    }
    
    /// Loads additional tokens when the specified item is near the end of the current token list and more data is available.
    /// - Parameter item: The token item used to determine if more data should be loaded.
    func loadMoreData(item: TopAssetsQuery.Data.TopAssets.TopAsset) {
        guard hasLoadMore, !isFetching, !keyword.isBlank else { return }
        let thresholdIndex = tokens.index(tokens.endIndex, offsetBy: -2)
        if tokens.firstIndex(where: { ($0.asset.currencySymbol + $0.asset.tokenName) == (item.asset.currencySymbol + $0.asset.tokenName) }) == thresholdIndex {
            getTokens(isLoadMore: true)
        }
    }
    
    /// Clears the recent search history and updates persistent storage accordingly.
    func clearRecentSearch() {
        recentSearch = []
        UserDataManager.shared.tokenRecentSearch = []
    }
    
    /// Adds a keyword to the recent search list, ensuring it is trimmed, unique, and most recent.
    /// - Parameter keyword: The search term to add to the recent search history.
    func addRecentSearch(keyword: String) {
        var recentSearch = recentSearch
        recentSearch.insert(keyword.trimmingCharacters(in: .whitespacesAndNewlines), at: 0)
        recentSearch = Set(recentSearch.reversed()).map({ $0 })
        self.recentSearch = recentSearch.reversed()
        UserDataManager.shared.tokenRecentSearch = self.recentSearch
    }
    
    /// Removes a favorite token at the specified index and updates related UI state.
    /// - Parameter index: The index of the favorite token to remove. If the index is invalid, no action is taken.
    func deleteTokenFav(at index: Int) {
        guard let item = tokensFav[gk_safeIndex: index] else { return }
        let tokensFav = tokensFav.filter { $0.uniqueID != item.uniqueID }
        self.tokensFav = tokensFav
        self.isDeleted = self.tokensFav.map({ _ in false })
        self.offsets = self.tokensFav.map({ _ in 0 })
        UserInfo.shared.tokenFavSelected(token: item, isAdd: false)
    }
    
    /// Asynchronously fetches detailed data for all favorite tokens.
    /// - Returns: An array of successfully retrieved favorite tokens. Tokens that fail to fetch are omitted from the result.
    private func getTokenFav() async -> [TokenProtocol] {
        let tokens = await withTaskGroup(of: TokenProtocol?.self) { taskGroup in
            let tokens = UserInfo.shared.tokensFav
            var results: [TokenProtocol?] = []
            
            for item in tokens {
                taskGroup.addTask {
                    await self.fetchToken(for: item)
                }
            }
            
            for await result in taskGroup {
                results.append(result)
            }
            
            return results
        }
        return tokens.compactMap { $0 }
    }
    
    /// Asynchronously fetches detailed token data for a given favorite token.
    /// - Parameter token: The favorite token for which to retrieve detailed information.
    /// - Returns: The detailed token data if the fetch succeeds; otherwise, nil.
    private func fetchToken(for token: TokenFavourite) async -> TopAssetQuery.Data.TopAsset? {
        do {
            let asset = try await MinWalletService.shared.fetch(query: TopAssetQuery(asset: InputAsset(currencySymbol: token.currencySymbol, tokenName: token.tokenName)))
            return asset?.topAsset
        } catch {
            return nil
        }
    }
}
