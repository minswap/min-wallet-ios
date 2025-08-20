import Foundation
import MinWalletAPI

@MainActor
class OrderHistoryFilterViewModel: ObservableObject {
    @Published
    var filterSourceSelected: OrderHistory.FilterSource?
    @Published
    var contractTypeSelected: ContractType?
    @Published
    var protocolSelected: AggregatorSource?
    @Published
    var statusSelected: OrderV2Status?
    @Published
    var actionSelected: OrderHistory.OrderType?
    @Published
    var fromDate: Date?
    @Published
    var toDate: Date?
    @Published
    var showSelectFromDate: Bool = false
    @Published
    var showSelectToDate: Bool = false
    
    init() {}
    
    func reset() {
        showSelectToDate = false
        showSelectFromDate = false
        filterSourceSelected = nil
        contractTypeSelected = nil
        protocolSelected = nil
        statusSelected = nil
        actionSelected = nil
        fromDate = nil
        toDate = nil
    }
    
    func bindData(vm: OrderHistoryViewModel) {
        let input = vm.input
        filterSourceSelected = input.filterSource
        statusSelected = input.status
        actionSelected = input.type
        protocolSelected = input.source
        fromDate = input.fromDateTimeInterval
        toDate = input.toDateTimeInterval
    }
    
    var countFilter: Int {
        [
            (fromDate != nil || toDate != nil) ? true : nil,
            contractTypeSelected,
            filterSourceSelected,
            protocolSelected,
            statusSelected,
            actionSelected,
        ]
        .compactMap { $0 }
        .count
    }
}
