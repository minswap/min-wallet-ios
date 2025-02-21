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
    var tabTypes: [TokenListView.TabType] = []
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
        Self.generateTokenHash()

        $tabType
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] newValue in
                guard let self = self else { return }
                Task {
                    self.tabType = newValue
                    await self.getTokens()
                }
            }
            .store(in: &cancellables)

        Task {
            let tokens = try? await TokenManager.getYourToken()
            TokenManager.shared.yourTokens = tokens
            UserInfo.shared.adaHandleName = TokenManager.shared.fetchAdaHandleName()
            await getTokens()
            let _tokens: [TokenProtocol] = (tokens?.assets ?? []) + (tokens?.lpTokens ?? [])
            self.isHasYourToken = !_tokens.isEmpty
            self.tabTypes = (tokens?.nfts ?? []).isEmpty ? [.market, .yourToken] : [.market, .yourToken, .nft]

            try? await Task.sleep(for: .seconds(5 * 60))
            repeat {
                if tabType != .yourToken {
                    let tokens = try? await TokenManager.getYourToken()
                    TokenManager.shared.yourTokens = tokens
                    let _tokens: [TokenProtocol] = (tokens?.assets ?? []) + (tokens?.lpTokens ?? [])
                    self.isHasYourToken = !_tokens.isEmpty
                }
                await self.getTokens()
                try? await Task.sleep(for: .seconds(5 * 60))
            } while (!Task.isCancelled)
        }

        Task {
            try? await Task.sleep(for: .seconds(20))
            repeat {
                if tabType == .yourToken {
                    await TokenManager.shared.getPortfolioOverview()
                    let tokens = TokenManager.shared.yourTokens
                    let _tokens: [TokenProtocol] = (tokens?.assets ?? []) + (tokens?.lpTokens ?? [])
                    self.isHasYourToken = !_tokens.isEmpty
                    self.tokensDic[tabType] = [TokenManager.shared.tokenAda] + _tokens
                    self.hasLoadMoreDic[tabType] = false
                    self.showSkeletonDic[tabType] = false
                    self.isFetching[tabType] = false
                }
                try? await Task.sleep(for: .seconds(20))
            } while (!Task.isCancelled)
        }

        TokenManager.shared.reloadBalance
            .sink { [weak self] in
                guard let self = self else { return }
                Task {
                    if self.tabType == .yourToken {
                        await self.getTokens()
                    } else {
                        await TokenManager.shared.getPortfolioOverview()
                    }
                }
            }
            .store(in: &cancellables)
    }

    func getTokens(isLoadMore: Bool = false) async {
        if showSkeletonDic[tabType] == nil {
            showSkeletonDic[tabType] = !isLoadMore
        }
        self.isFetching[tabType] = true
        await TokenManager.shared.getPortfolioOverview()

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
            self.hasLoadMoreDic[tabType] = _tokens.count >= self.limit || self.searchAfter != nil
            self.showSkeletonDic[tabType] = false
            self.isFetching[tabType] = false

        case .yourToken:
            let tokens = try? await TokenManager.getYourToken()
            let _tokens: [TokenProtocol] = (tokens?.assets ?? []) + (tokens?.lpTokens ?? [])
            TokenManager.shared.yourTokens = tokens
            self.isHasYourToken = !_tokens.isEmpty
            self.tokensDic[tabType] = [TokenManager.shared.tokenAda] + _tokens
            self.hasLoadMoreDic[tabType] = false
            self.showSkeletonDic[tabType] = false
            self.isFetching[tabType] = false
        case .nft:
            let tokens = try? await TokenManager.getYourToken()
            let _tokens: [TokenProtocol] = (tokens?.assets ?? []) + (tokens?.lpTokens ?? [])
            TokenManager.shared.yourTokens = tokens
            self.isHasYourToken = !_tokens.isEmpty
            self.tokensDic[tabType] = tokens?.nfts ?? []
            self.hasLoadMoreDic[tabType] = false
            self.showSkeletonDic[tabType] = false
            self.isFetching[tabType] = false
        }
    }

    func loadMoreData(item: TokenProtocol) {
        guard (hasLoadMoreDic[tabType] ?? true), !(isFetching[tabType] ?? true) else { return }
        let tokens = tokensDic[tabType] ?? []
        let thresholdIndex = tokens.index(tokens.endIndex, offsetBy: -5)
        if tokens.firstIndex(where: { $0.uniqueID == item.uniqueID }) == thresholdIndex {
            Task {
                await getTokens(isLoadMore: true)
            }
        }
    }

    static func generateTokenHash() {
        guard AppSetting.shared.isLogin, AppSetting.shared.enableNotification else { return }
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
