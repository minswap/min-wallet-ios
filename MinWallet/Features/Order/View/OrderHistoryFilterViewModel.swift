import Foundation
import MinWalletAPI

@MainActor
class OrderHistoryFilterViewModel: ObservableObject {
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
    
    /// Resets all filter criteria and date selection states to their default values.
    func reset() {
        showSelectToDate = false
        showSelectFromDate = false
        contractTypeSelected = nil
        protocolSelected = nil
        statusSelected = nil
        actionSelected = nil
        fromDate = nil
        toDate = nil
    }
    
    /// Updates the filter properties based on the input values from the provided `OrderHistoryViewModel`.
    /// - Parameter vm: The view model whose input values are used to update the filter state.
    func bindData(vm: OrderHistoryViewModel) {
        let input = vm.input
        statusSelected = input.status
        actionSelected = input.type
        protocolSelected = input.source
        fromDate = input.fromDateTimeInterval
        toDate = input.toDateTimeInterval
    }
}
