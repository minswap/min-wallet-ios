import SwiftUI
import Combine
import MinWalletAPI

@MainActor
class SwapTokenViewModel: ObservableObject {

    @Published
    var tokenPay: TokenProtocol?
    @Published
    var tokenReceive: TokenProtocol?
    @Published
    var isShowInfo: Bool = false
    @Published
    var isShowRouting: Bool = false
    @Published
    var isShowSwapSetting: Bool = false

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
        action
            .sink { [weak self] action in
                self?.handleAction(action)
            }
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
                tokenPay = TokenDefault(symbol: "", tName: "")
                tokenReceive = TokenDefault(symbol: String(MinWalletConstant.minToken.split(separator: ".").first ?? ""), tName: String(MinWalletConstant.minToken.split(separator: ".").last ?? ""))
                await getRouting()
                routingSelected = wrapRoutings.first
            }

        case let .selectTokenPay(token):
            Task {
                tokenPay = token
                routingSelected = nil
                await getRouting()
                routingSelected = wrapRoutings.first
            }

        case let .selectTokenReceive(token):
            Task {
                tokenReceive = token
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
        }
    }

    private func getRouting() async {
        isLoadingRouting = true
        let query = RoutedPoolsByPairQuery(
            isApplied: swapSetting.predictSwapPrice,
            pair: InputPair(
                assetA: InputAsset(currencySymbol: tokenPay?.currencySymbol ?? "", tokenName: tokenPay?.tokenName ?? ""),
                assetB: InputAsset(currencySymbol: tokenReceive?.currencySymbol ?? "", tokenName: tokenReceive?.tokenName ?? "")))

        let routing = try? await MinWalletService.shared.fetch(query: query)
        let pools = routing?.routedPoolsByPair.pools ?? []

        var wrapRoutings = routing?.routedPoolsByPair.routings.map({ WrapRouting(routing: $0) }) ?? []

        for (idx, routing) in wrapRoutings.enumerated() {
            let uniqueIDLPAsset = routing.routing.routing.map { $0.currencySymbol + "." + $0.tokenName }
            let poolsInRouting = pools.filter { uniqueIDLPAsset.contains($0.lpAsset.currencySymbol + "." + $0.lpAsset.tokenName) }
            wrapRoutings[idx].pools = poolsInRouting
            wrapRoutings[idx].calculateRoute(tokenX: self.tokenPay, tokenZ: self.tokenReceive, isAutoRoute: swapSetting.autoRouter)
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
        isLoadingRouting = true
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
    }
}
