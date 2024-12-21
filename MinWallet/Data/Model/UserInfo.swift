import Foundation


class UserInfo: ObservableObject {
    static let MIN_WALLET_KEY: String = "MIN_WALLET_KEY"

    static let nickNameDefault: String = "My MinWallet"

    @Published var minWallet: MinWallet?

    init() {
        self.readMinWallet()
    }

    func saveWalletInfo(walletInfo: MinWallet) {
        guard let encoded = try? JSONEncoder().encode(minWallet) else { return }
        UserDefaults.standard.set(encoded, forKey: Self.MIN_WALLET_KEY)

        self.minWallet = minWallet
    }

    func deleteAccount() {
        minWallet = nil
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
}
