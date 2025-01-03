import Foundation


class UserInfo: ObservableObject {
    static let MIN_WALLET_KEY: String = "MIN_WALLET_KEY"

    static let nickNameDefault: String = "My MinWallet"

    static let shared: UserInfo = .init()

    @Published var minWallet: MinWallet?

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
