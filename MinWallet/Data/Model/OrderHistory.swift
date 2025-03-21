import SwiftUI
import Then
import MinWalletAPI
import SwiftyJSON


typealias ContractType = AMMType

extension OrderV2Action: @retroactive Identifiable {
    public var id: String { UUID().uuidString }

    var title: LocalizedStringKey {
        switch self {
        case .deposit:
            "Deposit"
        case .donation:
            "Donation"
        case .limit:
            "Limit"
        case .market:
            "Market"
        case .oco:
            "OCO"
        case .partialSwap:
            "Partial fill"
        case .stopLoss:
            "Stop loss"
        case .withdraw:
            "Withdraw"
        case .zapIn:
            "Zap in"
        case .zapOut:
            "Zap out"
        }
    }

    var titleFilter: LocalizedStringKey {
        switch self {
        case .deposit:
            "Deposit"
        case .limit:
            "Limit"
        case .market:
            "Market"
        case .oco:
            "OCO"
        case .partialSwap:
            "Partial Fill"
        case .stopLoss:
            "Stop"
        case .withdraw:
            "Withdraw"
        case .zapIn:
            "Zap in"
        case .zapOut:
            "Zap out"
        default:
            ""
        }
    }

    public init?(title: String) {
        switch title {
        case OrderV2Action.deposit.titleFilter.toString():
            self = .deposit
        case OrderV2Action.limit.titleFilter.toString():
            self = .limit
        case OrderV2Action.market.titleFilter.toString():
            self = .market
        case OrderV2Action.oco.titleFilter.toString():
            self = .oco
        case OrderV2Action.partialSwap.titleFilter.toString():
            self = .partialSwap
        case OrderV2Action.stopLoss.titleFilter.toString():
            self = .stopLoss
        case OrderV2Action.withdraw.titleFilter.toString():
            self = .withdraw
        case OrderV2Action.zapIn.titleFilter.toString():
            self = .zapIn
        case OrderV2Action.zapOut.titleFilter.toString():
            self = .zapOut
        default:
            self = .deposit
        }
    }
}

extension OrderV2Status: @retroactive Identifiable {
    public var id: String { UUID().uuidString }

    var title: LocalizedStringKey {
        switch self {
        case .batched:
            "Completed"
        case .cancelled:
            "Cancelled"
        case .created:
            "Pending"
        }
    }

    var foregroundColor: Color {
        switch self {
        case .batched:
            .colorInteractiveToneSuccess
        case .cancelled:
            .colorInteractiveToneDanger
        case .created:
            .colorInteractiveToneWarning
        }
    }

    var foregroundCircleColor: Color {
        switch self {
        case .batched:
            .colorInteractiveToneSuccessSub
        case .cancelled:
            .colorInteractiveToneDangerSub
        case .created:
            .colorInteractiveToneWarningSub
        }
    }

    var backgroundColor: Color {
        switch self {
        case .batched:
            .colorSurfaceSuccess
        case .cancelled:
            .colorSurfaceDanger
        case .created:
            .colorSurfaceWarningDefault
        }
    }

    public init?(title: String) {
        switch title {
        case OrderV2Status.created.title.toString():
            self = .created
        case OrderV2Status.cancelled.title.toString():
            self = .cancelled
        case OrderV2Status.batched.title.toString():
            self = .batched
        default:
            self = .batched
        }
    }
}

extension ContractType: @retroactive Identifiable {
    public var id: String { UUID().uuidString }

    var title: LocalizedStringKey {
        switch self {
        case .dex:
            "V1"
        case .dexV2:
            "V2"
        case .stableswap:
            "Stableswap"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .dex:
            .colorDecorativeYellowDefault
        case .dexV2:
            .colorBrandRiver
        case .stableswap:
            .colorDecorativeLeaf
        }
    }

    var foregroundColor: Color {
        switch self {
        case .dex:
            .colorDecorativeYellowSub
        case .dexV2:
            .colorDecorativeBrandSub
        case .stableswap:
            .colorDecorativeLeafSub
        }
    }
}

extension OrderHistoryQuery.Data.Orders {
    struct WrapOrder: Hashable, Identifiable {
        let id: UUID = UUID()
        var order: OrderHistoryQuery.Data.Orders.Order?
        var detail: Detail = .init()

        init(order: OrderHistoryQuery.Data.Orders.Order?) {
            self.order = order
            let json = JSON(parseJSON: order?.details ?? "")
            let linkedPools = order?.linkedPools ?? []

            func uniqueID(symbol: String?, name: String?) -> String {
                let symbol = symbol ?? ""
                let name = name ?? ""
                if symbol.isEmpty && name.isEmpty {
                    return ""
                }
                if symbol.isEmpty {
                    return name
                }
                if name.isEmpty {
                    return symbol
                }
                return symbol + "." + name
            }

            detail.isKillable = json["isKillable"].int
            detail.inputs = json["inputs"].arrayValue
                .map({ input in
                    let amount = input["amount"]["$bigint"].doubleValue
                    let asset = input["asset"]["$asset"].stringValue
                    let assetSplit = asset.split(separator: ".")
                    let currencySymbol = String(assetSplit.first ?? "")
                    let tokenName: String? = assetSplit.count > 1 ? String(assetSplit.last ?? "") : nil

                    let metaData: OrderHistoryQuery.Data.Orders.Order.LinkedPool.Asset.Metadata? = linkedPools.flatMap { $0.assets }.first { uniqueID(symbol: $0.currencySymbol, name: $0.tokenName) == asset }?.metadata
                    let isVerified: Bool? = metaData?.isVerified
                    let name: String = metaData?.ticker ?? UserInfo.TOKEN_NAME_DEFAULT[uniqueID(symbol: currencySymbol, name: tokenName)] ?? tokenName?.adaName ?? tokenName ?? ""
                    let uniqueIDzz = uniqueID(symbol: currencySymbol, name: tokenName)
                    let decimals: Int? = (uniqueIDzz == "lovelace" || uniqueIDzz.isEmpty) ? 6 : metaData?.decimals

                    return OrderHistoryQuery.Data.Orders.WrapOrder.Detail.Token(
                        currencySymbol: currencySymbol,
                        tokenName: tokenName,
                        isVerified: isVerified,
                        decimals: decimals,
                        amount: amount / pow(10.0, Double(decimals ?? 0)),
                        currency: currencySymbol == MinWalletConstant.lpToken ? "LP" : name)
                })
            detail.outputs = json["outputs"].arrayValue
                .map({ input in
                    let amount = input["executedAmount"]["$bigint"].doubleValue
                    let satisfiedAmount = input["satisfiedAmount"]["$bigint"].doubleValue
                    let limitAmount = input["limitAmount"]["$bigint"].doubleValue
                    let stopAmount = input["stopAmount"]["$bigint"].doubleValue
                    let asset = input["asset"]["$asset"].stringValue
                    let assetSplit = asset.split(separator: ".")
                    let currencySymbol = String(assetSplit.first ?? "")
                    let tokenName: String? = assetSplit.count > 1 ? String(assetSplit.last ?? "") : nil

                    let metaData: OrderHistoryQuery.Data.Orders.Order.LinkedPool.Asset.Metadata? = linkedPools.flatMap { $0.assets }.first { uniqueID(symbol: $0.currencySymbol, name: $0.tokenName) == asset }?.metadata
                    let isVerified: Bool? = metaData?.isVerified
                    let name: String = metaData?.ticker ?? UserInfo.TOKEN_NAME_DEFAULT[uniqueID(symbol: currencySymbol, name: tokenName)] ?? tokenName?.adaName ?? tokenName ?? ""

                    let uniqueIDzz = uniqueID(symbol: currencySymbol, name: tokenName)
                    let decimals: Int? = (uniqueIDzz == "lovelace" || uniqueIDzz.isEmpty) ? 6 : metaData?.decimals

                    return OrderHistoryQuery.Data.Orders.WrapOrder.Detail.Token(
                        currencySymbol: currencySymbol,
                        tokenName: tokenName,
                        isVerified: isVerified,
                        decimals: decimals,
                        amount: amount / pow(10.0, Double(currencySymbol == UserInfo.TOKEN_ADA ? 6 : (decimals ?? 0))),
                        satisfiedAmount: satisfiedAmount / pow(10.0, Double(decimals ?? 0)),
                        currency: currencySymbol == MinWalletConstant.lpToken ? "LP" : name,
                        limitAmount: limitAmount / pow(10.0, Double(uniqueID(symbol: currencySymbol, name: tokenName) == UserInfo.TOKEN_ADA ? 6 : (decimals ?? 0))),
                        stopAmount: stopAmount / pow(10.0, Double(uniqueID(symbol: currencySymbol, name: tokenName) == UserInfo.TOKEN_ADA ? 6 : (decimals ?? 0)))
                    )
                })
            detail.tradingFee = json["lpFees"].arrayValue
                .map({ input in
                    let amount = input["amount"]["$bigint"].doubleValue
                    let asset = input["asset"]["$asset"].stringValue
                    let assetSplit = asset.split(separator: ".")
                    let currencySymbol = String(assetSplit.first ?? "")
                    let tokenName: String? = assetSplit.count > 1 ? String(assetSplit.last ?? "") : nil
                    let assets = linkedPools.flatMap { $0.assets }
                    let lpAssets = linkedPools.compactMap { $0.lpAsset }
                    let isVerified: Bool? =
                        assets.first { ($0.currencySymbol + "." + $0.tokenName) == asset }?.metadata?.isVerified
                        ?? lpAssets.first { ($0.currencySymbol + "." + $0.tokenName) == asset }?.metadata?.isVerified

                    let metaData = assets.first { ($0.currencySymbol + "." + $0.tokenName) == asset }?.metadata
                    let lpMetaData = lpAssets.first { ($0.currencySymbol + "." + $0.tokenName) == asset }?.metadata

                    let name: String = metaData?.ticker ?? UserInfo.TOKEN_NAME_DEFAULT[uniqueID(symbol: currencySymbol, name: tokenName)] ?? tokenName?.adaName ?? tokenName ?? lpMetaData?.ticker ?? ""

                    let decimals: Int? =
                        assets.first { ($0.currencySymbol + "." + $0.tokenName) == asset }?.metadata?.decimals
                        ?? lpAssets.first { ($0.currencySymbol + "." + $0.tokenName) == asset }?.metadata?.decimals

                    return OrderHistoryQuery.Data.Orders.WrapOrder.Detail.Token(
                        currencySymbol: currencySymbol,
                        tokenName: tokenName,
                        isVerified: isVerified,
                        amount: amount / pow(10.0, Double(uniqueID(symbol: currencySymbol, name: tokenName) == UserInfo.TOKEN_ADA ? 6 : (decimals ?? 0))),
                        currency: name)
                })

            detail.changeAmount = json["change_amount"].arrayValue
                .map({ input in
                    let amount = input["amount"]["$bigint"].doubleValue
                    let asset = input["asset"]["$asset"].stringValue
                    let assetSplit = asset.split(separator: ".")
                    let currencySymbol = String(assetSplit.first ?? "")
                    let tokenName: String? = assetSplit.count > 1 ? String(assetSplit.last ?? "") : nil
                    let assets = linkedPools.flatMap { $0.assets }
                    let lpAssets = linkedPools.compactMap { $0.lpAsset }
                    let isVerified: Bool? =
                        assets.first { ($0.currencySymbol + "." + $0.tokenName) == asset }?.metadata?.isVerified
                        ?? lpAssets.first { ($0.currencySymbol + "." + $0.tokenName) == asset }?.metadata?.isVerified
                    let name: String =
                        assets.first { ($0.currencySymbol + "." + $0.tokenName) == asset }?.metadata?.ticker ?? tokenName?.adaName ?? tokenName
                        ?? lpAssets.first { ($0.currencySymbol + "." + $0.tokenName) == asset }?.metadata?.ticker ?? ""
                    let decimals: Int? =
                        assets.first { ($0.currencySymbol + "." + $0.tokenName) == asset }?.metadata?.decimals
                        ?? lpAssets.first { ($0.currencySymbol + "." + $0.tokenName) == asset }?.metadata?.decimals

                    return OrderHistoryQuery.Data.Orders.WrapOrder.Detail.Token(
                        currencySymbol: currencySymbol,
                        tokenName: tokenName,
                        isVerified: isVerified,
                        amount: amount / pow(10.0, Double(uniqueID(symbol: currencySymbol, name: tokenName) == UserInfo.TOKEN_ADA ? 6 : (decimals ?? 0))),
                        currency: currencySymbol == MinWalletConstant.lpToken ? "LP" : name)
                })

            let name = detail.inputs.map { $0.currency }.joined(separator: ", ") + " - " + detail.outputs.map({ $0.currency }).joined(separator: ",")
            detail.name = name
            detail.depositAda = json["depositAda"]["$bigint"].doubleValue
            detail.estimatedBatcherFee = json["maxBatcherFee"]["$bigint"].doubleValue
            detail.executedBatcherFee = json["executedBatcherFee"]["$bigint"].doubleValue
            if let routeA = detail.inputs.first?.currency, let routeB = detail.outputs.first?.currency, !routeA.isBlank, !routeB.isBlank {
                detail.routes = routeA + " > " + routeB
            }
            detail.minimumAmountPerSwap = json["minimumAmountPerSwap"]["$bigint"].doubleValue
            //TODO: maxHops or maxSwapTime
            detail.maxSwapTime = json["maxHops"].intValue
        }
    }
}

extension OrderHistoryQuery.Data.Orders.WrapOrder {
    struct Detail: Hashable {
        var name: String = ""
        ///ADA/1_000_000
        var depositAda: Double = 0
        ///ADA/1_000_000
        var estimatedBatcherFee: Double = 0
        ///ADA/1_000_000
        var executedBatcherFee: Double = 0
        var inputs: [Token] = []
        var outputs: [Token] = []
        var tradingFee: [Token] = []
        var changeAmount: [Token] = []
        var isKillable: Int?
        var routes: String = ""
        var minimumAmountPerSwap: Double = 0
        var maxSwapTime: Int = 0
    }
}

extension OrderHistoryQuery.Data.Orders.WrapOrder.Detail {
    struct Token: Hashable, Identifiable {
        var id: UUID = .init()
        var currencySymbol: String?
        var tokenName: String?
        var isVerified: Bool?
        var decimals: Int? = 0
        ///net receive
        var amount: Double = 0
        ///minimumReceive
        var satisfiedAmount: Double = 0
        var currency: String = ""
        var limitAmount: Double = 0
        var stopAmount: Double = 0
    }
}

extension OrderHistoryQuery.Data.Orders.WrapOrder {
    static let TYPE_SHOW_ROUTER: [OrderV2Action] = [OrderV2Action.market, .limit, .stopLoss, .oco, .partialSwap]

    var isShowRouter: Bool {
        guard let action = order?.action.value else { return false }
        return OrderHistoryQuery.Data.Orders.WrapOrder.TYPE_SHOW_ROUTER.contains(action)
    }

    var overSlippageWarning: AttributedString? {
        guard let order = order, let overSlippage = order.overSlippage else { return nil }

        let inputTicker: String = detail.inputs.first?.currency ?? ""
        let inputAmount: Double = detail.inputs.first?.amount ?? 0
        let decimalsIn: Double = Double(detail.inputs.first?.decimals ?? 0)
        //let outputAmount: Double = detail.outputs.first?.amount ?? 0
        let outputTicker: String = detail.outputs.first?.currency ?? ""
        let decimalsOut: Double = Double(detail.outputs.first?.decimals ?? 0)

        var attr: [AttributedString?] = []
        switch overSlippage.__typename {
        case "SwapExactInOverSlippageDetail":
            guard order.action.value != .oco else { return nil }
            let currentAmount = (Double(overSlippage.asSwapExactInOverSlippageDetail?.receivedAmount ?? "0") ?? 0) / pow(10.0, decimalsOut)
            /*Your attempt to swap 4 ADA for HOSKY could not be completed because the amount of HOSKY available at the current rate (39,848 HOSKY) is less than your minimum expected amount (46,620 HOSKY). This can occur due to changes in market prices or liquidity.*/
            attr = [
                AttributedString(key: "Your attempt to swap ").build(),
                detail.inputs.first?.amount.formatNumberOrder(suffix: inputTicker, roundingOffset: Int(decimalsIn)),
                AttributedString(key: " for ").build(),
                AttributedString(outputTicker).build(font: .paragraphXSemiSmall, color: .colorInteractiveToneWarning),
                AttributedString(key: " could not be completed because the amount of ").build(),
                AttributedString(outputTicker).build(font: .paragraphXSemiSmall, color: .colorInteractiveToneWarning),
                AttributedString(key: " available at the current rate ").build(),
                AttributedString("(").build(font: .paragraphXSemiSmall),
                currentAmount.formatNumberOrder(suffix: outputTicker + ")", roundingOffset: Int(decimalsOut)),
                AttributedString(key: " is less than your minimum expected amount ").build(),
                AttributedString("(").build(font: .paragraphXSemiSmall),
                detail.outputs.first?.satisfiedAmount.formatNumberOrder(suffix: outputTicker + ")", roundingOffset: Int(decimalsOut)),
                AttributedString(key: ". This can occur due to changes in market prices or liquidity.").build(),
            ]
        case "SwapExactOutOverSlippageDetail":
            guard order.action.value != .oco else { return nil }
            /*Your attempt to receive exactly 100 MIN for ADA could not be completed because the current rate (11 ADA) requires more than the 10 ADA you intended to swap. This can occur due to changes in market prices or liquidity.
              */
            if let maxReceivableOut = overSlippage.asSwapExactOutOverSlippageDetail?.maxReceivableOut?.toExact(decimal: decimalsOut), maxReceivableOut.isZero {
                attr = [
                    AttributedString(key: "Your attempt to receive exactly ").build(),
                    detail.outputs.first?.satisfiedAmount.formatNumberOrder(suffix: outputTicker, roundingOffset: Int(decimalsOut)),
                    AttributedString(key: " for ").build(),
                    AttributedString(inputTicker).build(font: .paragraphXSemiSmall, color: .colorInteractiveToneWarning),
                    AttributedString(key: " could not be completed because the maximum amount the pool can offer at the current rate is ").build(),
                    maxReceivableOut.formatNumberOrder(suffix: outputTicker + ".", roundingOffset: Int(decimalsOut)),
                    AttributedString(key: ". This can occur due to changes in market prices or liquidity.").build(),
                ]
            } else if let necessarySwapAmount = overSlippage.asSwapExactOutOverSlippageDetail?.necessarySwapAmount.toExact(decimal: decimalsOut) {
                if necessarySwapAmount < 0 {
                    attr = [
                        AttributedString(key: "You're set to get more ").build(),
                        AttributedString(outputTicker).build(font: .paragraphXSemiSmall, color: .colorInteractiveToneWarning),
                        AttributedString(key: " than what's currently in the pool's reserve.").build(),
                    ]
                } else {
                    attr = [
                        AttributedString(key: "Your attempt to receive exactly ").build(),
                        detail.outputs.first?.satisfiedAmount.formatNumberOrder(suffix: outputTicker, roundingOffset: Int(decimalsOut)),
                        AttributedString(key: " for ").build(),
                        AttributedString(inputTicker).build(font: .paragraphXSemiSmall, color: .colorInteractiveToneWarning),
                        AttributedString(key: "  could not be completed because the current rate ").build(),
                        necessarySwapAmount.formatNumberOrder(prefix: "(", suffix: inputTicker + ")", roundingOffset: Int(decimalsOut)),
                        AttributedString(key: " requires more than the ").build(),
                        detail.inputs.first?.amount.formatNumberOrder(suffix: inputTicker, roundingOffset: Int(decimalsIn)),
                        AttributedString(key: " you intended to swap. This can occur due to changes in market prices or liquidity.").build(),
                    ]
                }
            }

        case "RoutingOverSlipageDetail":
            guard order.action.value != .oco else { return nil }
            let currentAmount = overSlippage.asRoutingOverSlipageDetail?.receivedAmount.toExact(decimal: decimalsOut)
            attr = [
                AttributedString(key: "Your swap of ").build(),
                inputAmount.formatNumberOrder(suffix: inputTicker, roundingOffset: Int(decimalsIn)),
                AttributedString(key: " for ").build(),
                AttributedString(outputTicker).build(font: .paragraphXSemiSmall, color: .colorInteractiveToneWarning),
                AttributedString(key: " could not be completed because the amount of ").build(),
                AttributedString(outputTicker).build(font: .paragraphXSemiSmall, color: .colorInteractiveToneWarning),
                AttributedString(key: " available at the current rate ").build(),
                AttributedString(key: "(").build(),
                currentAmount?.formatNumberOrder(suffix: outputTicker, roundingOffset: Int(decimalsOut)),
                AttributedString(key: ")").build(),
                AttributedString(key: " is less than your minimum expected amount ").build(),
                detail.outputs.first?.satisfiedAmount.formatNumberOrder(suffix: outputTicker, roundingOffset: Int(decimalsOut)),
                AttributedString(key: ". This can happen due to changes in market prices or liquidity.").build(),
            ]
        case "StopOverSlippageDetail":
            guard order.action.value != .oco else { return nil }
            let currentAmount = overSlippage.asStopOverSlippageDetail?.receivedAmount.toExact(decimal: decimalsOut)
            attr = [
                AttributedString(key: "Your attempt to swap ").build(),
                inputAmount.formatNumberOrder(suffix: inputTicker, roundingOffset: Int(decimalsIn)),
                AttributedString(key: " for ").build(),
                AttributedString(outputTicker).build(font: .paragraphXSemiSmall, color: .colorInteractiveToneWarning),
                AttributedString(key: " could not be completed because the amount of ").build(),
                AttributedString(outputTicker).build(font: .paragraphXSemiSmall, color: .colorInteractiveToneWarning),
                AttributedString(key: " available at the current rate ").build(),
                AttributedString("(").build(),
                currentAmount?.formatNumberOrder(suffix: outputTicker, roundingOffset: Int(decimalsOut)),
                AttributedString(")").build(),
                AttributedString(key: " is greater than your stop amount ").build(),
                detail.outputs.first?.satisfiedAmount.formatNumberOrder(suffix: outputTicker, roundingOffset: Int(decimalsOut)),
                AttributedString(key: ". This can happen due to changes in market prices or liquidity.").build(),
            ]
        case "OCOOverSlipageDetail":
            guard order.action.value == .oco else { return nil }
            let currentAmount = (Double(overSlippage.asOCOOverSlipageDetail?.receivedAmount ?? "0") ?? 0) / pow(10.0, Double(detail.outputs.first?.decimals ?? 0))
            let inputAmount = detail.inputs.first?.amount ?? 0
            attr = [
                AttributedString(key: "Your attempt to swap ").build(),
                inputAmount.formatNumberOrder(suffix: inputTicker, roundingOffset: Int(decimalsIn)),
                AttributedString(key: " could not be completed because the amount of ").build(),
                AttributedString(outputTicker).build(font: .paragraphXSemiSmall),
                AttributedString(key: " available at the current rate ").build(),
                currentAmount.formatNumberOrder(suffix: outputTicker, roundingOffset: Int(decimalsOut)),
                AttributedString(key: " is greater than your stop amount ").build(),
                detail.outputs.first?.stopAmount.formatNumberOrder(suffix: outputTicker, roundingOffset: Int(decimalsOut)),
                AttributedString(key: " and less than your limit amount ").build(),
                detail.outputs.first?.limitAmount.formatNumberOrder(suffix: outputTicker, roundingOffset: Int(decimalsOut)),
                AttributedString(key: ". This can occur due to changes in market prices or liquidity.").build(),
            ]

        case "PartialFillOverSlippageDetail":
            guard order.action.value == .partialSwap else { return nil }
            let swapableAmount = overSlippage.asPartialFillOverSlippageDetail?.swapableAmount.toExact(decimal: decimalsIn)
            attr = [
                AttributedString(key: "Your attempt to partial swap at least ").build(),
                detail.minimumAmountPerSwap.toExact(decimal: decimalsIn).formatNumberOrder(suffix: inputTicker, roundingOffset: Int(decimalsIn)),
                AttributedString(" ").build(),
                AttributedString("(").build(font: .paragraphXSemiSmall),
                inputAmount.formatNumberOrder(suffix: inputTicker + "/ \(detail.maxSwapTime) times", roundingOffset: Int(decimalsIn)),
                AttributedString(")").build(font: .paragraphXSemiSmall),
                AttributedString(key: " for ").build(),
                AttributedString(outputTicker).build(font: .paragraphXSemiSmall, color: .colorInteractiveToneWarning),
                AttributedString(key: " could not be completed because the executable amount of ").build(),
                AttributedString(inputTicker).build(font: .paragraphXSemiSmall, color: .colorInteractiveToneWarning),
                AttributedString(key: " in the current rate ").build(),
                swapableAmount?.formatNumberOrder(prefix: "(", suffix: inputTicker, roundingOffset: Int(decimalsIn)),
                AttributedString(")").build(font: .paragraphXSemiSmall),
                AttributedString(key: " is less than your minimum ").build(),
                AttributedString(inputTicker).build(font: .paragraphXSemiSmall, color: .colorInteractiveToneWarning),
                AttributedString(key: " per swap ").build(),
                detail.minimumAmountPerSwap.toExact(decimal: decimalsIn).formatNumberOrder(prefix: "(", suffix: inputTicker + ")", roundingOffset: Int(decimalsIn)),
                AttributedString(key: ". This can occur due to changes in market prices or liquidity.").build(),
            ]

        case "DepositOverSlippageDetail":
            guard order.action.value != .oco else { return nil }

            let currentAmount = overSlippage.asDepositOverSlippageDetail?.receivedLPAmount.toExact(decimal: decimalsOut)
            let inputATicker: String = detail.inputs.prefix(detail.inputs.count - 1).map { $0.currency }.joined(separator: ", ")
            let inputBTicker: String = detail.inputs.last?.currency ?? ""

            attr = [
                AttributedString(key: "Your attempt to deposit ").build(),
                AttributedString(inputATicker).build(font: .paragraphXSemiSmall, color: .colorInteractiveToneWarning),
                AttributedString(key: " and ").build(),
                AttributedString(inputBTicker).build(font: .paragraphXSemiSmall, color: .colorInteractiveToneWarning),
                AttributedString(key: " to receive LP tokens could not be completed because the amount of LP tokens generated by the deposit, based on current rates ").build(),
                currentAmount?.formatNumberOrder(prefix: "(", suffix: "LP)", roundingOffset: Int(decimalsOut)),
                AttributedString(key: " is less than your minimum expected amount ").build(),
                detail.outputs.first?.satisfiedAmount.formatNumberOrder(prefix: "(", suffix: "LP", roundingOffset: Int(decimalsOut)),
                AttributedString(key: ". This can occur due to changes in market prices or liquidity.").build(),
            ]
        case "ZapInOverSlippageDetail":
            guard order.action.value != .oco else { return nil }
            let currentAmount = overSlippage.asZapInOverSlippageDetail?.receivedLPAmount.toExact(decimal: decimalsOut)
            attr = [
                AttributedString("Your attempt to zap in ").build(),
                AttributedString(inputTicker).build(font: .paragraphXSemiSmall, color: .colorInteractiveToneWarning),
                AttributedString(key: " to receive LP tokens could not be completed because the amount of LP tokens generated by the deposit based on current rates ").build(),
                currentAmount?.formatNumberOrder(prefix: "(", suffix: "LP)", roundingOffset: Int(decimalsOut)),
                AttributedString(key: " is less than your minimum expected amount ").build(),
                detail.outputs.first?.satisfiedAmount.formatNumberOrder(prefix: "(", suffix: "LP)", roundingOffset: Int(decimalsOut)),
                AttributedString(key: ". This can occur due to changes in market prices or liquidity.").build(),
            ]
        case "ZapOutOverSlippageDetail":
            guard order.action.value != .oco else { return nil }
            let currentAmount = overSlippage.asZapOutOverSlippageDetail?.receivedAmount.toExact(decimal: decimalsOut)
            attr = [
                AttributedString(key: "Your attempt to zap out LP tokens to receive ").build(),
                AttributedString(outputTicker).build(font: .paragraphXSemiSmall, color: .colorInteractiveToneWarning),
                AttributedString(key: " could not be completed because the amount of ").build(),
                AttributedString(outputTicker).build(font: .paragraphXSemiSmall, color: .colorInteractiveToneWarning),
                AttributedString(key: " available based on current rates ").build(),
                currentAmount?.formatNumberOrder(prefix: "(", suffix: outputTicker + ")", roundingOffset: Int(decimalsOut)),
                AttributedString(key: " is less than your minimum expected amount ").build(),
                detail.outputs.first?.satisfiedAmount.formatNumberOrder(prefix: "(", suffix: outputTicker + ")", roundingOffset: Int(decimalsOut)),
                AttributedString(key: ". This can occur due to changes in market prices or liquidity.").build(),
            ]
        case "WithdrawOverSlippageDetail":
            let outputTickers: [AttributedString] = detail.outputs.enumerated()
                .compactMap({ (index, token) in
                    if detail.outputs.count > 1 && index != detail.outputs.count - 1 {
                        return AttributedString(token.currency).build(font: .paragraphXSemiSmall, color: .colorInteractiveToneWarning) + AttributedString(key: " and ").build()
                    } else {
                        return AttributedString(token.currency).build(font: .paragraphXSemiSmall, color: .colorInteractiveToneWarning)
                    }
                })

            let receivedAmounts = order.overSlippage?.asWithdrawOverSlippageDetail?.receivedAmounts ?? []

            let rates: [AttributedString] = receivedAmounts.enumerated()
                .compactMap({ (index, amount) in
                    guard let output = detail.outputs[gk_safeIndex: index] else { return nil }
                    if receivedAmounts.count > 1 && index != receivedAmounts.count - 1 {
                        return amount.toExact(decimal: Double(output.decimals ?? 0)).formatNumberOrder(suffix: output.currency, roundingOffset: output.decimals ?? 0) + AttributedString(key: " and ").build()
                    } else {
                        return amount.toExact(decimal: Double(output.decimals ?? 0)).formatNumberOrder(suffix: output.currency, roundingOffset: output.decimals ?? 0)
                    }
                })

            attr = [
                AttributedString(key: "Your attempt to withdraw LP tokens to receive ").build()
            ]
            attr.append(contentsOf: outputTickers)
            attr.append(AttributedString(" could not be completed because the amounts of ").build())
            attr.append(contentsOf: outputTickers)
            attr.append(AttributedString(" available based on current rates ").build())
            attr.append(contentsOf: rates)
            attr.append(AttributedString(")").build())
            attr.append(AttributedString(key: " are less than your minimum expected amounts ").build())
            attr.append(AttributedString("(").build())
            let satisfiedAmount: [AttributedString] = detail.outputs.enumerated()
                .compactMap({ (index, token) in
                    if detail.outputs.count > 1 && index != detail.outputs.count - 1 {
                        return token.satisfiedAmount.toExact(decimal: Double(token.decimals ?? 0)).formatNumberOrder(suffix: token.currency, roundingOffset: token.decimals ?? 0) + AttributedString(key: " and ").build()
                    } else {
                        return token.satisfiedAmount.toExact(decimal: Double(token.decimals ?? 0)).formatNumberOrder(suffix: token.currency, roundingOffset: token.decimals ?? 0)
                    }
                })
            attr.append(contentsOf: satisfiedAmount)
            attr.append(AttributedString(")").build())
            attr.append(AttributedString(key: ". This can occur due to changes in market prices or liquidity.").build())
        default:
            return nil
        }

        attr = attr.compactMap { $0 }
        var raw = AttributedString()
        attr.forEach { r in
            guard let r = r else { return }
            raw += r
        }
        return raw
    }
}

extension AttributedString {
    //paragraphXSemiSmall
    func build(font: Font = .paragraphXSmall, color: Color = .colorInteractiveToneWarning) -> AttributedString {
        var attribute = self
        attribute.font = font
        attribute.foregroundColor = color
        return attribute
    }
}

fileprivate extension Double {
    func formatNumberOrder(
        prefix: String = "",
        suffix: String = "",
        roundingOffset: Int
    ) -> AttributedString {
        self.formatNumber(prefix: prefix, suffix: suffix, roundingOffset: roundingOffset, font: .paragraphXSemiSmall, fontColor: .colorInteractiveToneWarning)
    }
}

extension AttributedString {
    init(key: LocalizedStringKey) {
        self.init(key.toString())
    }
}
