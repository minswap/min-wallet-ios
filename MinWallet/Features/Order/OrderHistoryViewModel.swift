import SwiftUI
import MinWalletAPI
import Combine

@MainActor
class OrderHistoryViewModel: ObservableObject {
    @Published
    var showSearch: Bool = false
    @Published
    var showFilterView: Bool = false
    @Published
    var keyword: String = ""
    @Published
    var orders: [OrderHistoryQuery.Data.Orders.WrapOrder] = []
    @Published
    var showSkeleton: Bool = true

    var input: OrderV2Input!
    private var cancellables: Set<AnyCancellable> = []

    init() {
        //input = OrderV2Input.init(address: UserInfo.shared.minWallet?.address ?? "")
        input = OrderV2Input.init(address: "addr_test1qzjd7yhl8d8aezz0spg4zghgtn7rx7zun7fkekrtk2zvw9vsxg93khf9crelj4wp6kkmyvarlrdvtq49akzc8g58w9cqhx3qeu")

        $keyword
            .removeDuplicates()
            .debounce(
                for: .milliseconds(400),
                scheduler: DispatchQueue.main
            )
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
            self.orders = orderData?.orders.orders.map({ OrderHistoryQuery.Data.Orders.WrapOrder(order: $0) }) ?? []

            showSkeleton = false
        }
    }
}
