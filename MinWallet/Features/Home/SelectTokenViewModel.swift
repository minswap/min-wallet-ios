import SwiftUI
import MinWalletAPI
import Then
import Combine


@MainActor
class SelectTokenViewModel: ObservableObject {
    enum Mode {
        case single
        case multiple
    }

    enum TokenType {
        case yourToken
        case market
    }

    @Published
    var tokens: [TokenProtocol] = []
    @Published
    var keyword: String = ""
    @Published
    var mode: Mode = .single

    private var input: AssetsInput = .init()
    private var searchAfter: [String]? = nil
    private var hasLoadMore: Bool = true
    private var isFetching: Bool = true
    ////currencySymbol + . + tokenName
    private let tokensSelected: [TokenProtocol]
    private var tokenType: TokenType = .yourToken

    private var cancellables: Set<AnyCancellable> = []
    var showSkeleton: Bool = true

    init(
        tokensSelected: [TokenProtocol?],
        mode: Mode = .multiple,
        tokenType: TokenType = .yourToken
    ) {
        self.mode = mode
        self.tokensSelected = tokensSelected.compactMap({ $0 })
        self.tokenType = tokenType

        $keyword
            .removeDuplicates()
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] newData in
                guard let self = self else { return }
                self.keyword = newData
                self.getTokens()
            }
            .store(in: &cancellables)
    }

    func getTokens(isLoadMore: Bool = false) {
        showSkeleton = !isLoadMore
        isFetching = true

        switch tokenType {
        case .yourToken:
            Task {
                let tokens = try? await MinWalletService.shared.fetch(query: WalletAssetsQuery(address: UserInfo.shared.minWallet?.address ?? ""))
                let normalToken = tokens?.getWalletAssetsPositions.assets ?? []
                let lpToken = tokens?.getWalletAssetsPositions.lpTokens ?? []

                self.tokens = keyword.isEmpty ? (normalToken + lpToken) : (normalToken + lpToken).filter({ $0.adaName.lowercased().contains(keyword.lowercased()) })
                self.hasLoadMore = false
                self.showSkeleton = false
                self.isFetching = false
            }
        case .market:
            input = AssetsInput()
                .with({
                    if let searchAfter = searchAfter, isLoadMore {
                        $0.searchAfter = .some(searchAfter)
                    } else {
                        $0.searchAfter = nil
                    }
                    if !keyword.isBlank {
                        $0.term = .some(keyword)
                    } else {
                        $0.term = nil
                    }
                })

            Task {
                let tokens = try? await MinWalletService.shared.fetch(query: AssetsQuery(input: .some(self.input)))
                let _tokens = tokens?.assets.assets ?? []
                if isLoadMore {
                    self.tokens += _tokens
                } else {
                    self.tokens = _tokens
                }
                self.searchAfter = tokens?.assets.searchAfter
                self.hasLoadMore = !_tokens.isEmpty
                self.showSkeleton = false
                self.isFetching = false
            }
        }
    }

    func loadMoreData(item: TokenProtocol) {
        guard hasLoadMore, !isFetching else { return }
        let thresholdIndex = tokens.index(tokens.endIndex, offsetBy: -5)
        if tokens.firstIndex(where: { ($0.currencySymbol + $0.tokenName) == (item.currencySymbol + $0.tokenName) }) == thresholdIndex {
            getTokens(isLoadMore: true)
        }
    }
}
