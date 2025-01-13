import Foundation
import MinWalletAPI
import Combine


class TokenDetailViewModel: ObservableObject {

    var chartPeriods: [ChartPeriod] = [.oneDay, .oneWeek, .oneMonth, .oneYear]

    @Published
    var token: TokenProtocol!
    @Published
    var topAsset: TopAssetQuery.Data.TopAsset?
    @Published
    var chartPeriod: ChartPeriod = .oneDay

    private var cancellables: Set<AnyCancellable> = []

    init(token: TokenProtocol) {
        self.token = token

        $chartPeriod
            .removeDuplicates()
            .sink { [weak self] newData in
                self?.getPriceChart()
            }
            .store(in: &cancellables)
    }

    private func getTokenDetail() {
        Task {
            let asset = try? await MinWalletService.shared.fetch(query: TopAssetQuery(asset: InputAsset(currencySymbol: token.currencySymbol, tokenName: token.tokenName)))
            self.topAsset = asset?.topAsset
        }
    }

    private func getPoolsByPairs() {
        Task {
            let inputPair = InputPair(assetA: InputAsset(currencySymbol: "", tokenName: ""), assetB: InputAsset(currencySymbol: token.currencySymbol, tokenName: token.tokenName))
            let asset = try? await MinWalletService.shared.fetch(query: PoolsByPairsQuery(pairs: [inputPair]))
        }
    }

    private func getPriceChart() {
        Task {
            let input = PriceChartInput(assetIn: InputAsset(currencySymbol: "", tokenName: ""), assetOut: InputAsset(currencySymbol: token.currencySymbol, tokenName: token.tokenName), lpAsset: InputAsset(currencySymbol: "", tokenName: ""), period: .case(chartPeriod))
            let data = try? await MinWalletService.shared.fetch(query: PriceChartQuery(input: input))
        }
    }
}

extension ChartPeriod: Identifiable {
    public var id: UUID {
        UUID()
    }

    var title: String {
        switch self {
        case .oneDay:
            "1D"
        case .oneMonth:
            "1M"
        case .oneWeek:
            "1W"
        case .oneYear:
            "1Y"
        case .sixMonths:
            "6M"
        }
    }
}
