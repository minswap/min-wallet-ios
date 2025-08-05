import Foundation
import Then
import SwiftUI
import MinWalletAPI


struct WrapOrderHistory: Then, Equatable, Identifiable {
    var id: String = ""
    var orders: [OrderHistory] = []
    
    //for load more
    var cursor: String? = nil
    
    //For UI
    var orderType: OrderHistory.OrderType = .swap
    
    var source: AggregatorSource? = .Minswap
    var input: OrderHistory.InputOutput?
    var output: OrderHistory.InputOutput?
    var inputAsset: [OrderHistory.InputOutput] = []
    var outputAsset: [OrderHistory.InputOutput] = []
    var status: OrderV2Status = .batched
    var percent: Double = 0
    
    init(orders: [OrderHistory] =  [.init(), .init(), .init()], key: String = "") {
        id = key
        cursor = orders.last?.id
        self.orders = orders.sorted(by: {
            ($0.status?.number ?? 0) < ($1.status?.number ?? 0)
        })
        
        status = {
            guard orders.count > 1 else { return orders.first?.status ?? .created }
            return orders.first { $0.status == .created } != nil ? .created : .batched
        }()
        
        orderType = orders.first?.detail.orderType ?? .swap
        source = orders.first?.aggregatorSource
        input = orders.first?.input
        output = orders.first?.output
        
        let inputs = Dictionary(grouping: orders.flatMap({ $0.inputAsset }), by: { $0.id })
        let outputs = Dictionary(grouping: orders.flatMap({ $0.outputAsset }), by: { $0.id })
        
        inputAsset = inputs.map({ (key, values) in
            let amount = values.map({ $0.amount }).reduce(0, +)
            let minimumAmount = values.map({ $0.minimumAmount }).reduce(0, +)
            return OrderHistory.InputOutput(asset: values.first?.asset, amount: amount, minimumAmount: minimumAmount)
        })
        outputAsset = outputs.map({ (key, values) in
            let amount = values.map({ $0.amount }).reduce(0, +)
            let minimumAmount = values.map({ $0.minimumAmount }).reduce(0, +)
            return OrderHistory.InputOutput(asset: values.first?.asset, amount: amount, minimumAmount: minimumAmount)
        })
        
        if orderType == .partialSwap && orders.count > 1 {
            let orderCompleted = orders.filter({ $0.status == .batched }).count
            percent = Double(orderCompleted) / Double(orders.count) * 100
        }
    }
}
