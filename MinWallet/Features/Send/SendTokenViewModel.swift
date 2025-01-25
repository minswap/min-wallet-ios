import SwiftUI


@MainActor
class SendTokenViewModel: ObservableObject {

    @Published
    var tokens: [WrapTokenSend] = []

    init(tokens: [TokenProtocol]) {
        self.tokens = tokens.map({ WrapTokenSend(token: $0) })
    }

    func addToken(tokens: [TokenProtocol]) {
        let currentAmountWithToken = self.tokens.reduce([:]) { result, wrapToken in
            result.appending([wrapToken.uniqueID: wrapToken.amount])
        }
        self.tokens = tokens.map { WrapTokenSend(token: $0, amount: currentAmountWithToken[$0.uniqueID] ?? "") }
    }

    func setMaxAmount(item: WrapTokenSend) {
        guard let index = tokens.firstIndex(where: { $0.id == item.id }) else { return }
        tokens[index].amount = item.token.amount.formatSNumber(usesGroupingSeparator: false, maximumFractionDigits: 15)
    }
}


struct WrapTokenSend: Identifiable {
    let id: UUID  = UUID()
    var token: TokenProtocol

    var amount: String = ""

    init(token: TokenProtocol, amount: String = "") {
        self.token = token
        self.amount = amount
    }
    
    var uniqueID: String {
        token.uniqueID
    }
}
