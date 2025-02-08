import SwiftUI
import Combine
import MinWalletAPI

@MainActor
class SwapTokenViewModel: ObservableObject {

    @Published
    var tokenPay: WrapTokenSend
    @Published
    var tokenReceive: WrapTokenSend
    @Published
    var isShowInfo: Bool = false
    @Published
    var isShowRouting: Bool = false
    @Published
    var isShowSwapSetting: Bool = false
    @Published
    var isShowSelectReceiveToken: Bool = false
    @Published
    var isShowSelectPayToken: Bool = false

    @Published
    var wrapRoutings: [WrapRouting] = []
    @Published
    var routingSelected: WrapRouting? = nil

    private var cancellables: Set<AnyCancellable> = []

    @Published
    var swapSetting: SwapTokenSetting = .init()

    let action: PassthroughSubject<Action, Never> = .init()

    @Published
    var isLoadingRouting: Bool = true

    init() {
        tokenPay = WrapTokenSend(token: TokenManager.shared.tokenAda)
        tokenReceive = WrapTokenSend(token: TokenDefault(symbol: String(MinWalletConstant.minToken.split(separator: ".").first ?? ""), tName: String(MinWalletConstant.minToken.split(separator: ".").last ?? "")))

        action
            .sink { [weak self] action in
                self?.handleAction(action)
            }
            .store(in: &cancellables)

        $tokenPay
            .map({ Double($0.amount) ?? 0 })
            .removeDuplicates()
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] amount in
                self?.action.send(.amountPayChanged(amount: amount))
            })
            .store(in: &cancellables)

        action.send(.initSwapToken)
    }

    func swapToken(appSetting: AppSetting, signContract: (() -> Void)?, signSuccess: (() -> Void)?) {
        Task {
            switch appSetting.authenticationType {
            case .biometric:
                try await appSetting.reAuthenticateUser()
                signSuccess?()
            case .password:
                signContract?()
            }
        }
    }

    private func handleAction(_ action: Action) {
        switch action {
        case .initSwapToken:
            Task {
                await getRouting()
                routingSelected = wrapRoutings.first
            }

        case let .selectTokenPay(token):
            Task {
                guard let token = token, token.uniqueID != tokenReceive.uniqueID, token.uniqueID != tokenPay.uniqueID else { return }
                tokenPay = WrapTokenSend(token: token)
                routingSelected = nil
                await getRouting()
                routingSelected = wrapRoutings.first
            }
        case let .selectTokenReceive(token):
            Task {
                guard let token = token, token.uniqueID != tokenPay.uniqueID, token.uniqueID != tokenReceive.uniqueID else { return }
                tokenReceive = WrapTokenSend(token: token)
                routingSelected = nil
                await getRouting()
                routingSelected = wrapRoutings.first
            }
        case .routeSorting,
            .predictSwapPrice,
            .autoRouter:
            Task {
                await getRouting()
                routingSelected = wrapRoutings.first(where: { $0.uniqueID == routingSelected?.uniqueID })
            }

        case .routeSelected:
            //TODO: calculate fee
            break
        case .swapToken:
            let tempToken = tokenPay
            tokenPay = tokenReceive
            tokenReceive = tempToken
            //TODO: calculate route
            self.action.send(.routeSorting)

        case .setMaxAmount:
            tokenPay.amount = tokenPay.token.amount.formatSNumber(usesGroupingSeparator: false, maximumFractionDigits: 15)
        case .setHalfAmount:
            tokenPay.amount = (tokenPay.token.amount / 2).formatSNumber(usesGroupingSeparator: false, maximumFractionDigits: 15)
        case let .amountPayChanged(amount):
            print("\(amount)")
            //TODO: calculate fee
            break
        }
    }

    private func getRouting() async {
        isLoadingRouting = true
        let query = RoutedPoolsByPairQuery(
            isApplied: swapSetting.predictSwapPrice,
            pair: InputPair(
                assetA: InputAsset(currencySymbol: tokenPay.token.currencySymbol, tokenName: tokenPay.token.tokenName),
                assetB: InputAsset(currencySymbol: tokenReceive.token.currencySymbol, tokenName: tokenReceive.token.tokenName)))

        let routing = try? await MinWalletService.shared.fetch(query: query)
        let pools = routing?.routedPoolsByPair.pools ?? []

        var wrapRoutings = routing?.routedPoolsByPair.routings.map({ WrapRouting(routing: $0) }) ?? []

        for (idx, routing) in wrapRoutings.enumerated() {
            let uniqueIDLPAsset = routing.routing.routing.map { $0.currencySymbol + "." + $0.tokenName }
            let poolsInRouting = pools.filter { uniqueIDLPAsset.contains($0.lpAsset.currencySymbol + "." + $0.lpAsset.tokenName) }
            wrapRoutings[idx].pools = poolsInRouting
            wrapRoutings[idx].calculateRoute(tokenX: self.tokenPay.token, tokenZ: self.tokenReceive.token, isAutoRoute: swapSetting.autoRouter)
        }

        switch swapSetting.routeSorting {
        case .most:
            wrapRoutings.sort { routingL, routingR in
                let minTVLL = routingL.pools.compactMap { Double($0.tvlInAda ?? "") }.min() ?? 0
                let minTVLR = routingR.pools.compactMap { Double($0.tvlInAda ?? "") }.min() ?? 0
                return minTVLL > minTVLR
            }
        case .high:
            //TODO: calculate sau
            break
        }

        for (idx, _) in wrapRoutings.enumerated() {
            let title: LocalizedStringKey = {
                if idx == 0 {
                    return swapSetting.routeSorting == .high ? "Best route" : "Most liquidity"
                } else {
                    return "Route \(idx + 1)"
                }
            }()

            wrapRoutings[idx].title = title
        }

        self.wrapRoutings = wrapRoutings
        isLoadingRouting = false
    }
}


extension SwapTokenViewModel {
    enum Action {
        case initSwapToken
        case autoRouter
        case predictSwapPrice
        case routeSorting
        case selectTokenPay(token: TokenProtocol?)
        case selectTokenReceive(token: TokenProtocol?)
        case routeSelected
        case setMaxAmount
        case setHalfAmount
        case amountPayChanged(amount: Double)
        case swapToken
    }
}
