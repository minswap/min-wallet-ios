import SwiftUI


@MainActor
class SendTokenViewModel: ObservableObject {
    
    @Published
    var tokens: [WrapTokenSend] = []
    @Published
    var screenType: SendTokenView.ScreenType = .normal
    @Published
    var selectTokenVM: SelectTokenViewModel = .init(screenType: .sendToken, sourceScreenType: .normal)
    
    init(tokens: [TokenProtocol], screenType: SendTokenView.ScreenType) {
        self.tokens = tokens.map({ WrapTokenSend(token: $0) })
        self.screenType = screenType
    }
    
    /// Updates the tokens array with new tokens, preserving existing amounts for tokens with matching unique IDs.
    /// - Parameter tokens: The new list of tokens to include.
    func addToken(tokens: [TokenProtocol]) {
        let currentAmountWithToken = self.tokens.reduce([:]) { result, wrapToken in
            result.appending([wrapToken.uniqueID: wrapToken.amount])
        }
        self.tokens = tokens.map { WrapTokenSend(token: $0, amount: currentAmountWithToken[$0.uniqueID] ?? "") }
    }
    
    /// Sets the maximum transferable amount for the specified token item in the tokens array.
    /// - Parameter item: The token item for which to set the maximum amount.
    /// 
    /// For ADA tokens, subtracts the minimum required ADA value before setting the amount. For other tokens, sets the amount to the token's full available amount, formatted according to its decimal precision.
    func setMaxAmount(item: WrapTokenSend) {
        guard let index = tokens.firstIndex(where: { $0.id == item.id }) else { return }
        let decimals = tokens[index].token.decimals
        if tokens[index].token.isTokenADA {
            let maxAmount = item.token.amount - TokenManager.shared.minimumAdaValue
            tokens[index].amount = maxAmount.formatSNumber(usesGroupingSeparator: false, maximumFractionDigits: decimals)
        } else {
            tokens[index].amount = item.token.amount.formatSNumber(usesGroupingSeparator: false, maximumFractionDigits: decimals)
        }
    }
    
    var tokensToSend: [WrapTokenSend] {
        tokens.filter { (Decimal(string: $0.amount) ?? 0) > 0 }
    }
    
    var isValidTokenToSend: Bool {
        if tokens.count == 1 && tokens.first?.amount.isBlank == true {
            return false
        }
        return tokens.filter({ !$0.token.isTokenADA }).allSatisfy({ !$0.amount.isBlank })
    }
}


struct WrapTokenSend: Identifiable {
    let id: UUID = UUID()
    var token: TokenProtocol
    
    var amount: String = ""
    
    init(token: TokenProtocol, amount: String = "") {
        self.token = token
        self.amount = amount
    }
    
    var uniqueID: String {
        token.uniqueID
    }
    
    var currencySymbol: String {
        token.currencySymbol
    }
    
    var tokenName: String {
        token.tokenName
    }
    
    var adaName: String {
        let name = token.adaName
        if name.count > 6 {
            return name.prefix(6) + "..."
        } else {
            return name
        }
    }
}
