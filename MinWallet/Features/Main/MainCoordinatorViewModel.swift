import SwiftUI
import FlowStacks


@MainActor
class MainCoordinatorViewModel: ObservableObject {
    @Published var routes: Routes<Screen> = []
    
    init() { }
}

extension MainCoordinatorViewModel {
    enum Screen: Hashable {
        case home
        case policy
        case gettingStarted
        case tokenDetail(token: Token)
        case about
        case language
    }
}
