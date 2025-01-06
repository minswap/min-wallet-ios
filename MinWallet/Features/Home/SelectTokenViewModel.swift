import SwiftUI
import MinWalletAPI
import Then
import Combine


@MainActor
class SelectTokenViewModel: ObservableObject {
    @Published
    var tokens: [AssetsQuery.Data.Assets.Asset] = []
    @Published
    var keyword: String = ""

    private var input: AssetsInput = .init()
    private var searchAfter: [String]? = nil
    private var hasLoadMore: Bool = true
    private var isFetching: Bool = true
    private var ignoreToken: TokenProtocol?

    private var cancellables: Set<AnyCancellable> = []
    var showSkeleton: Bool = true

    init(ignoreToken: TokenProtocol?) {
        self.ignoreToken = ignoreToken
        $keyword
            .removeDuplicates()
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] newData in
                guard let self = self else { return }
                self.keyword = newData
                self.getTokens()
            }
            .store(in: &cancellables)
    }

    func getTokens(isLoadMore: Bool = false) {
        showSkeleton = !isLoadMore
        isFetching = true
        input = AssetsInput()
            .with({
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
            })

        Task {
            let tokens = try? await MinWalletService.shared.fetch(query: AssetsQuery(input: .some(self.input)))
            let _tokens = (tokens?.assets.assets ?? []).filter { ($0.currencySymbol + "." + $0.tokenName) != ((self.ignoreToken?.currencySymbol ?? "") + "." + (self.ignoreToken?.tokenName ?? "")) }
            if isLoadMore {
                self.tokens += _tokens
            } else {
                self.tokens = _tokens
            }
            self.searchAfter = tokens?.assets.searchAfter
            self.hasLoadMore = !_tokens.isEmpty
            self.showSkeleton = false
            self.isFetching = false
        }
    }

    func loadMoreData(item: AssetsQuery.Data.Assets.Asset) {
        guard hasLoadMore, !isFetching else { return }
        let thresholdIndex = tokens.index(tokens.endIndex, offsetBy: -5)
        if tokens.firstIndex(where: { ($0.currencySymbol + $0.tokenName) == (item.currencySymbol + $0.tokenName) }) == thresholdIndex {
            getTokens(isLoadMore: true)
        }
    }
}
