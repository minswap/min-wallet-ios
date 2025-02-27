import Foundation
import Combine
import MinWalletAPI
import OneSignalFramework


@MainActor
class HomeViewModel: ObservableObject {

    @Published
    var tabType: TokenListView.TabType = .market
    @Published
    private var tokensDic: [TokenListView.TabType: [TokenProtocol]] = [:]
    @Published
    private var showSkeletonDic: [TokenListView.TabType: Bool] = [:]
    @Published
    var tabTypes: [TokenListView.TabType] = []

    private var input: TopAssetsInput = .init()
    private var searchAfter: [String]? = nil
    private var hasLoadMoreDic: [TokenListView.TabType: Bool] = [:]
    private var isFetching: [TokenListView.TabType: Bool] = [:]
    private let limit: Int = 20

    private var cancellables: Set<AnyCancellable> = []
    private var timerReloadBalance: AnyCancellable?
    private var timerReloadMarket: AnyCancellable?

    deinit {
        timerReloadBalance?.cancel()
        timerReloadMarket?.cancel()
    }

    init() {
        guard AppSetting.shared.isLogin else { return }

        $tabType
            .removeDuplicates()
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self = self else { return }
                Task {
                    self.tabType = newValue
                    await self.getTokens()
                    self.tabTypes = (TokenManager.shared.yourTokens?.nfts ?? []).isEmpty ? [.market, .yourToken] : [.market, .yourToken, .nft]
                }
            }
            .store(in: &cancellables)
    }

    private func createTimerReloadBalance() {
        timerReloadBalance?.cancel()
        timerReloadBalance = Timer.publish(every: TokenManager.TIME_RELOAD_BALANCE, on: .main, in: .common)
            .autoconnect()
            .throttle(for: .seconds(TokenManager.TIME_RELOAD_BALANCE), scheduler: RunLoop.main, latest: true)
            .removeDuplicates()
            .sink { [weak self] time in
                guard let self = self, !TokenManager.shared.isLoadingPortfolioOverviewAndYourToken else { return }
                guard AppSetting.shared.isLogin
                else {
                    self.timerReloadBalance?.cancel()
                    return
                }
                Task {
                    switch self.tabType {
                    case .market:
                        try? await TokenManager.shared.getPortfolioOverviewAndYourToken()
                    case .yourToken, .nft:
                        await self.getTokens()
                    }
                }
            }

        timerReloadMarket?.cancel()
        timerReloadMarket = Timer.publish(every: TokenManager.TIME_RELOAD_MARKET, on: .main, in: .common)
            .autoconnect()
            .throttle(for: .seconds(TokenManager.TIME_RELOAD_MARKET), scheduler: RunLoop.main, latest: true)
            .removeDuplicates()
            .sink { [weak self] time in
                guard let self = self else { return }
                guard AppSetting.shared.isLogin
                else {
                    self.timerReloadMarket?.cancel()
                    return
                }
                Task {
                    switch self.tabType {
                    case .market:
                        await self.getTokens()
                    case .yourToken,
                        .nft:
                        break
                    }
                }
            }
    }

    private func getTokens(isLoadMore: Bool = false) async {
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

            async let tokenRaw = try? await MinWalletService.shared.fetch(query: TopAssetsQuery(input: .some(input)))
            async let getPortfolioOverviewAndYourToken: Void? = try? await TokenManager.shared.getPortfolioOverviewAndYourToken()

            let results = await (tokenRaw, getPortfolioOverviewAndYourToken)
            let tokens = results.0

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
            try? await TokenManager.shared.getPortfolioOverviewAndYourToken()
            self.tokensDic[tabType] = [TokenManager.shared.tokenAda] + TokenManager.shared.normalTokens
            self.hasLoadMoreDic[tabType] = false
            self.showSkeletonDic[tabType] = false
            self.isFetching[tabType] = false
        case .nft:
            try? await TokenManager.shared.getPortfolioOverviewAndYourToken()
            self.tokensDic[tabType] = TokenManager.shared.yourTokens?.nfts ?? []
            self.hasLoadMoreDic[tabType] = false
            self.showSkeletonDic[tabType] = false
            self.isFetching[tabType] = false
        }

        createTimerReloadBalance()
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
            async let notificationGenerateAuthHashAsync = MinWalletService.shared.mutation(mutation: NotificationGenerateAuthHashMutation(identifier: address))?.notificationGenerateAuthHash
            async let skateAddressAsync = MinWalletService.shared.fetch(query: GetSkateAddressQuery(address: address))?.getStakeAddress

            let value = try? await (notificationGenerateAuthHashAsync, skateAddressAsync)

            if let token = value?.0, !token.isBlank, let skateAddress = value?.1, !skateAddress.isBlank, AppSetting.shared.enableNotification {
                UserDataManager.shared.notificationGenerateAuthHash = token
                OneSignal.login(externalId: skateAddress, token: token)
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
