import SwiftUI


class SendTokenViewModel: ObservableObject {

    @Published
    var tokens: [WrapTokenSend] = []
    @Published
    var amountDefault: String = ""

    init() {}

    func addToken(tokens: [TokenProtocol]) {
        //TODO: cuongnv single mode
        guard let tokenUpdate = tokens.first, !self.tokens.contains(where: { $0.token.uniqueID == tokenUpdate.uniqueID }) else { return }
        self.tokens.append(WrapTokenSend(token: tokenUpdate))
    }
}


struct WrapTokenSend {
    var token: TokenProtocol

    var amount: String = ""

    init(token: TokenProtocol, amount: String = "") {
        self.token = token
        self.amount = amount
    }
}