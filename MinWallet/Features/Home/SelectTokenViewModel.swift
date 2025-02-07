import SwiftUI
import MinWalletAPI
import Then
import Combine


@MainActor
class SelectTokenViewModel: ObservableObject {
    @Published
    var tokens: [WrapTokenProtocol] = []
    @Published
    var keyword: String = ""
    @Published
    var showSkeleton: Bool = false
    @Published
    var tokensSelected: [String: TokenProtocol] = [:]
    @Published
    var screenType: SelectTokenView.ScreenType = .initSelectedToken
    @Published
    var sourceScreenType: SendTokenView.ScreenType = .normal

    private var hasLoadMore: Bool = true
    private var isFetching: Bool = true
    ////currencySymbol + . + tokenName

    private var cancellables: Set<AnyCancellable> = []
    private var cachedIndex: [String: Int] = [:]

    private var rawTokens: [TokenProtocol] {
        [TokenManager.shared.tokenAda] + (TokenManager.shared.yourTokens?.assets ?? []) + (TokenManager.shared.yourTokens?.lpTokens ?? [])
    }

    init(
        tokensSelected: [TokenProtocol?],
        screenType: SelectTokenView.ScreenType,
        sourceScreenType: SendTokenView.ScreenType
    ) {
        self.screenType = screenType
        self.sourceScreenType = sourceScreenType
        self.tokensSelected = tokensSelected.compactMap({ $0 })
            .reduce(
                [:],
                { result, token in
                    result.appending([token.uniqueID: token])
                })
        tokensSelected.enumerated()
            .forEach { idx, token in
                self.cachedIndex[token?.uniqueID ?? ""] = idx
            }
        self.cachedIndex[TokenManager.shared.tokenAda.uniqueID] = -1
        switch screenType {
        case .initSelectedToken:
            self.tokensSelected[TokenManager.shared.tokenAda.uniqueID] = TokenManager.shared.tokenAda
        default:
            break
        }
        $keyword
            .dropFirst()
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] newData in
                guard let self = self else { return }
                self.keyword = newData
                //self.getTokens()
                let rawTokens = self.rawTokens
                let _tokens = self.keyword.isEmpty ? rawTokens : rawTokens.filter({ $0.adaName.lowercased().contains(self.keyword.lowercased()) })
                self.tokens = _tokens.map({ WrapTokenProtocol(token: $0) })
            }
            .store(in: &cancellables)

        self.tokens = rawTokens.map({ WrapTokenProtocol(token: $0) })
        if self.tokens.count < 2 {
            self.getTokens()
        }
    }

    func getTokens(isLoadMore: Bool = false) {
        showSkeleton = !isLoadMore
        isFetching = true
        Task {
            let tokens = try? await TokenManager.getYourToken()
            TokenManager.shared.yourTokens = tokens
            let _tokens = self.keyword.isEmpty ? rawTokens : rawTokens.filter({ $0.adaName.lowercased().contains(self.keyword.lowercased()) })
            self.tokens = _tokens.map({ WrapTokenProtocol(token: $0) })
            switch screenType {
            case .initSelectedToken:
                self.tokensSelected[TokenManager.shared.tokenAda.uniqueID] = TokenManager.shared.tokenAda
            default:
                break
            }
            self.hasLoadMore = false
            self.showSkeleton = false
            self.isFetching = false
        }
    }

    func loadMoreData(item: TokenProtocol) {
        /*
        guard hasLoadMore, !isFetching else { return }
        let thresholdIndex = tokens.index(tokens.endIndex, offsetBy: -5)
        if tokens.firstIndex(where: { ($0.currencySymbol + $0.tokenName) == (item.currencySymbol + $0.tokenName) }) == thresholdIndex {
            getTokens(isLoadMore: true)
        }
         */
    }

    func toggleSelected(token: TokenProtocol) {
        switch screenType {
        case .initSelectedToken, .sendToken:
            guard token.uniqueID != MinWalletConstant.adaToken else { return }
            if tokensSelected[token.uniqueID] != nil {
                tokensSelected.removeValue(forKey: token.uniqueID)
            } else {
                tokensSelected[token.uniqueID] = token
            }
        case .swapToken:
            tokensSelected.removeAll()
            tokensSelected[token.uniqueID] = token
        }
    }
}


extension SelectTokenViewModel {
    var tokenCallBack: [TokenProtocol] {
        let tokens = tokensSelected.map { key, value in value }
        return tokens.sorted { left, right in
            (cachedIndex[left.uniqueID] ?? 999) < (cachedIndex[right.uniqueID] ?? 999)
        }
    }
}
