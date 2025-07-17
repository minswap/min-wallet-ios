import Foundation
import MinWalletAPI

@MainActor
class OrderHistoryFilterViewModel: ObservableObject {
    @Published
    var contractTypeSelected: ContractType?
    //TODO: cuongnv check protocol
    @Published
    var protocolSelected: AggregatorSource?
    @Published
    var statusSelected: OrderV2Status?
    @Published
    var actionSelected: OrderV2Action?
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
        contractTypeSelected = nil
        protocolSelected = nil
        statusSelected = nil
        actionSelected = nil
        fromDate = nil
        toDate = nil
    }
    
    func bindData(vm: OrderHistoryViewModel) {
        let input = vm.input
        contractTypeSelected = input.ammType.unwrapped?.value
        statusSelected = input.status.unwrapped?.value
        actionSelected = input.action.unwrapped?.value
        fromDate = input.fromDateTimeInterval
        toDate = input.toDateTimeInterval
    }
}
