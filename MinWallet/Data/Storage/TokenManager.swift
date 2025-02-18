import Foundation
import MinWalletAPI


@MainActor
class TokenManager: ObservableObject {

    static var shared: TokenManager = .init()

    var hasReloadBalance: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }

    var isHasYourToken: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }

    ///Cached your token, include normal + lp tokens + nft
    var yourTokens: WalletAssetsQuery.Data.GetWalletAssetsPositions? {
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

    var tokenAda: TokenDefault = TokenDefault(symbol: "", tName: "", minName: "Cardano")

    private init() {}

    func getPortfolioOverview() async -> Void {
        guard AppSetting.shared.isLogin else { return }
        guard let address = UserInfo.shared.minWallet?.address, !address.isBlank else { return }
        let portfolioOverview = try? await MinWalletService.shared.fetch(query: PortfolioOverviewQuery(address: UserInfo.shared.minWallet?.address ?? ""))
        netAdaValue = (portfolioOverview?.portfolioOverview.netAdaValue.doubleValue ?? 0) / 1_000_000
        pnl24H = (portfolioOverview?.portfolioOverview.pnl24H.doubleValue ?? 0) / 1_000_000
        adaValue = (portfolioOverview?.portfolioOverview.adaValue.doubleValue ?? 0) / 1_000_000
        tokenAda.netValue = adaValue
        tokenAda.netSubValue = adaValue
    }
    
    func reloadPortfolioOverview() async {
        await getPortfolioOverview()
        tokenAda.netValue = 9999
        tokenAda.netSubValue = 9999
        hasReloadBalance = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.hasReloadBalance = false
        }
    }
}

extension TokenManager {
    static func reset() {
        TokenManager.shared = .init()
    }

    static func getYourToken() async throws -> WalletAssetsQuery.Data.GetWalletAssetsPositions? {
        let tokens = try await MinWalletService.shared.fetch(query: WalletAssetsQuery(address: UserInfo.shared.minWallet?.address ?? ""))
        return tokens?.getWalletAssetsPositions
    }

    func fetchAdaHandleName() -> String {
        let tokenName = yourTokens?.nfts.first(where: { $0.asset.currencySymbol == UserInfo.POLICY_ID })?.asset.tokenName ?? ""
        let adaName: String? = tokenName.adaName
        return adaName ?? ""
    }
}
