import Foundation
import Combine
import MinWalletAPI


@MainActor
class HomeViewModel: ObservableObject {

    @Published
    var tabType: TokenListView.TabType = .market
    @Published
    private var tokensDic: [TokenListView.TabType: [TokenProtocol]] = [:]
    @Published
    private var showSkeletonDic: [TokenListView.TabType: Bool] = [:]
    @Published
    var isHasYourToken: Bool = false
    
    private var input: TopAssetsInput = .init()
    private var searchAfter: [String]? = nil
    private var hasLoadMoreDic: [TokenListView.TabType: Bool] = [:]
    private var isFetching: [TokenListView.TabType: Bool] = [:]
    private let limit: Int = 20

    private var cancellables: Set<AnyCancellable> = []

    init() {
        $tabType
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] newValue in
                guard let self = self else { return }
                self.tabType = newValue
                self.getTokens()
            }
            .store(in: &cancellables)

        Task {
            let tokens = try? await getYourToken()
            self.isHasYourToken = !((tokens?.0 ?? []) + (tokens?.1 ?? [])).isEmpty
            getTokens()
            
            try? await Task.sleep(for: .seconds(5 * 60))
            repeat {
                if tabType != .yourToken {
                    let tokens = try? await getYourToken()
                    self.isHasYourToken = !((tokens?.0 ?? []) + (tokens?.1 ?? [])).isEmpty
                }
                
                self.getTokens()
                try? await Task.sleep(for: .seconds(5 * 60))
            } while (!Task.isCancelled)
        }
    }

    func getTokens(isLoadMore: Bool = false) {
        Task {
            if showSkeletonDic[tabType] == nil {
                showSkeletonDic[tabType] = !isLoadMore
            }
            self.isFetching[tabType] = true

            switch tabType {
            case .market:
                input = TopAssetsInput()
                    .with({
                        $0.limit = .some(limit)
                        //$0.onlyVerified = .some(false)
                        $0.sortBy = .some(TopAssetsSortInput(column: .case(.volume24H), type: .case(.desc)))
                    })

                let tokens = try? await MinWalletService.shared.fetch(query: TopAssetsQuery(input: .some(input)))
                let _tokens = tokens?.topAssets.topAssets ?? []
                var currentTokens = tokensDic[tabType] ?? []
                if isLoadMore {
                    currentTokens += _tokens
                } else {
                    currentTokens = _tokens
                }
                self.tokensDic[tabType] = currentTokens
                self.searchAfter = tokens?.topAssets.searchAfter
                self.hasLoadMoreDic[tabType] = _tokens.count >= self.limit
                self.showSkeletonDic[tabType] = false
                self.isFetching[tabType] = false

            case .yourToken:
                let tokens = try? await self.getYourToken()
                let _tokens = (tokens?.0 ?? []) + (tokens?.1 ?? [])
                self.isHasYourToken = !_tokens.isEmpty
                self.tokensDic[tabType] = _tokens
                self.hasLoadMoreDic[tabType] = false
                self.showSkeletonDic[tabType] = false
                self.isFetching[tabType] = false
            }
        }
    }
    
    func loadMoreData(item: TokenProtocol) {
        guard (hasLoadMoreDic[tabType] ?? true), !(isFetching[tabType] ?? true) else { return }
        let tokens = tokensDic[tabType] ?? []
        let thresholdIndex = tokens.index(tokens.endIndex, offsetBy: -5)
        if tokens.firstIndex(where: { ($0.currencySymbol + $0.tokenName) == (item.currencySymbol + $0.tokenName) }) == thresholdIndex {
            getTokens(isLoadMore: true)
        }
    }
    
    func getYourToken() async throws -> ([TokenProtocol], [TokenProtocol]) {
        let tokens = try await MinWalletService.shared.fetch(query: WalletAssetsQuery(address: UserInfo.shared.minWallet?.address ?? ""))
        let normalToken = tokens?.getWalletAssetsPositions.assets ?? []
        let lpToken = tokens?.getWalletAssetsPositions.lpTokens ?? []
        return (normalToken, lpToken)
    }
}

extension HomeViewModel {
    var showSkeleton: Bool {
        showSkeletonDic[tabType] ?? true
    }

    var tokens: [TokenProtocol] {
        tokensDic[tabType] ?? []
    }
}
