import Foundation

@MainActor
class HomeViewModel: ObservableObject {

    @Published
    var tabType: TokenListView.TabType = .market

    @Published
    var tokens: [TokenWithPrice] = []

    @Published
    var showSkeleton: Bool = true

    init() {}

    func getToken() async {
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        tokens = HomeView.tokens
        showSkeleton = false
    }
}
