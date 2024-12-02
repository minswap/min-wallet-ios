import Foundation


class HomeViewModel: ObservableObject {
    
    @Published
    var address: String = ""
    @Published
    var accountName: String = ""
    @Published
    var tabType: TokenListView.TabType = .market
    
    init() {
        self.address = "Addrasdlfkjasdf12231123"
        self.accountName = "SassyCat"
    }
}
