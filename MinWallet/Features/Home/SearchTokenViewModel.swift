import SwiftUI


@MainActor
class SearchTokenViewModel: ObservableObject {
    @Published
    var tokens: [TokenWithPrice] = HomeView.tokens
    @Published
    var isDeleted: [Bool] = []
    @Published
    var offsets: [CGFloat] = []

    init() {
        tokens = HomeView.tokens
        isDeleted = tokens.map({ _ in false })
        offsets = tokens.map({ _ in 0 })
    }
}
