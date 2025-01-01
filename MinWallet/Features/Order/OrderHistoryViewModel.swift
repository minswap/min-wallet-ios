import SwiftUI
import MinWalletAPI
import Combine


class OrderHistoryViewModel: ObservableObject {
    @Published
    var showSearch: Bool = false
    @Published
    var showFilterView: Bool = false
    @Published
    var keyword: String = ""
    @Published
    var orders: [OrderHistoryQuery.Data.Orders.Order] = []
    @Published
    var showSkeleton: Bool = true
    
    var input: OrderV2Input!
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        input = OrderV2Input.init(address: UserInfo.shared.minWallet?.address ?? "")
        
        $keyword
            .removeDuplicates()
            .debounce(for: .milliseconds(400),
                      scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.fetchData()
            })
            .store(in: &cancellables)
    }
    
    func fetchData() {
        Task {
            showSkeleton = true
            try? await Task.sleep(for: .seconds(2))
            let orderData = try? await MinWalletService.shared.fetch(query: OrderHistoryQuery(ordersInput2: input))
            self.orders = orderData?.orders.orders ?? []
            
            showSkeleton = false
        }
    }
}
