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

    //Mapping UI
    var name: String = ""
    var inputAsset: [InputOutput] = []
    var outputAsset: [InputOutput] = []
    var tradingFeeAsset: InputOutput?
    var changeAmountAsset: InputOutput?

    //Show routing...
    var routing: String = ""
    var input: InputOutput?
    var output: InputOutput?

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
            map["protocol"],
            GKMapFromJSONToType(fromJSON: { json in
                guard let source = json as? String, !source.isEmpty else { return nil }
                return .init(rawId: source)
            })
        )
        assetA <- map["asset_a"]
        assetB <- map["asset_b"]
        detail <- map["details"]

        let totalAmountIn = max(detail.inputAmount, 1)
        detail.fillHistory = detail.fillHistory.compactMap({ inputOutput in
            switch detail.orderType {
            case .partialSwap:
                var percent = ((inputOutput.inputAmount / totalAmountIn) * 100)
                percent = Double(round(100 * percent) / 100)
                switch detail.direction {
                case .aToB:
                    return inputOutput.with {
                        $0.input = InputOutput(asset: assetA, amount: inputOutput.inputAmount)
                        $0.output = InputOutput(asset: assetB, amount: inputOutput.outputAmount)
                        $0.percent = percent
                    }
                case .bToA:
                    return inputOutput.with {
                        $0.input = InputOutput(asset: assetB, amount: inputOutput.inputAmount)
                        $0.output = InputOutput(asset: assetA, amount: inputOutput.outputAmount)
                        $0.percent = percent
                    }
                default:
                    return nil
                }
            default:
                return nil
            }
        })

        let tempPercents: Double = detail.fillHistory.map({ $0.percent }).dropLast().reduce(0, +)
        for (index, _) in detail.fillHistory.enumerated() where index == detail.fillHistory.count - 1 {
            detail.fillHistory[index].percent = 100 - tempPercents
        }

        mappingUI()
    }
}


extension OrderHistory {
    private mutating func mappingUI() {
        name = {
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
                return "\(detail.lpAsset?.adaName ?? "") - \(assetA.adaName), \(assetB.adaName)"
            case .zapIn:
                return "\(detail.inputAsset?.adaName ?? "") - \(detail.lpAsset?.adaName ?? "")"
            case .zapOut:
                return "\(detail.lpAsset?.adaName ?? "") - \(detail.receiveAsset?.adaName ?? "")"
            case .donation:
                return ""
            }
        }()

        inputAsset = {
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
        }()

        input = {
            switch detail.orderType {
            case .swap, .limit, .stopLoss, .partialSwap, .oco:
                switch detail.direction {
                case .aToB:
                    return InputOutput.init(asset: assetA, amount: detail.inputAmount)
                case .bToA:
                    return InputOutput.init(asset: assetB, amount: detail.inputAmount)
                default:
                    return nil
                }
            default:
                return nil
            }
        }()

        outputAsset = {
            switch detail.orderType {
            case .swap, .limit, .stopLoss, .partialSwap, .oco:
                switch detail.direction {
                case .aToB:
                    return [InputOutput.init(asset: assetB, amount: detail.executedAmount)]
                case .bToA:
                    return [InputOutput.init(asset: assetA, amount: detail.executedAmount)]
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
        }()

        output = {
            switch detail.orderType {
            case .swap, .limit, .stopLoss, .partialSwap, .oco:
                switch detail.direction {
                case .aToB:
                    return InputOutput.init(asset: assetB, amount: detail.executedAmount)
                case .bToA:
                    return InputOutput.init(asset: assetA, amount: detail.executedAmount)
                default:
                    return nil
                }
            default:
                return nil
            }
        }()

        tradingFeeAsset = {
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
        }()

        changeAmountAsset = {
            return detail.changeAmount > 0 ? InputOutput(asset: detail.isChangeAssetA ? assetA : assetB, amount: detail.changeAmount) : nil
        }()

        routing = detail.routes.flatMap({ $0.assets }).map({ $0.adaName }).joined(separator: " -> ")
    }

    static let TYPE_SHOW_ROUTER: [OrderType] = [.swap, .limit, .stopLoss, .oco, .partialSwap]

    var isShowRouter: Bool {
        OrderHistory.TYPE_SHOW_ROUTER.contains(detail.orderType)
    }
}
