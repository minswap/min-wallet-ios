import Foundation
import Then
import SwiftUI


struct WrapOrderHistory: Then, Equatable {
    var id: String = ""
    var orders: [OrderHistory] = []
    
    //for load more
    var cursor: String? = nil
    
    //For UI
    var name: String = ""
    var aggregatorSource: AggregatorSource? = .Minswap
    
    init(orders: [OrderHistory] = [], key: String) {
        id = key
        cursor = orders.last?.id
        self.orders = orders.sorted(by: {
            ($0.status?.number ?? 0) < ($1.status?.number ?? 0)
        })
        
        if let order = orders.first {
            name = order.detail.orderType.title.toString() + " " + (order.status?.title.toString() ?? "")
            aggregatorSource = order.aggregatorSource
        }
    }
}
