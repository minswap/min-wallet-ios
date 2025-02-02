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
                    $0.term = .some(keyword)
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
            self.hasLoadMore = _tokens.count >= self.limit
            self.showSkeleton = false
            self.isFetching = false
        }
    }

    func loadMoreData(item: TopAssetsQuery.Data.TopAssets.TopAsset) {
        guard hasLoadMore, !isFetching, !keyword.isBlank else { return }
        let thresholdIndex = tokens.index(tokens.endIndex, offsetBy: -2)
        if tokens.firstIndex(where: { ($0.asset.currencySymbol + $0.asset.tokenName) == (item.asset.currencySymbol + $0.asset.tokenName) }) == thresholdIndex {
            getTokens(isLoadMore: true)
        }
    }

    func clearRecentSearch() {
        recentSearch = []
        UserDataManager.shared.tokenRecentSearch = []
    }

    func addRecentSearch(keyword: String) {
        var recentSearch = recentSearch
        recentSearch.insert(keyword.trimmingCharacters(in: .whitespacesAndNewlines), at: 0)
        recentSearch = Set(recentSearch.reversed()).map({ $0 })
        self.recentSearch = recentSearch.reversed()
        UserDataManager.shared.tokenRecentSearch = self.recentSearch
    }

    func deleteTokenFav(at index: Int) {
        guard let item = tokensFav[gk_safeIndex: index] else { return }
        offsets.remove(at: index)
        isDeleted.remove(at: index)
        tokensFav.remove(at: index)

        UserInfo.shared.tokenFavSelected(token: item, isAdd: false)
    }

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

    private func fetchToken(for token: TokenFavourite) async -> TopAssetQuery.Data.TopAsset? {
        do {
            let asset = try await MinWalletService.shared.fetch(query: TopAssetQuery(asset: InputAsset(currencySymbol: token.currencySymbol, tokenName: token.tokenName)))
            return asset?.topAsset
        } catch {
            return nil
        }
    }
}
