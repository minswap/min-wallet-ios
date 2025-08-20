import Foundation
import MinWalletAPI
import Then


extension OrderHistory {
    struct Request: Then {
        var ownerAddress: String = ""
        var filterSource: OrderHistory.FilterSource?
        var status: OrderV2Status?
        var source: AggregatorSource?
        var type: OrderType?
        var token: String?
        var txId: String?
        var fromTime: String?
        var toTime: String?
        var limit: Int = 20
        var cursor: Int?
        
        init() {}
    }
}
