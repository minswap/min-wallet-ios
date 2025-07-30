import Foundation
import ObjectMapper
import Then
import MinWalletAPI

/*
public enum OrderV2Status: String, EnumType {
    case batched = "BATCHED"
    case cancelled = "CANCELLED"
    case created = "CREATED"
}
*/

struct OrderHistory: Then {
    var id: String = "11636247"
    var status: OrderV2Status?
    var createdTxId: String = ""
    var createdTxIndex: Int = 0
    var createdBlockId: String = ""
    var createdAt: String? = nil
    var batcherFee: Double = 0
    var depositAda: Double = 0
    var ownerAddress: String = ""
    var ownerIdent: String = ""
    //"2025-07-28T07:40:15.000Z"
    var updatedAt: String?  = nil
    var updatedTxId: String = ""
    var aggregatorSource: AggregatorSource? 
    
    init() {}
}

extension OrderHistory: Mappable {
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        id <- (map["id"], GKMapFromJSONToString)
        status <- map["status"]
        createdTxId <- map["created_tx_id"]
        createdTxIndex <- (map["created_tx_index"], GKMapFromJSONToInt)
        createdBlockId <- map["created_block_id"]
        createdAt <- map["created_at"]
        batcherFee <- (map["batcher_fee"], GKMapFromJSONToDouble)
        depositAda <- (map["deposit_ada"], GKMapFromJSONToDouble)
        ownerAddress <- map["owner_address"]
        ownerIdent <- map["owner_ident"]
        updatedAt <- map["updated_at"]
        updatedTxId <- map["updated_tx_id"]
        aggregatorSource <- (map["aggregatorSource"], GKMapFromJSONToType(fromJSON: { json in
            guard let source = json as? String, !source.isEmpty else { return nil }
            return .init(rawId: source)
        }))
    }
}
