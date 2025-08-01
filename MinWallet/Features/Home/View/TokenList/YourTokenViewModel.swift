import SwiftUI
import Foundation
import Combine
import MinWalletAPI
import OneSignalFramework


@MainActor
class YourTokenViewModel: ObservableObject {
    
    @Published
    var tokens: [TokenProtocol] = []
    @Published
    var showSkeleton: Bool? = nil
    
    private let type: TokenListView.TabType
    
    init(type: TokenListView.TabType) {
        self.type = type
    }
    
    /// Asynchronously fetches and updates the list of tokens based on the current tab type, managing the loading state for the UI.
    func getTokens() async {
        if showSkeleton == nil {
            showSkeleton = true
        }
        try? await Task.sleep(for: .milliseconds(300))
        try? await TokenManager.shared.getPortfolioOverviewAndYourToken()
        tokens = type == .nft ? (TokenManager.shared.yourTokens?.nfts ?? []) : ([TokenManager.shared.tokenAda] + TokenManager.shared.normalTokens)
        showSkeleton = false
    }
}
