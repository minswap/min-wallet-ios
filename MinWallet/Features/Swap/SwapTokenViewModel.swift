import SwiftUI
import Combine
import MinWalletAPI
import Then


@MainActor
class SwapTokenViewModel: ObservableObject {

    @Published
    var tokenPay: WrapTokenSend
    @Published
    var tokenReceive: WrapTokenSend
    @Published
    var isShowInfo: Bool = false
    /*
    @Published
    var isShowRouting: Bool = false
     */
    @Published
    var isShowSwapSetting: Bool = false
    @Published
    var isShowSelectReceiveToken: Bool = false
    @Published
    var isShowSelectPayToken: Bool = false
    /*
    @Published
    var wrapRoutings: [WrapRouting] = []
    @Published
    var routingSelected: WrapRouting? = nil
     */
    @Published
    var warningInfo: [WarningInfo] = []
    @Published
    var isExpand: [WarningInfo: Bool] = [:]
    @Published
    var isConvertRate: Bool = false
    @Published
    var swapSetting: SwapTokenSetting = .init()
    @Published
    var isSwapExactIn: Bool = true
    @Published
    var iosTradeEstimate: IosTradeEstimateQuery.Data.IosTradeEstimate?
    
    let action: PassthroughSubject<Action, Never> = .init()
    /*
    @Published
    var isLoadingRouting: Bool = true
*/
    @Published
    var isGettingTradeInfo: Bool = false
    @Published
    var errorInfo: ErrorInfo? = nil
    
    private var cancellables: Set<AnyCancellable> = []

    var hudState: HUDState = .init()
    
    init() {
        tokenPay = WrapTokenSend(token: TokenManager.shared.tokenAda)
        tokenReceive = WrapTokenSend(token: TokenDefault(symbol: String(MinWalletConstant.minToken.split(separator: ".").first ?? ""), tName: String(MinWalletConstant.minToken.split(separator: ".").last ?? "")))
    
        action
            .sink { [weak self] action in
                guard let self = self else { return }
                Task {
                    do {
                        try await self.handleAction(action)
                    } catch {
                        self.iosTradeEstimate = nil
                        self.hudState.showMsg(title: "Error", msg: error.localizedDescription)
                    }
                }
            }
            .store(in: &cancellables)
        $tokenPay
            .map({ Double($0.amount) ?? 0 })
            .removeDuplicates()
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] amount in
                guard let self = self, isSwapExactIn else { return }
                self.action.send(.amountPayChanged(amount: amount))
            })
            .store(in: &cancellables)
        $tokenReceive
            .map({ Double($0.amount) ?? 0 })
            .removeDuplicates()
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] amount in
                guard let self = self, !isSwapExactIn else { return }
                self.action.send(.amountReceiveChanged(amount: amount))
            })
            .store(in: &cancellables)
        
        action.send(.getTradingInfo)
    }

    private func handleAction(_ action: Action) async throws {
        switch action {
        case let .selectTokenPay(token):
            guard let token = token, token.uniqueID != tokenReceive.uniqueID, token.uniqueID != tokenPay.uniqueID else { return }
            tokenPay = WrapTokenSend(token: token)
            self.action.send(.getTradingInfo)
            
        case let .selectTokenReceive(token):
            guard let token = token, token.uniqueID != tokenPay.uniqueID, token.uniqueID != tokenReceive.uniqueID else { return }
            tokenReceive = WrapTokenSend(token: token)
            self.action.send(.getTradingInfo)

        case .predictSwapPrice:
            self.action.send(.getTradingInfo)
            
        case .swapToken:
            let tempToken = tokenPay
            tokenPay = tokenReceive
            tokenPay.amount = ""
            tokenReceive = tempToken
            tokenReceive.amount = ""
            self.action.send(.getTradingInfo)
        
        case .setMaxAmount:
            tokenPay.amount = tokenPay.token.amount.formatSNumber(usesGroupingSeparator: false, maximumFractionDigits: 15)
            self.action.send(.getTradingInfo)
            
        case .setHalfAmount:
            tokenPay.amount = (tokenPay.token.amount / 2).formatSNumber(usesGroupingSeparator: false, maximumFractionDigits: 15)
            self.action.send(.getTradingInfo)
            
        case let .amountPayChanged(amount),
            let .amountReceiveChanged(amount):
            try await getTradingInfo(amount: amount)
            await generateWarningInfo()
            await generateErrorInfo()
            
        case .getTradingInfo:
            let amount = isSwapExactIn ? tokenPay.amount : tokenReceive.amount
            try await getTradingInfo(amount: Double(amount) ?? 0)
            await generateWarningInfo()
            await generateErrorInfo()
        case .routeSorting,
                .autoRouter,
                .routeSelected:
            break
        }
    }
    
    /*
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
     */
    
    private func generateWarningInfo() async {
        //TODO: Warning info
        var warningInfo: [WarningInfo] = []

        if await AppSetting.shared.isSuspiciousToken(currencySymbol: tokenPay.token.currencySymbol) {
            warningInfo.append(.suspiciousTokenPay(policyId: tokenPay.token.currencySymbol))
        }
        if await AppSetting.shared.isSuspiciousToken(currencySymbol: tokenReceive.token.currencySymbol) {
            warningInfo.append(.suspiciousTokenReceive(policyId: tokenReceive.token.currencySymbol))
        }
        if tokenPay.token.decimals == 0 {
            warningInfo.append(.indivisibleTokenPay)
        }
        if tokenReceive.token.decimals == 0 {
            warningInfo.append(.indivisibleTokenReceive)
        }
        self.isExpand = [:]
        self.warningInfo = warningInfo
    }
    
    private func generateErrorInfo() async {
        let payAmount = Double(tokenPay.amount) ?? 0
        let receiveAmount = Double(tokenReceive.amount) ?? 0
        errorInfo = nil
        if isSwapExactIn {
            if payAmount > tokenPay.token.amount {
                errorInfo = .insufficientBalance(name: tokenPay.token.adaName)
            }
        } else {
            if receiveAmount > tokenReceive.token.amount {
                errorInfo = .notEnoughAmountInPool(name: tokenReceive.token.adaName)
            }
        }
    }
    
    private func getTradingInfo(amount: Double) async throws {
        isGettingTradeInfo = true
        let amount = amount * pow(10, Double(isSwapExactIn ? tokenPay.token.decimals : tokenReceive.token.decimals))
        let input = IosTradeEstimateInput(amount: String(Int(amount)),
                                          inputAsset: InputAsset(currencySymbol: tokenPay.token.currencySymbol, tokenName: tokenPay.token.tokenName),
                                          isApplied: swapSetting.predictSwapPrice,
                                          isSwapExactIn: isSwapExactIn,
                                          outputAsset: InputAsset(currencySymbol: tokenReceive.token.currencySymbol, tokenName: tokenReceive.token.tokenName))
        
        let info = try await MinWalletService.shared.fetch(query: IosTradeEstimateQuery(input: input))?.iosTradeEstimate
        self.iosTradeEstimate = info
        
        if isSwapExactIn {
            let outputAmount = info?.estimateAmount?.toExact(decimal: Double(tokenReceive.token.decimals)) ?? 0
            tokenReceive.amount = outputAmount == 0 ? "" : outputAmount.formatSNumber(usesGroupingSeparator: false, maximumFractionDigits: tokenReceive.token.decimals)
        } else {
            let outputAmount = info?.estimateAmount?.toExact(decimal: Double(tokenPay.token.decimals)) ?? 0
            tokenPay.amount = outputAmount == 0 ? "" : outputAmount.formatSNumber(usesGroupingSeparator: false, maximumFractionDigits: tokenPay.token.decimals)
        }
        
        isGettingTradeInfo = false
    }
    
    func finalizeAndSubmit(tx: String) async throws -> String? {
        guard let wallet = UserInfo.shared.minWallet else { throw AppGeneralError.localError(message: "Wallet not found") }
        guard let witnessSet = signTx(wallet: wallet, password: AppSetting.shared.password, accountIndex: wallet.accountIndex, txRaw: tx)
        else { throw AppGeneralError.localError(message: "Sign transaction failed") }
        
        let data = try await MinWalletService.shared.mutation(mutation: FinalizeAndSubmitMutation(input: InputFinalizeAndSubmit(tx: tx, witnessSet: witnessSet)))
        return data?.finalizeAndSubmit
    }
    
    func swapToken() async throws -> String {
        return ""
    }
}


extension SwapTokenViewModel {
    enum Action {
        case autoRouter
        case predictSwapPrice
        case routeSorting
        case selectTokenPay(token: TokenProtocol?)
        case selectTokenReceive(token: TokenProtocol?)
        case routeSelected
        case setMaxAmount
        case setHalfAmount
        case amountPayChanged(amount: Double)
        case amountReceiveChanged(amount: Double)
        case swapToken
        case getTradingInfo
    }
}


extension SwapTokenViewModel {
    enum WarningInfo: Hashable {
        ///priceImpact >= IMPACT_TIERS[0] and settings.safeMode and hasExchange
        case highPriceImpact(percent: String)
        ///useUnlimitedSlippage == true
        case unlimitedSlippageIsActivated
        ///slippage >= UNSAFE_SLIPPAGE_TOLERANCE and safeMode
        case unsafeSlippageTolerance(percent: String)
        ///Token exists in FUNCTIONAL_ASSETS
        case functionalTokenPay(ticker: String, project: String)
        case functionalTokenReceive(ticker: String, project: String)
        ///Token exists in blacklistPolicyIds
        case suspiciousTokenPay(policyId: String)
        case suspiciousTokenReceive(policyId: String)
        ///priceImpact >= IMPACT_TIERS[0] and settings.safeMode and hasExchange
        case tokenPayMigration(projectName: String, tokenName: String, policyId: String)
        case tokenReceiveMigration(projectName: String, tokenName: String, policyId: String)
        ///Token exists in MIGRATED_TOKENS
        case unregisteredToken(percent: String)
        ///decimals == 0
        case indivisibleTokenPay
        case indivisibleTokenReceive

        var title: LocalizedStringKey {
            switch self {
            case .highPriceImpact:
                "High price impact"
            case .unlimitedSlippageIsActivated:
                "Unlimited slippage is activated"
            case .unsafeSlippageTolerance:
                "Unsafe slippage tolerance"
            case .functionalTokenPay, .functionalTokenReceive:
                "Functional token"
            case .suspiciousTokenPay,
                .suspiciousTokenReceive:
                "Suspicious token"
            case .tokenPayMigration,
                .tokenReceiveMigration:
                "Token migration"
            case .unregisteredToken:
                "Unregistered token"
            case .indivisibleTokenPay,
                .indivisibleTokenReceive:
                "Indivisible Token"
            }
        }

        var content: LocalizedStringKey {
            switch self {
            case let .highPriceImpact(percent):
                "Price impact is more than \(percent)%, make sure to check the price before submitting the transaction."
            case .unlimitedSlippageIsActivated:
                " The order will get executed with any available price and unlimited slippage. This could lead to an undesirable price due to price changes from previous orders and loss of virtually all funds. You can turn it off in Safe Mode settings."
            case let .unsafeSlippageTolerance(percent):
                "Slippage tolerance is over \(percent)%. You can adjust it in trade "
            case let .functionalTokenPay(ticker, project),
                let .functionalTokenReceive(ticker, project):
                " Trading \(ticker) token on Minswap may lead to a loss of underlying assets on \(project)."
            case let .suspiciousTokenPay(policyId),
                let .suspiciousTokenReceive(policyId):
                "Make sure to double-check the policy Id: \(policyId)."
            case let .tokenPayMigration(projectName, policyId, tokenName),
                let .tokenReceiveMigration(projectName, policyId, tokenName):
                "This project token is migrated to a new token, you can exchange your old token on \(projectName) app. The new token has policyID \(policyId) and tokenName \(tokenName)."
            case let .unregisteredToken(percent):
                "Price impact is more than \(percent)%, make sure to check the price "
            case .indivisibleTokenPay,
                .indivisibleTokenReceive:
                "Certain tokens on the Cardano blockchain are designed as indivisible. This means each token must be used, transferred, or traded as a whole unit."
            }
        }
    }
    
    enum ErrorInfo {
        case insufficientBalance(name: String)
        case notEnoughAmountInPool(name: String)
        
        var content: LocalizedStringKey {
            switch self {
            case let .insufficientBalance(name):
                return "Insufficient \(name) balance"
            case let .notEnoughAmountInPool(name):
                return "Not enough \(name) amount in pool)"
            }
        }
    }
}
