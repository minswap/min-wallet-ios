import SwiftUI
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
    var riskCategory: RiskScoreOfAssetQuery.Data.RiskScoreOfAsset?
    @Published
    var chartPeriod: ChartPeriod = .oneDay
    @Published
    var chartDatas: [LineChartData] = []
    @Published
    var isFav: Bool = false
    @Published
    var scrollOffset: CGPoint = .zero
    @Published
    var sizeOfLargeHeader: CGSize = .zero
    @Published
    var selectedIndex: Int?
    @Published
    var isSuspiciousToken: Bool = false
    @Published
    var isLoadingPriceChart: Bool = true
    @Published
    var isInteracting = false
    
    private var lpAsset: PoolsByPairsQuery.Data.PoolsByPair.LpAsset?
    
    var chartDataSelected: LineChartData? {
        guard let selectedIndex = selectedIndex, selectedIndex < chartDatas.count else { return chartDatas.last }
        return chartDatas[gk_safeIndex: selectedIndex]
    }
    
    var percent: Double {
        guard let selectedIndex = selectedIndex, !chartDatas.isEmpty else { return 0 }
        guard let current = chartDatas[gk_safeIndex: selectedIndex]?.value, let previous = chartDatas[gk_safeIndex: selectedIndex - 1]?.value else { return 0 }
        return (current - previous) / previous * 100
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(token: TokenProtocol = TokenProtocolDefault()) {
        self.token = token
        
        $chartPeriod
            .removeDuplicates()
            .sink { [weak self] newData in
                guard let self = self else { return }
                Task {
                    self.isLoadingPriceChart = true
                    self.chartPeriod = newData
                    self.selectedIndex = nil
                    self.chartDatas = []
                    try? await Task.sleep(for: .milliseconds(800))
                    await self.getPriceChart()
                    self.isLoadingPriceChart = false
                }
            }
            .store(in: &cancellables)
        
        isFav = UserInfo.shared.tokensFav.contains(where: { $0.uniqueID == token.uniqueID })
        
        getTokenDetail()
        getRickScore()
        checkTokenValid()
    }
    
    /// Asynchronously fetches and updates the top asset details for the current token.
    private func getTokenDetail() {
        Task {
            let asset = try? await MinWalletService.shared.fetch(query: TopAssetQuery(asset: InputAsset(currencySymbol: token.currencySymbol, tokenName: token.tokenName)))
            self.topAsset = asset?.topAsset
        }
    }
    
    /// Fetches and updates the price chart data for the current token and selected chart period.
    /// 
    /// If the liquidity pool asset (`lpAsset`) is not already set, it is fetched first. The method then retrieves price chart data for the token, maps it into `LineChartData` objects, and updates the `chartDatas` and `selectedIndex` properties accordingly.
    private func getPriceChart() async {
        if lpAsset == nil {
            let inputPair = InputPair(assetA: InputAsset(currencySymbol: "", tokenName: ""), assetB: InputAsset(currencySymbol: token.currencySymbol, tokenName: token.tokenName))
            let poolByPair = try? await MinWalletService.shared.fetch(query: PoolsByPairsQuery(pairs: [inputPair]))
            self.lpAsset = poolByPair?.poolsByPairs.first?.lpAsset
        }
        
        let input = PriceChartInput(
            assetIn: InputAsset(currencySymbol: "", tokenName: ""),
            assetOut: InputAsset(currencySymbol: token.currencySymbol, tokenName: token.tokenName),
            lpAsset: InputAsset(currencySymbol: lpAsset?.currencySymbol ?? "", tokenName: lpAsset?.tokenName ?? ""),
            period: .case(chartPeriod))
        let data = try? await MinWalletService.shared.fetch(query: PriceChartQuery(input: input))
        let chartDatas = data?.priceChart
            .map({ priceChart in
                //2025-01-03T07:00:00.000Z
                let time = priceChart.time
                let value = priceChart.value
                return LineChartData(date: time.formatToDate, value: Double(value) ?? 0, type: .outside)
            })
        self.chartDatas = chartDatas ?? []
        self.selectedIndex = max(0, self.chartDatas.count - 1)
    }
    
    /// Asynchronously fetches and updates the risk score category for the current token.
    private func getRickScore() {
        Task {
            let riskScore = try? await MinWalletService.shared.fetch(query: RiskScoreOfAssetQuery(asset: InputAsset(currencySymbol: token.currencySymbol, tokenName: token.tokenName)))
            self.riskCategory = riskScore?.riskScoreOfAsset
        }
    }
    
    /// Asynchronously checks if the current token is suspicious and updates the `isSuspiciousToken` property.
    private func checkTokenValid() {
        Task {
            isSuspiciousToken = await AppSetting.shared.isSuspiciousToken(currencySymbol: token.currencySymbol)
        }
    }
    
    /// Formats a date as a string based on the current chart period.
    /// - Parameter value: The date to format.
    /// - Returns: A formatted date string appropriate for the selected chart period, or a blank string if no chart data is available.
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
    
    /// Formats a date for chart annotation based on the current chart period.
    /// - Parameter value: The date to format.
    /// - Returns: A formatted date string suitable for chart annotations, or a blank string if no chart data is available.
    func formatDateAnnotation(value: Date) -> String {
        guard !chartDatas.isEmpty else { return " " }
        let inputFormatter = DateFormatter()
        switch chartPeriod {
        case .oneDay:
            inputFormatter.dateFormat = "HH:mm"
        case .oneMonth:
            inputFormatter.dateFormat = "HH:mm, MMM dd"
        case .oneWeek:
            inputFormatter.dateFormat = "HH:mm, MMM dd"
        case .oneYear:
            inputFormatter.dateFormat = "MMM dd, yyyy"
        case .sixMonths:
            inputFormatter.dateFormat = "HH:mm, MMM dd"
        }
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        return inputFormatter.string(from: value)
    }
}

extension ChartPeriod: @retroactive Identifiable {
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
