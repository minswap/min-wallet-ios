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
    var wrapOrders: [WrapOrderHistory] = []
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
        let cursorID = orders.last?.cursor ?? ""
        pagination = pagination.with({
            $0.isFetching = false
            //$0.hasMore = orders.count >= pagination.limit
            $0.hasMore = !orders.isEmpty
            $0.cursor = cursorID.isEmpty ? nil : Int(cursorID)
        })
        
        self.wrapOrders = orders
        withAnimation {
            self.showSkeleton = false
        }
    }
    
    func loadMoreData(order: WrapOrderHistory) {
        guard pagination.readyToLoadMore else { return }
        let thresholdIndex = wrapOrders.index(wrapOrders.endIndex, offsetBy: -5)
        if wrapOrders.firstIndex(where: { $0.id == order.id }) == thresholdIndex {
            Task {
                pagination = pagination.with({ $0.isFetching = true })
                let _orders = await getOrderHistory()
                
                self.wrapOrders += _orders
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
//        let address = UserInfo.shared.minWallet?.address ?? ""
        let address = "addr1q8rzzzrr58pa85p2ca8sxxgptf6sdtcxp2drx8cg4lxqml5w3z9f2vttuvt48p3ddxq74x95gh8ngwqsddk5nsmrfkwqjkwhpt"
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
    
    //TODO: cuongnv
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
    private func getOrderHistory() async -> [WrapOrderHistory] {
        do {
            let jsonData = try await OrderAPIRouter.getOrders(request: input).async_request()
            let orders = Mapper<OrderHistory>().gk_mapArrayOrNull(JSONObject: JSON(jsonData)["orders"].arrayObject ?? [:]) ?? []
            let groupedOrders = Dictionary(grouping: orders, by: { $0.keyToGroup })
            let wrapOrders = groupedOrders.map({ key,  orders in
                return WrapOrderHistory(orders: orders, key: key)
            })
            return wrapOrders
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
        
        mutating func reset() {
            isFetching = false
            hasMore = true
            cursor = nil
        }
    }
}
