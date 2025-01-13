import Foundation
import Combine
import MinWalletAPI


@MainActor
class PortfolioOverviewViewModel: ObservableObject {

    @Published
    var netAdaValue: Double = 0
    @Published
    var pnl24H: Double = 0
    @Published
    var adaValue: Double = 0

    private var isLoaded: Bool = false

    init() {}

    func initPortfolioOverview() {
        guard !isLoaded else { return }
        isLoaded = true

        Task {
            repeat {
                await getPortfolioOverview()
                try? await Task.sleep(for: .seconds(5 * 60))
            } while (!Task.isCancelled)
        }
    }

    func getPortfolioOverview() async -> Void {
        guard let address = UserInfo.shared.minWallet?.address, !address.isBlank else { return }
        let portfolioOverview = try? await MinWalletService.shared.fetch(query: PortfolioOverviewQuery(address: UserInfo.shared.minWallet?.address ?? ""))
        self.netAdaValue = (portfolioOverview?.portfolioOverview.netAdaValue.doubleValue ?? 0) / 1_000_000
        self.pnl24H = (portfolioOverview?.portfolioOverview.pnl24H.doubleValue ?? 0) / 1_000_000
        self.adaValue = (portfolioOverview?.portfolioOverview.adaValue.doubleValue ?? 0) / 1_000_000
    }

    func fetchAdaHandleName() async -> String {
        guard let address = UserInfo.shared.minWallet?.address, !address.isBlank else { return "" }

        let adaHandleNameQuery = try? await MinWalletService.shared.fetch(query: ADAHandleNameQuery(address: address))
        let tokenName = adaHandleNameQuery?.getWalletAssetsPositions.nfts.first(where: { $0.asset.currencySymbol == UserInfo.POLICY_ID })?.asset.tokenName ?? ""

        let adaName: String? = {
            guard tokenName.count > 8 else { return tokenName.hexToText }
            let prefix = tokenName.prefix(8)
            if prefix.first == "0" && prefix.last == "0" {
                let remaining = String(tokenName.dropFirst(8))
                return remaining.hexToText
            } else {
                return tokenName.hexToText
            }
        }()

        return adaName ?? ""
    }

}
