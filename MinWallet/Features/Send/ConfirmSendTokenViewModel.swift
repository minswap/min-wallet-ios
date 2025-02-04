import SwiftUI
import MinWalletAPI


@MainActor
class ConfirmSendTokenViewModel: ObservableObject {

    @Published
    var tokens: [WrapTokenSend] = []
    @Published
    var address: String = ""

    var tx: String?

    init(tokens: [WrapTokenSend], address: String) {
        self.tokens = tokens
        self.address = address
    }

    func sendTokens() async throws {
        if tx != nil { return }
        let receiver = address
        let sender = UserInfo.shared.minWallet?.address ?? ""
        let assetAmounts: [InputAssetAmount] = tokens.map { token in
            InputAssetAmount(amount: token.amount, asset: InputAsset(currencySymbol: token.token.currencySymbol, tokenName: token.token.tokenName))
        }
        let sendTokensMutation = SendTokensMutation(input: InputSendTokens(assetAmounts: assetAmounts, receiver: receiver, sender: sender))

        let sendTokens = try await MinWalletService.shared.mutation(mutation: sendTokensMutation)
        tx = sendTokens?.sendTokens
        if tx == nil {
            throw AppGeneralError.localError(message: "Transaction not exist")
        }
    }

    func finalizeAndSubmit() async throws -> String? {
        guard let wallet = UserInfo.shared.minWallet else { throw AppGeneralError.localError(message: "Wallet not found") }
        guard let tx = tx else { throw AppGeneralError.localError(message: "Transaction not found") }
        guard let witnessSet = signTx(wallet: wallet, password: AppSetting.shared.password, accountIndex: wallet.accountIndex, txRaw: tx)
        else { throw AppGeneralError.localError(message: "Sign transaction failed") }

        let data = try await MinWalletService.shared.mutation(mutation: FinalizeAndSubmitMutation(input: InputFinalizeAndSubmit(tx: tx, witnessSet: witnessSet)))
        return data?.finalizeAndSubmit
    }
}
