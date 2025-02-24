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
    var showCancelOrder: Bool = false
    @Published
    var keyword: String = ""
    @Published
    var orders: [OrderHistoryQuery.Data.Orders.WrapOrder] = []
    @Published
    var showSkeleton: Bool = true

    private var cancellables: Set<AnyCancellable> = []

    var contractTypeSelected: ContractType?
    var statusSelected: OrderV2Status?
    var actionSelected: OrderV2Action?
    var fromDate: Date?
    var toDate: Date?

    private var pagination: OrderPaginationCursorInput?
    private var hasLoadMore: Bool = true

    var orderToCancel: OrderHistoryQuery.Data.Orders.WrapOrder? = nil

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

    func fetchData(showSkeleton: Bool = true) async {
        self.showSkeleton = showSkeleton
        pagination = nil
        let orderData = try? await MinWalletService.shared.fetch(query: OrderHistoryQuery(ordersInput2: input))
        self.orders = orderData?.orders.orders.map({ OrderHistoryQuery.Data.Orders.WrapOrder(order: $0) }) ?? []
        self.hasLoadMore = !(orderData?.orders.orders ?? []).isEmpty
        if let cursor = orderData?.orders.cursor {
            self.pagination = OrderPaginationCursorInput(stableswap: .some(cursor.stableswap ?? "0"), v1: .some(cursor.v1 ?? "0"), v2: .some(cursor.v2 ?? "0"))
        }
        self.showSkeleton = false
    }

    func loadMoreData(order: OrderHistoryQuery.Data.Orders.WrapOrder) {
        guard hasLoadMore else { return }
        let thresholdIndex = orders.index(orders.endIndex, offsetBy: -5)
        if orders.firstIndex(of: order) == thresholdIndex {
            Task {
                let orderData = try? await MinWalletService.shared.fetch(query: OrderHistoryQuery(ordersInput2: input))
                let _orders = orderData?.orders.orders.map({ OrderHistoryQuery.Data.Orders.WrapOrder(order: $0) }) ?? []

                self.orders += _orders
                self.hasLoadMore = !_orders.isEmpty
                if let cursor = orderData?.orders.cursor {
                    self.pagination = OrderPaginationCursorInput(stableswap: .some(cursor.stableswap ?? "0"), v1: .some(cursor.v1 ?? "0"), v2: .some(cursor.v2 ?? "0"))
                }
            }
        }
    }

    var input: OrderV2Input {
        let address = UserInfo.shared.minWallet?.address ?? ""
        //let address = "addr_test1qzjd7yhl8d8aezz0spg4zghgtn7rx7zun7fkekrtk2zvw9vsxg93khf9crelj4wp6kkmyvarlrdvtq49akzc8g58w9cqhx3qeu"
        let keyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        //ce7c194517fc3d82569a2abff6b9ad93ea83b079016577cd5ac436ed6c6edeb2
        let isTxID = keyword.count == 64
        return OrderV2Input(
            action: actionSelected != nil ? .some(.case(actionSelected!)) : nil,
            address: address,
            ammType: contractTypeSelected != nil ? .some(.case(contractTypeSelected!)) : nil,
            asset: !keyword.isBlank && !isTxID ? .some(keyword) : nil,
            fromDate: fromDate != nil ? .some(String(Int(fromDate!.timeIntervalSince1970 * 1000))) : nil,
            pagination: pagination != nil ? .some(pagination!) : nil,
            status: statusSelected != nil ? .some(.case(statusSelected!)) : nil,
            toDate: toDate != nil ? .some(String(toDate!.timeIntervalSince1970 * 1000)) : nil,
            txId: !keyword.isBlank && isTxID ? .some(keyword) : nil
        )
    }

    func cancelOrder() async throws {
        guard let order = orderToCancel else { return }
        let txId = order.order?.txIn.txId ?? ""
        let txIndex = order.order?.txIn.txIndex ?? 0
        let info = try await MinWalletService.shared.fetch(query: GetScriptUtxosQuery(txIns: [txId + "#\(txIndex)"]))
        let input: InputCancelBulkOrders = InputCancelBulkOrders(
            changeAddress: UserInfo.shared.minWallet?.address ?? "",
            orders: [InputCancelOrder(rawDatum: info?.getScriptUtxos?.first?.rawDatum ?? "", utxo: info?.getScriptUtxos?.first?.rawUtxo ?? "")],
            type: order.order?.type.value == .dex ? .case(.orderV1) : .case(.orderV2AndStableswap))
        guard let txRaw = try await MinWalletService.shared.mutation(mutation: CancelBulkOrdersMutation(input: input)) else { throw AppGeneralError.localErrorLocalized(message: "Cancel order failed") }
        let _ = try await TokenManager.finalizeAndSubmit(txRaw: txRaw.cancelBulkOrders)
        await fetchData(showSkeleton: false)
        orderToCancel = nil
    }
}

extension OrderV2Input {
    var fromDateTimeInterval: Date? {
        guard let fromDate = fromDate.unwrapped, !fromDate.isEmpty else { return nil }
        let fromDateTime = (Double(fromDate) ?? 0) / 1000
        return fromDateTime > 0 ? Date(timeIntervalSince1970: fromDateTime) : nil
    }

    var toDateTimeInterval: Date? {
        guard let toDate = toDate.unwrapped, !toDate.isEmpty else { return nil }
        let toDateTime = (Double(toDate) ?? 0) / 1000
        return toDateTime > 0 ? Date(timeIntervalSince1970: toDateTime) : nil
    }
}
