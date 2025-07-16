import Foundation
import MinWalletAPI
import Combine


@MainActor
class TokenManager: ObservableObject {

    static let TIME_RELOAD_BALANCE: TimeInterval = 20
    static let TIME_RELOAD_MARKET: TimeInterval = 5 * 60

    static var shared: TokenManager = .init()

    let reloadBalance: PassthroughSubject<Void, Never> = .init()

    var isLoadingPortfolioOverviewAndYourToken: Bool = false

    ///Cached your token, include normal + lp tokens + nft
    private(set) var yourTokens: WalletAssetsQuery.Data.GetWalletAssetsPositions? {
        willSet {
            objectWillChange.send()
        }
    }

    var netAdaValue: Double = 0 {
        willSet {
            objectWillChange.send()
        }
    }

    var pnl24H: Double = 0 {
        willSet {
            objectWillChange.send()
        }
    }

    var adaValue: Double = 0 {
        willSet {
            objectWillChange.send()
        }
    }

    var minimumAdaValue: Double = 0 {
        willSet {
            objectWillChange.send()
        }
    }

    var tokenAda: TokenDefault = TokenDefault(symbol: "", tName: "", minName: "Cardano", decimal: 6)

    private init() {}

    private func getPortfolioOverview() async -> Void {
        guard AppSetting.shared.isLogin else { return }
        guard let address = UserInfo.shared.minWallet?.address, !address.isBlank else { return }
        let portfolioOverview = try? await MinWalletService.shared.fetch(query: PortfolioOverviewQuery(address: UserInfo.shared.minWallet?.address ?? ""))
        netAdaValue = (portfolioOverview?.portfolioOverview.netAdaValue.doubleValue ?? 0) / 1_000_000
        pnl24H = (portfolioOverview?.portfolioOverview.pnl24H.doubleValue ?? 0) / 1_000_000
        adaValue = (portfolioOverview?.portfolioOverview.adaValue.doubleValue ?? 0) / 1_000_000
        tokenAda.netValue = adaValue
        tokenAda.netSubValue = adaValue
    }

    func getPortfolioOverviewAndYourToken() async throws -> Void {
        isLoadingPortfolioOverviewAndYourToken = true
        async let getPortfolioOverviewAsync: Void = getPortfolioOverview()
        async let getYourTokenAsync: Void? = TokenManager.getYourToken().map { _ in return () }
        async let fetchMinimumAdaValueAsync: Void? = fetchMinimumAdaValue()

        let _ = try await [getPortfolioOverviewAsync, getYourTokenAsync, fetchMinimumAdaValueAsync]
        isLoadingPortfolioOverviewAndYourToken = false
        reloadBalance.send(())
    }

    private func fetchMinimumAdaValue() async throws -> Void {
        do {
            guard let address = UserInfo.shared.minWallet?.address else { return }
            let minimumAda = try await MinWalletService.shared.fetch(query: GetMinimumLovelaceQuery(address: address))
            minimumAdaValue = (minimumAda?.getMinimumLovelace.doubleValue ?? 0) / 1_000_000
        } catch {
            minimumAdaValue = 0
        }
    }
}

extension TokenManager {
    static func reset() {
        TokenManager.shared = .init()
    }

    @discardableResult
    private static func getYourToken() async throws -> WalletAssetsQuery.Data.GetWalletAssetsPositions? {
        let tokens = try await MinWalletService.shared.fetch(query: WalletAssetsQuery(address: UserInfo.shared.minWallet?.address ?? ""))
        TokenManager.shared.yourTokens = tokens?.getWalletAssetsPositions
        UserInfo.shared.adaHandleName = tokens?.getWalletAssetsPositions.nfts.first(where: { $0.asset.currencySymbol == UserInfo.POLICY_ID })?.asset.tokenName.adaName ?? ""
        return TokenManager.shared.yourTokens
    }

    ///Not include nft
    var normalTokens: [TokenProtocol] {
        return (yourTokens?.assets ?? []) + (yourTokens?.lpTokens ?? [])
    }

    var nftTokens: [TokenProtocol] {
        return yourTokens?.nfts ?? []
    }

    var hasTokenOrNFT: Bool {
        return !normalTokens.isEmpty || !nftTokens.isEmpty
    }
}


extension TokenManager {
    ///Tx raw -> tx ID
    static func finalizeAndSubmit(txRaw: String) async throws -> String? {
        guard let wallet = UserInfo.shared.minWallet else { throw AppGeneralError.localErrorLocalized(message: "Wallet not found") }
        guard let witnessSet = signTx(wallet: wallet, password: AppSetting.shared.password, accountIndex: wallet.accountIndex, txRaw: txRaw)
        else { throw AppGeneralError.localErrorLocalized(message: "Sign transaction failed") }
        
        let data = try await MinWalletService.shared.mutation(mutation: FinalizeAndSubmitMutation(input: InputFinalizeAndSubmit(tx: txRaw, witnessSet: witnessSet)))
        return data?.finalizeAndSubmit
    }
    
    static func finalizeAndSubmitV2(txRaw: String) async throws -> String? {
        guard let wallet = UserInfo.shared.minWallet else { throw AppGeneralError.localErrorLocalized(message: "Wallet not found") }
        guard let witnessSet = signTx(wallet: wallet, password: AppSetting.shared.password, accountIndex: wallet.accountIndex, txRaw: txRaw)
        else { throw AppGeneralError.localErrorLocalized(message: "Sign transaction failed") }
        
        let jsonData = try await SwapTokenAPIRouter.signTX(cbor: txRaw, witness_set: witnessSet).async_request()
        return jsonData["tx_id"].string
    }
}
