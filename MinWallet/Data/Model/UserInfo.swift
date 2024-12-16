import Foundation


class UserInfo: ObservableObject {
    @UserDefault("nick_name", defaultValue: "")
    private(set) var nickName: String {
        willSet {
            objectWillChange.send()
        }
    }

    @UserDefault("wallet_address", defaultValue: "Addrasdlfkjasdf12231123")
    private(set) var walletAddress: String {
        willSet {
            objectWillChange.send()
        }
    }

    @UserDefault("seed_phrase", defaultValue: "")
    private(set) var seedPhrase: String {
        willSet {
            objectWillChange.send()
        }
    }

    init() {}

    func setupNickName(_ nickName: String) {
        if nickName.isBlank {
            self.nickName = "My MinWallet"
        } else {
            self.nickName = nickName
        }
    }

    func saveWalletInfo(seedPhrase: String, nickName: String, walletAddress: String) {
        self.seedPhrase = seedPhrase
        self.setupNickName(nickName)
        self.walletAddress = walletAddress
    }

    func deleteAccount() {
        nickName = ""
        walletAddress = ""
        seedPhrase = ""
    }
}
