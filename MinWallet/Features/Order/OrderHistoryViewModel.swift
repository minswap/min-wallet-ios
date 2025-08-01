import SwiftUI
import MinWalletAPI
import Combine
import SwiftyJSON
import ObjectMapper
import Then


@MainActor
class OrderHistoryViewModel: ObservableObject {
    @Published
    var showSearch: Bool = false
    @Published
    var showFilterView: Bool = false
    @Published
    var showCancelOrder: Bool = false
    @Published
    var keyword: String = ""
    @Published
    var orders: [OrderHistory] = []
    @Published
    var showSkeleton: Bool = true
    
    private var cancellables: Set<AnyCancellable> = []
    
    var statusSelected: OrderV2Status?
    var orderType: OrderHistory.OrderType?
    var source: AggregatorSource?
    var fromDate: Date?
    var toDate: Date?
    
    private var pagination: Pagination = .init()
    
    var orderToCancel: OrderHistory? = nil
    
    init() {
        $keyword
            .removeDuplicates()
            .debounce(
                for: .milliseconds(400),
                scheduler: DispatchQueue.main
            )
            .sink(receiveValue: { [weak self] value in
                guard let self = self else { return }
                Task {
                    self.keyword = value
                    await self.fetchData()
                }
            })
            .store(in: &cancellables)
    }
    
    /// Fetches the latest order history data asynchronously, applying current filters and resetting pagination state.
    /// - Parameters:
    ///   - showSkeleton: Whether to display a loading skeleton during the fetch.
    ///   - fromPullToRefresh: Indicates if the fetch was triggered by a pull-to-refresh action.
    func fetchData(showSkeleton: Bool = true, fromPullToRefresh: Bool = false) async {
        withAnimation {
            self.showSkeleton = showSkeleton
        }
        if fromPullToRefresh {
            try? await Task.sleep(for: .seconds(1))
        }
        pagination = Pagination()
            .with({
                $0.isFetching = true
            })
        let orders = await getOrderHistory()
        let cursorID = orders.last?.id ?? ""
        pagination = pagination.with({
            $0.isFetching = false
            //$0.hasMore = orders.count >= pagination.limit
            $0.hasMore = !orders.isEmpty
            $0.cursor = cursorID.isEmpty ? nil : Int(cursorID)
        })
        
        self.orders = orders
        withAnimation {
            self.showSkeleton = false
        }
    }
    
    /// Loads additional order history data when the user scrolls near the end of the current list.
    /// - Parameter order: The order used to determine if more data should be loaded based on its position in the list.
    func loadMoreData(order: OrderHistory) {
        guard pagination.readyToLoadMore else { return }
        let thresholdIndex = orders.index(orders.endIndex, offsetBy: -5)
        if orders.firstIndex(where: { $0.id == order.id }) == thresholdIndex {
            Task {
                pagination = pagination.with({ $0.isFetching = true })
                let _orders = await getOrderHistory()
                
                self.orders += _orders
                let cursorID = _orders.last?.id ?? ""
                pagination = pagination.with({
                    $0.isFetching = false
                    //$0.hasMore = _orders.count >= pagination.limit
                    $0.hasMore = !_orders.isEmpty
                    $0.cursor = cursorID.isEmpty ? nil : Int(cursorID)
                })
            }
        }
    }
    
    var input: OrderHistory.Request {
        let address = UserInfo.shared.minWallet?.address ?? ""
        //let address = "addr_test1qzjd7yhl8d8aezz0spg4zghgtn7rx7zun7fkekrtk2zvw9vsxg93khf9crelj4wp6kkmyvarlrdvtq49akzc8g58w9cqhx3qeu"
        let keyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        //ce7c194517fc3d82569a2abff6b9ad93ea83b079016577cd5ac436ed6c6edeb2
        let isTxID = keyword.count == 64
        return OrderHistory.Request()
            .with({
                $0.ownerAddress = address
                $0.txId = !keyword.isBlank && isTxID ? keyword : nil
                $0.token = !keyword.isBlank && !isTxID ? keyword : nil
                $0.toTime = fromDate != nil ? String(Int(fromDate!.timeIntervalSince1970 * 1000)) : nil
                $0.status = statusSelected
                $0.source = source
                $0.type = orderType
                $0.toTime = toDate != nil ? String(toDate!.timeIntervalSince1970 * 1000 - 1) : nil
                $0.limit = pagination.limit
                $0.cursor = pagination.cursor
            })
    }
    
    /// Cancels the currently selected order asynchronously.
    /// 
    /// This method is currently disabled and contains only commented-out logic for order cancellation. When enabled, it would attempt to cancel the selected order and refresh the order history upon success.
    /// - Throws: An error if the cancellation process fails (when enabled).
    func cancelOrder() async throws {
        /*
        guard let order = orderToCancel else { return }
        let txId = order.createdTxId
        let txIndex = order.createdTxIndex
        let info = try await MinWalletService.shared.fetch(query: GetScriptUtxosQuery(txIns: [txId + "#\(txIndex)"]))
        let input: InputCancelBulkOrders = InputCancelBulkOrders(
            changeAddress: UserInfo.shared.minWallet?.address ?? "",
            orders: [InputCancelOrder(rawDatum: info?.getScriptUtxos?.first?.rawDatum ?? "", utxo: info?.getScriptUtxos?.first?.rawUtxo ?? "")],
            publicKey: UserInfo.shared.minWallet?.publicKey ?? "",
            type: order.order?.type.value == .dex ? .case(.orderV1) : .case(.orderV2AndStableswap))
        guard let txRaw = try await MinWalletService.shared.mutation(mutation: CancelBulkOrdersMutation(input: input)) else { throw AppGeneralError.localErrorLocalized(message: "Cancel order failed") }
        let _ = try await TokenManager.finalizeAndSubmit(txRaw: txRaw.cancelBulkOrders)
        await fetchData(showSkeleton: false)
        orderToCancel = nil
         */
    }
}

extension OrderHistory.Request {
    var fromDateTimeInterval: Date? {
        guard let fromDate = fromTime, !fromDate.isEmpty else { return nil }
        let fromDateTime = (Double(fromDate) ?? 0) / 1000
        return fromDateTime > 0 ? Date(timeIntervalSince1970: fromDateTime) : nil
    }
    
    var toDateTimeInterval: Date? {
        guard let toDate = toTime, !toDate.isEmpty else { return nil }
        let toDateTime = (Double(toDate) ?? 0) / 1000
        return toDateTime > 0 ? Date(timeIntervalSince1970: toDateTime) : nil
    }
}

extension OrderHistoryViewModel {
    /// Asynchronously fetches order history data using the current input filters.
    /// - Returns: An array of `OrderHistory` objects, or an empty array if the request fails or no data is found.
    private func getOrderHistory() async -> [OrderHistory] {
        do {
            let jsonData = try await OrderAPIRouter.getOrders(request: input).async_request()
            let order = Mapper<OrderHistory>().gk_mapArrayOrNull(JSONObject: JSON(jsonData)["orders"].arrayObject ?? [:])
            return order ?? []
        } catch {
            return []
        }
    }
}
extension OrderHistoryViewModel {
    struct Pagination: Then {
        var cursor: Int?
        var limit: Int = 20
        var hasMore: Bool = true
        var isFetching: Bool = false
        
        var readyToLoadMore: Bool {
            return !isFetching && hasMore
        }
        init() {}
        
        /// Resets the pagination state to its initial values, clearing the cursor and enabling further data loading.
        mutating func reset() {
            isFetching = false
            hasMore = true
            cursor = nil
        }
    }
}
