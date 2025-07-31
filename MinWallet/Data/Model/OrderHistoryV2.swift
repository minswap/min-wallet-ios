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

    init() { }
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
        case .swap, .limit, .stopLoss, .partialSwap, .oco:
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
            return "\(detail.inputAsset?.adaName ?? "") - \(detail.lpAsset?.adaName ?? "")"
        case .zapOut:
            return "\(detail.lpAsset?.adaName ?? "") - \(detail.receiveAsset?.adaName ?? "")"
        case .donation:
            return ""
        }
    }

    var inputAsset: [InputOutput] {
        switch detail.orderType {
        case .swap, .limit, .stopLoss, .partialSwap, .oco:
            switch detail.direction {
            case .aToB:
                return [InputOutput.init(asset: assetA, amount: detail.inputAmount)]
            case .bToA:
                return [InputOutput.init(asset: assetB, amount: detail.inputAmount)]
            default:
                return []
            }
        case .deposit:
            return [InputOutput(asset: assetA, amount: detail.depositAmountA), InputOutput(asset: assetB, amount: detail.depositAmountB)]
        case .withdraw:
            return [InputOutput(asset: detail.lpAsset, amount: detail.withdrawLpAmount)]
        case .zapIn:
            return [InputOutput(asset: detail.inputAsset, amount: detail.inputAmount)]
        case .zapOut:
            return [InputOutput(asset: detail.lpAsset, amount: detail.lpAmount)]
        case .donation:
            return []
        }
    }

    var outputAsset: [InputOutput] {
        switch detail.orderType {
        case .swap, .limit, .stopLoss, .partialSwap, .oco:
            switch detail.direction {
            case .aToB:
                return [InputOutput.init(asset: assetA, amount: detail.executedAmount)]
            case .bToA:
                return [InputOutput.init(asset: assetB, amount: detail.executedAmount)]
            default:
                return []
            }
        case .deposit:
            return [InputOutput(asset: detail.lpAsset, amount: detail.receiveLpAmount)]
        case .withdraw:
            return [InputOutput(asset: assetA, amount: detail.receiveAmountA), InputOutput(asset: assetB, amount: detail.receiveAmountB)]
        case .zapIn:
            return [InputOutput(asset: detail.lpAsset, amount: detail.receiveLpAmount)]
        case .zapOut:
            return [InputOutput(asset: detail.receiveAsset, amount: detail.receiveAmount)]
        case .donation:
            return []
        }
    }

    var tradingFeeAsset: InputOutput? {
        switch detail.orderType {
            case .swap, .limit, .stopLoss, .partialSwap, .oco:
                switch detail.direction {
                    case .aToB:
                        return detail.tradingFee > 0 ? InputOutput(asset: assetA, amount: detail.tradingFee) : nil
                    case .bToA:
                        return detail.tradingFee > 0 ? InputOutput(asset: assetB, amount: detail.tradingFee) : nil
                    default:
                        return nil
                }
            case .deposit:
                return nil
            case .withdraw:
                return nil
            case .zapIn:
                return detail.tradingFee > 0 ? InputOutput(asset: assetA, amount: detail.tradingFee) : nil
            case .zapOut:
                return detail.tradingFee > 0 ? InputOutput(asset: assetB, amount: detail.tradingFee) : nil
            case .donation:
                return nil
        }
    }

    var changeAmountAsset: InputOutput? {
        switch detail.orderType {
            case .swap, .limit, .stopLoss, .partialSwap, .oco:
                switch detail.direction {
                    case .aToB:
                        return detail.changeAmount > 0 ? InputOutput(asset: assetA, amount: detail.changeAmount) : nil
                    case .bToA:
                        return detail.changeAmount > 0 ? InputOutput(asset: assetB, amount: detail.changeAmount) : nil
                    default:
                        return nil
                }
            case .deposit:
                return nil
            case .withdraw:
                return nil
            case .zapIn:
                return detail.changeAmount > 0 ? InputOutput(asset: detail.inputAsset, amount: detail.changeAmount) : nil
            case .zapOut:
                return nil
            case .donation:
                return nil
        }
    }

    static let TYPE_SHOW_ROUTER: [OrderType] = [.swap, .limit, .stopLoss, .oco, .partialSwap]

    var isShowRouter: Bool {
        OrderHistory.TYPE_SHOW_ROUTER.contains(detail.orderType)
    }
}
