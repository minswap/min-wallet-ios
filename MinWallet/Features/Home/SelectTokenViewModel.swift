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
    @Published
    var scrollToTop: Bool = false
    var searchAfter: [String]? = nil

    private var hasLoadMore: Bool = true
    private var isFetching: Bool = true

    private var cancellables: Set<AnyCancellable> = []
    private var cachedIndex: [String: Int] = [:]

    private var rawTokens: [TokenProtocol] {
        [TokenManager.shared.tokenAda] + TokenManager.shared.normalTokens
    }

    init(
        tokensSelected: [TokenProtocol?] = [],
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
            .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
            .removeDuplicates()
            .dropFirst()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] newData in
                guard let self = self else { return }
                self.keyword = newData
                switch self.screenType {
                case .initSelectedToken,
                    .sendToken:
                    let rawTokens = self.rawTokens

                    let keyword = self.keyword.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    let _tokens =
                        keyword.isBlank
                        ? rawTokens
                        : rawTokens.filter({
                            let stringToCompare: [String] = [
                                $0.adaName.lowercased(),
                                $0.currencySymbol,
                                $0.tokenName.lowercased(),
                                $0.projectName.lowercased(),
                                $0.ticker.lowercased(),
                            ]
                            return stringToCompare.first { $0.contains(keyword) } != nil
                        })
                    self.tokens = _tokens.map({ WrapTokenProtocol(token: $0) })
                case .swapToken:
                    self.getTokens()
                }

            }
            .store(in: &cancellables)

        switch screenType {
        case .initSelectedToken, .sendToken:
            if rawTokens.count <= 1 {
                self.getTokens()
            } else {
                self.tokens = rawTokens.map({ WrapTokenProtocol(token: $0) })
            }
        case .swapToken:
            self.getTokens()
        }
    }

    func getTokens(isLoadMore: Bool = false) {
        Task {
            do {
                showSkeleton = !isLoadMore
                isFetching = true

                var _tokens: [TokenProtocol] = []
                if !isLoadMore {
                    //let _ = try await TokenManager.getYourToken()
                    let keyword = self.keyword.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    _tokens =
                        keyword.isEmpty
                        ? rawTokens
                        : rawTokens.filter({
                            let stringToCompare: [String] = [
                                $0.adaName.lowercased(),
                                $0.currencySymbol,
                                $0.tokenName.lowercased(),
                                $0.projectName.lowercased(),
                                $0.ticker.lowercased(),
                            ]
                            return stringToCompare.first { $0.contains(keyword) } != nil
                        })
                } else {
                    _tokens = self.tokens.map({ $0.token })
                }

                switch screenType {
                case .initSelectedToken:
                    self.hasLoadMore = false
                    self.tokens = _tokens.map({ WrapTokenProtocol(token: $0) })
                    self.tokensSelected[TokenManager.shared.tokenAda.uniqueID] = TokenManager.shared.tokenAda

                case .sendToken:
                    self.hasLoadMore = false
                    self.tokens = _tokens.map({ WrapTokenProtocol(token: $0) })

                case .swapToken:
                    let input = AssetsInput()
                        .with {
                            if isLoadMore, let searchAfter = searchAfter {
                                $0.searchAfter = .some(searchAfter)
                            }
                            if !keyword.isBlank {
                                $0.term = .some(keyword)
                            }
                        }
                    let assets = try await MinWalletService.shared.fetch(query: AssetsQuery(input: .some(input)))
                    self.searchAfter = assets?.assets.searchAfter
                    self.hasLoadMore = self.searchAfter != nil
                    if let assets = assets?.assets.assets, !assets.isEmpty {
                        let currentUniqueIds = _tokens.map { $0.uniqueID }
                        let _assets: [TokenProtocol] = assets.filter { !currentUniqueIds.contains($0.uniqueID) }
                        self.tokens = (_tokens + _assets).map({ WrapTokenProtocol(token: $0) })
                    }
                }

                self.showSkeleton = false
                self.isFetching = false
            } catch {
                self.hasLoadMore = false
                self.showSkeleton = false
                self.isFetching = false
            }
        }
    }

    func loadMoreData(item: TokenProtocol) {
        guard case .swapToken = screenType else { return }
        guard hasLoadMore, !isFetching else { return }
        let thresholdIndex = tokens.index(tokens.endIndex, offsetBy: -5)
        if tokens.firstIndex(where: { ($0.token.uniqueID == item.uniqueID) }) == thresholdIndex {
            getTokens(isLoadMore: true)
        }
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

    func selectToken(tokens: [TokenProtocol]) {
        tokensSelected = tokens.compactMap({ $0 })
            .reduce(
                [:],
                { result, token in
                    result.appending([token.uniqueID: token])
                })
        tokens.enumerated()
            .forEach { idx, token in
                self.cachedIndex[token.uniqueID] = idx
            }
    }

    func resetState() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) { [weak self] in
            guard let self = self else { return }
            self.scrollToTop = true
            self.keyword = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                self.scrollToTop = false
            }
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
