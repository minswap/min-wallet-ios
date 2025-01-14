import SwiftUI
import Combine
import MinWalletAPI


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
    var isShowBannerTransaction: Bool = false
    
    var routingsData: RoutedPoolsByPairQuery.Data.RoutedPoolsByPair?
    var routings: [RoutedPoolsByPairQuery.Data.RoutedPoolsByPair.Routing] = []
    @Published
    var routingSelected: RoutedPoolsByPairQuery.Data.RoutedPoolsByPair.Routing? = nil
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published
    var swapSetting: SwapTokenSetting = .init()
    
    let action: PassthroughSubject<Action, Never> = .init()
    
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
                signSuccess?()
            }
        }
    }
    
    private func handleAction(_ action: Action) {
        switch action {
        case .initSwapToken:
            //TODO:
            break
        default:
            break
        }
    }
    
    func getRouting() async {
        let query = RoutedPoolsByPairQuery(isApplied: swapSetting.predictSwapPrice,
                                           pair: InputPair(assetA: InputAsset(currencySymbol: tokenPay?.currencySymbol ?? "", tokenName: tokenPay?.tokenName ?? ""),
                                                           assetB: InputAsset(currencySymbol: tokenReceive?.currencySymbol ?? "", tokenName: tokenReceive?.tokenName ?? "")))
        let routing = try? await MinWalletService.shared.fetch(query: query)
        self.routingsData = routing?.routedPoolsByPair
        self.routings = routing?.routedPoolsByPair.routings ?? []
    }
}


extension SwapTokenViewModel {
    enum Action {
        case initSwapToken
        case autoRouter
        case predictSwapPrice
        case routeSorting
    }
}
