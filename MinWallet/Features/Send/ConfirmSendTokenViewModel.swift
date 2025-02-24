import SwiftUI
import MinWalletAPI


@MainActor
class ConfirmSendTokenViewModel: ObservableObject {

    @Published
    var tokens: [WrapTokenSend] = []
    @Published
    var address: String = ""

    init(tokens: [WrapTokenSend], address: String) {
        self.tokens = tokens
        self.address = address
    }

    func sendTokens() async throws -> String {
        let receiver = address
        let sender = UserInfo.shared.minWallet?.address ?? ""
        let assetAmounts: [InputAssetAmount] = tokens.map { token in
            let amount = token.amount.doubleValue * pow(10, Double(token.token.decimals))
            return InputAssetAmount(amount: amount.toIntStringValue, asset: InputAsset(currencySymbol: token.token.currencySymbol, tokenName: token.token.tokenName))
        }
        let sendTokensMutation = SendTokensMutation(input: InputSendTokens(assetAmounts: assetAmounts, receiver: receiver, sender: sender))
        let sendTokens = try await MinWalletService.shared.mutation(mutation: sendTokensMutation)
        guard let txRaw = sendTokens?.sendTokens else { throw AppGeneralError.localErrorLocalized(message: "Transaction not exist") }
        return txRaw
    }
}
