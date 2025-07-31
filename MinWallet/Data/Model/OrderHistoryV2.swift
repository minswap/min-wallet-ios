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

struct OrderHistory: Then, Identifiable, Hashable {
    var id: String = ""
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
    var updatedAt: String?
    var updatedTxId: String?
    var aggregatorSource: AggregatorSource?
    
    var assetA: Asset = .init()
    var assetB: Asset = .init()
    var detail: Detail = .init()
    
    init() {}
}

extension OrderHistory: Mappable {
    init?(map: Map) {}
    
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
        aggregatorSource <- (
            map["aggregatorSource"],
            GKMapFromJSONToType(fromJSON: { json in
                guard let source = json as? String, !source.isEmpty else { return nil }
                return .init(rawId: source)
            })
        )
        assetA <- map["asset_a"]
        assetB <- map["asset_b"]
        detail <- map["details"]
    }
}


extension OrderHistory {
    var name: String {
        switch detail.orderType {
            case .swap, .limit,  .stopLoss, .partialSwap, .oco:
                switch detail.direction {
                    case .aToB:
                        return assetA.adaName + " - " + assetB.adaName
                    case .bToA:
                        return assetB.adaName + " - " + assetA.adaName
                    default:
                        return ""
                }
            case .deposit:
                return "\(assetA.adaName), \(assetB.adaName) - \(detail.lpAsset?.adaName ?? "")"
            case .withdraw:
                return "\(detail.lpAsset?.adaName ?? "") - \(assetA.adaName), \(assetB.adaName))"
            case .zapIn:
                return "\(assetA.adaName) - \(detail.lpAsset?.adaName ?? "")"
            case .zapOut:
                return "\(detail.lpAsset?.adaName ?? "") - \(assetA.adaName)"
            case .donation:
                return ""
        }
    }
    
    var inputAsset: Asset {
        detail.direction == .aToB ? assetA : assetB
    }
    
    var outputAsset: Asset {
        detail.direction == .aToB ? assetB : assetA
    }
    
    static let TYPE_SHOW_ROUTER: [OrderType] = [.swap, .limit, .stopLoss, .oco, .partialSwap]
    
    var isShowRouter: Bool {
        OrderHistory.TYPE_SHOW_ROUTER.contains(detail.orderType)
    }
}
