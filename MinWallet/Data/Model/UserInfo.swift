import SwiftUI


class UserInfo: ObservableObject {
    static let POLICY_ID: String = "f0ff48bbb7bbe9d59a40f1ce90e9e9d0ff5002ec48f232b49ca0fb9a"
    static let TOKEN_ADA: String = "lovelace"

    static let TOKEN_NAME_DEFAULT: [String: String] = [
        MinWalletConstant.adaToken: "ADA",
        MinWalletConstant.lpToken: "LP",
        MinWalletConstant.minToken: "MIN",
        MinWalletConstant.mintToken: "MINt",
    ]

    static let MIN_WALLET_KEY: String = "MIN_WALLET_KEY"

    static let shared: UserInfo = .init()

    @Published var minWallet: MinWallet?

    @UserDefault("adaHandleName", defaultValue: "")
    var adaHandleName: String {
        willSet {
            objectWillChange.send()
        }
    }

    private init() {
        self.readMinWallet()
    }

    func saveWalletInfo(walletInfo: MinWallet) {
        guard let encoded = try? JSONEncoder().encode(walletInfo) else { return }
        UserDefaults.standard.set(encoded, forKey: Self.MIN_WALLET_KEY)

        self.minWallet = walletInfo
    }

    func deleteAccount() {
        minWallet = nil
        adaHandleName = ""
        removeWallet()
    }

    private func readMinWallet() {
        guard let wallet = UserDefaults.standard.object(forKey: Self.MIN_WALLET_KEY) as? Data,
            let minWallet = try? JSONDecoder().decode(MinWallet.self, from: wallet)
        else { return }

        self.minWallet = minWallet
    }

    private func removeWallet() {
        UserDefaults.standard.removeObject(forKey: Self.MIN_WALLET_KEY)
    }

    var walletName: String {
        guard let name = minWallet?.walletName else { return "" }
        if name.count <= 12 {
            return name
        }

        let first5Characters = name.prefix(5)
        let last5Characters = name.suffix(5)
        return "\(first5Characters)...\(last5Characters)"
    }
}
