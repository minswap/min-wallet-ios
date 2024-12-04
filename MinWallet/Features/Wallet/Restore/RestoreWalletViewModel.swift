import SwiftUI
import FlowStacks


@MainActor
class RestoreWalletViewModel: ObservableObject {
    @Published
    var seedPhrase: [String] = []

    var password: String = ""
    @Published
    var nickName: String = ""

    init() {
        seedPhrase = CreateNewWalletViewModel.generateRandomWords(count: 24, minLength: 4, maxLength: 8)
    }
}

extension RestoreWalletViewModel {
    enum Screen: Hashable {
        case seedPhrase
        case createNewPassword
        case createNewWalletSuccess
    }
}
