import SwiftUI
import FlowStacks


@MainActor
class CreateNewWalletViewModel: ObservableObject {
    @Published var routes: Routes<Screen> = []
    
    @Published
    var seedPhrase: [String] = []
    @Published
    var nickName: String = ""
    
    var password: String = ""
    
    init() {
        seedPhrase = Self.generateRandomWords(count: 24, minLength: 4, maxLength: 8)
    }
}

extension CreateNewWalletViewModel {
    enum Screen: Hashable {
        case seedPhrase
        case reInputSeedPhrase
        case setupNickName
        case biometricSetup
        case createNewWalletSuccess
        case createNewPassword
    }
    
    static func generateRandomWords(count: Int, minLength: Int, maxLength: Int) -> [String] {
        let letters = "abcdefghijklmnopqrstuvwxyz"
        var words: [String] = []
        
        for _ in 0..<count {
            let length = Int.random(in: minLength...maxLength)
            let word = String((0..<length).map { _ in letters.randomElement()! })
            words.append(word)
        }
        
        return words
    }
}
