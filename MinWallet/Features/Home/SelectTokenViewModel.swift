import SwiftUI
import MinWalletAPI
import Then
import Combine


@MainActor
class SelectTokenViewModel: ObservableObject {
    @Published
    var tokens: [TokenProtocol] = []
    @Published
    var keyword: String = ""
    @Published
    var showSkeleton: Bool = false
    @Published
    var tokensSelected: [String: TokenProtocol] = [:]
    @Published
    var screenType: SelectTokenView.ScreenType = .initSelectedToken
    
    private var hasLoadMore: Bool = true
    private var isFetching: Bool = true
    ////currencySymbol + . + tokenName

    private var cancellables: Set<AnyCancellable> = []
    private var cachedIndex:[String: Int] = [:]
    
    private var rawTokens: [TokenProtocol] {
        [TokenManager.shared.tokenAda] + TokenManager.shared.yourTokens.0 + TokenManager.shared.yourTokens.1
    }

    init(tokensSelected: [TokenProtocol?],
         screenType: SelectTokenView.ScreenType) {
        self.screenType = screenType
        self.tokensSelected = tokensSelected.compactMap({ $0 }).reduce([:], { result, token in
            result.appending([token.uniqueID: token])
        })
        
        tokensSelected.enumerated().forEach { idx, token in
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
                self.tokens = self.keyword.isEmpty ? rawTokens : rawTokens.filter({ $0.adaName.lowercased().contains(self.keyword.lowercased()) })
            }
            .store(in: &cancellables)
        
        self.tokens = rawTokens
        if self.tokens.count < 2 {
            self.getTokens()
        }
    }

    func getTokens(isLoadMore: Bool = false) {
        showSkeleton = !isLoadMore
        isFetching = true
        Task {
            let tokens = try? await TokenManager.getYourToken()
            TokenManager.shared.yourTokens =  ((tokens?.0 ?? []), (tokens?.1 ?? []))
            self.tokens = self.keyword.isEmpty ? rawTokens : rawTokens.filter({ $0.adaName.lowercased().contains(self.keyword.lowercased()) })
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
        guard hasLoadMore, !isFetching else { return }
        let thresholdIndex = tokens.index(tokens.endIndex, offsetBy: -5)
        if tokens.firstIndex(where: { ($0.currencySymbol + $0.tokenName) == (item.currencySymbol + $0.tokenName) }) == thresholdIndex {
            getTokens(isLoadMore: true)
        }
    }
    
    func toggleSelected(token: TokenProtocol) {
        guard token.uniqueID != MinWalletConstant.adaToken else { return }
        if tokensSelected[token.uniqueID] != nil {
            tokensSelected.removeValue(forKey: token.uniqueID)
        } else {
            tokensSelected[token.uniqueID] = token
        }
    }
}


extension SelectTokenViewModel {
    var tokenCallBack: [TokenProtocol] {
        var tokens = tokensSelected.map { key, value in value }
        tokens =  tokens.sorted { left, right in
            (cachedIndex[left.uniqueID] ?? 999) < (cachedIndex[right.uniqueID] ?? 999)
        }
        
        tokens.enumerated().forEach { idx, item in
            print("wtf zzz \(idx) \(item.adaName)")
        }
        return tokens
    }
}
