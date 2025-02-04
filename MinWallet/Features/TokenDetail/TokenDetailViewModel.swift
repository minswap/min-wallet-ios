import Foundation
import MinWalletAPI
import Combine


@MainActor
class TokenDetailViewModel: ObservableObject {

    private let suspiciousTokenURL = "https://raw.githubusercontent.com/cardano-galactic-police/suspicious-tokens/refs/heads/main/tokens.txt"

    var chartPeriods: [ChartPeriod] = [.oneDay, .oneWeek, .oneMonth, .oneYear]

    @Published
    var token: TokenProtocol!
    @Published
    var topAsset: TopAssetQuery.Data.TopAsset?
    @Published
    var riskCategory: RiskCategory?
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
        return chartDatas[selectedIndex]
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

    private func getTokenDetail() {
        Task {
            let asset = try? await MinWalletService.shared.fetch(query: TopAssetQuery(asset: InputAsset(currencySymbol: token.currencySymbol, tokenName: token.tokenName)))
            self.topAsset = asset?.topAsset
        }
    }

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

    private func getRickScore() {
        Task {
            let riskScore = try? await MinWalletService.shared.fetch(query: RiskScoreOfAssetQuery(asset: InputAsset(currencySymbol: token.currencySymbol, tokenName: token.tokenName)))
            self.riskCategory = riskScore?.riskScoreOfAsset?.riskCategory.value
        }
    }

    private func checkTokenValid() {
        guard let url = URL(string: suspiciousTokenURL) else { return }
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let tokensScam = String(decoding: data, as: UTF8.self).split(separator: "\n").map { String($0) }
                isSuspiciousToken = tokensScam.contains(token.currencySymbol)
            } catch {
                isSuspiciousToken = false
            }
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
