import SwiftUI
import MinWalletAPI


@MainActor
class ConfirmSendTokenViewModel: ObservableObject {
    
    @Published
    var tokens: [WrapTokenSend] = []
    @Published
    var address: String = ""
    @Published
    var isSendAll: Bool = false
    
    init(tokens: [WrapTokenSend], address: String, isSendAll: Bool) {
        self.tokens = tokens
        self.address = address
        self.isSendAll = isSendAll
    }
    
    func sendTokens() async throws -> String {
        let receiver = address
        let sender = UserInfo.shared.minWallet?.address ?? ""
        let publicKey = UserInfo.shared.minWallet?.publicKey ?? ""
        let assetAmounts: [InputAssetAmount] = tokens.map { token in
            let amount = token.amount.toSendBE(decimal: token.token.decimals)
            return InputAssetAmount(amount: amount.formatSNumber(usesGroupingSeparator: false, maximumFractionDigits: 0), asset: InputAsset(currencySymbol: token.token.currencySymbol, tokenName: token.token.tokenName))
        }
        let sendTokensMutation = SendTokensMutation(input: InputSendTokens(assetAmounts: assetAmounts, publicKey: publicKey, receiver: receiver, sender: sender))
        let sendTokens = try await MinWalletService.shared.mutation(mutation: sendTokensMutation)
        guard let txRaw = sendTokens?.sendTokens else { throw AppGeneralError.localErrorLocalized(message: "Transaction not exist") }
        return txRaw
    }
}
