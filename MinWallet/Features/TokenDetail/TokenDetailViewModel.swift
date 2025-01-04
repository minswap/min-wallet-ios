import Foundation
import MinWalletAPI
import Combine


@MainActor
class TokenDetailViewModel: ObservableObject {
  
    var chartPeriods: [ChartPeriod] = [.oneDay, .oneWeek, .oneMonth, .oneYear]

    @Published
    var token: TokenProtocol!
    @Published
    var topAsset: TopAssetQuery.Data.TopAsset?
    @Published
    var chartPeriod: ChartPeriod = .oneDay
    @Published
    var chartDatas: [LineChartData] = []
    
    private var cancellables: Set<AnyCancellable> = []
  
    init(token: TokenProtocol = TokenProtocolDefault()) {
        self.token = token
        
        $chartPeriod
            .removeDuplicates()
            .sink { [weak self] newData in
                self?.chartPeriod = newData
                self?.chartDatas = []
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
            let input = PriceChartInput(assetIn: InputAsset(currencySymbol: "", tokenName: ""), assetOut: InputAsset(currencySymbol: token.currencySymbol, tokenName: token.tokenName), lpAsset: InputAsset(currencySymbol: "d6aae2059baee188f74917493cf7637e679cd219bdfbbf4dcbeb1d0b", tokenName: "12166ca33ba1e6b68102f2d778c074ca3b75c7567868f9789474a3e6ea52fd3a"), period: .case(chartPeriod))
            let data = try? await MinWalletService.shared.fetch(query: PriceChartQuery(input: input))
            let chartDatas = data?.priceChart.map({ priceChart in
                //2025-01-03T07:00:00.000Z
                let time = priceChart.time
                let value = priceChart.value
                return LineChartData(date: time.formatToDate, value: Double(value) ?? 0, type: .outside)
            })
            self.chartDatas = chartDatas ?? []
        }
    }
    
    func formatDate(value: Date) -> String {
        guard !chartDatas.isEmpty else { return " " }
        let inputFormatter = DateFormatter()
        switch chartPeriod {
        case .oneDay:
            inputFormatter.dateFormat = "HH:mm"
        case .oneMonth:
            inputFormatter.dateFormat = "MMM dd"
        case .oneWeek:
            inputFormatter.dateFormat = "MMM dd"
        case .oneYear:
            inputFormatter.dateFormat = "MMM yyyy"
        case .sixMonths:
            inputFormatter.dateFormat = "MMM dd"
        }
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        return inputFormatter.string(from: value)
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
