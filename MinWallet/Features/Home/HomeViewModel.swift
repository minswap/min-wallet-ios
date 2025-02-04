import Foundation
import Combine
import MinWalletAPI
import OneSignalFramework


@MainActor
class HomeViewModel: ObservableObject {

    static var shared: HomeViewModel = .init()

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
        guard AppSetting.shared.isLogin else { return }
        generateTokenHash()

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
            let tokens = try? await TokenManager.getYourToken()
            TokenManager.shared.yourTokens = ((tokens?.0 ?? []), (tokens?.1 ?? []))
            self.isHasYourToken = !((tokens?.0 ?? []) + (tokens?.1 ?? [])).isEmpty
            getTokens()

            try? await Task.sleep(for: .seconds(5 * 60))
            repeat {
                if tabType != .yourToken {
                    let tokens = try? await TokenManager.getYourToken()
                    TokenManager.shared.yourTokens = ((tokens?.0 ?? []), (tokens?.1 ?? []))
                    self.isHasYourToken = !((tokens?.0 ?? []) + (tokens?.1 ?? [])).isEmpty
                }
                self.getTokens()
                try? await Task.sleep(for: .seconds(5 * 60))
            } while (!Task.isCancelled)
        }

        //MARK: Get balance
        Task {
            repeat {
                await TokenManager.shared.getPortfolioOverview()
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
                        $0.onlyVerified = .some(false)
                        $0.favoriteAssets = nil
                        $0.sortBy = .some(TopAssetsSortInput(column: .case(.volume24H), type: .case(.desc)))
                        if isLoadMore, let searchAfter = searchAfter {
                            $0.searchAfter = .some(searchAfter)
                        }
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
                let tokens = try? await TokenManager.getYourToken()
                let _tokens = (tokens?.0 ?? []) + (tokens?.1 ?? [])
                TokenManager.shared.yourTokens = ((tokens?.0 ?? []), (tokens?.1 ?? []))
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
        if tokens.firstIndex(where: { $0.uniqueID == item.uniqueID }) == thresholdIndex {
            getTokens(isLoadMore: true)
        }
    }

    private func generateTokenHash() {
        guard AppSetting.shared.isLogin else { return }
        guard let address = UserInfo.shared.minWallet?.address, !address.isBlank else { return }
        Task {
            let mutation = try? await MinWalletService.shared.mutation(mutation: NotificationGenerateAuthHashMutation(identifier: address))
            if let token = mutation?.notificationGenerateAuthHash, !token.isBlank {
                UserDataManager.shared.notificationGenerateAuthHash = token
                OneSignal.login(externalId: address, token: token)
            }
        }
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
