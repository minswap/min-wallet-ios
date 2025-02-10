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
            "Partial swap"
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
                    let decimals: Int? = metaData?.decimals ?? 6

                    return OrderHistoryQuery.Data.Orders.WrapOrder.Detail.Token(
                        currencySymbol: currencySymbol,
                        tokenName: tokenName,
                        isVerified: isVerified,
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
                    let decimals: Int? = metaData?.decimals ?? 6

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
            detail.maxSwapTime = json["maxSwapTime"]["$bigint"].doubleValue
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
        var maxSwapTime: Double = 0
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
            let maxReceivableOutAmount = (Double(overSlippage.asSwapExactInOverSlippageDetail?.maxReceivableOut ?? "0") ?? 0) / pow(10.0, decimalsOut)
            attr = [
                AttributedString("Your attempt to swap ").build(),
                detail.inputs.first?.amount.formatNumberOrder(suffix: inputTicker),
                AttributedString(" could not be completed because the amount of ").build(),
                AttributedString(inputTicker).build(font: .paragraphXSemiSmall),
                AttributedString(" for ").build(),
                AttributedString(outputTicker).build(),
                AttributedString(" could not be completed because the amount of ").build(),
                AttributedString(outputTicker).build(),
                AttributedString(" available at the current rate ").build(),
                AttributedString("(").build(font: .paragraphXSemiSmall),
                currentAmount.formatNumberOrder(suffix: outputTicker + ")"),
                AttributedString(" is higher than the maximum amount the pool can offer ").build(),
                AttributedString("(").build(font: .paragraphXSemiSmall),
                maxReceivableOutAmount.formatNumberOrder(suffix: outputTicker + ")"),
                AttributedString(". This can occur due to changes in market prices or liquidity.").build(),
            ]
        case "SwapExactOutOverSlippageDetail":
            guard order.action.value != .oco else { return nil }
            if let maxReceivableOut = overSlippage.asSwapExactOutOverSlippageDetail?.maxReceivableOut?.toExact(decimal: decimalsOut), maxReceivableOut.isZero {
                attr = [
                    AttributedString("Your attempt to receive exactly ").build(),
                    detail.outputs.first?.satisfiedAmount.formatNumberOrder(suffix: outputTicker),
                    AttributedString(" for ").build(),
                    AttributedString(inputTicker).build(),
                    AttributedString(" could not be completed because the maximum amount the pool can offer at the current rate is ").build(),
                    maxReceivableOut.formatNumberOrder(suffix: outputTicker + "."),
                    AttributedString(". This can occur due to changes in market prices or liquidity.").build(),
                ]
            } else if let necessarySwapAmount = overSlippage.asSwapExactOutOverSlippageDetail?.necessarySwapAmount.toExact(decimal: decimalsOut) {
                if necessarySwapAmount < 0 {
                    attr = [
                        AttributedString("You're set to get more \(outputTicker) than what's currently in the pool's reserve.").build()
                    ]
                } else {
                    attr = [
                        AttributedString("Your attempt to receive exactly ").build(),
                        detail.outputs.first?.satisfiedAmount.formatNumberOrder(suffix: outputTicker),
                        AttributedString(" for \(inputTicker) could not be completed because the current rate ").build(),
                        necessarySwapAmount.formatNumberOrder(prefix: "(", suffix: inputTicker + ")"),
                        AttributedString(" requires more than the ").build(),
                        detail.inputs.first?.amount.formatNumberOrder(suffix: inputTicker),
                        AttributedString(" you intended to swap. This can occur due to changes in market prices or liquidity.").build(),
                    ]
                }
            }

        case "RoutingOverSlipageDetail":
            guard order.action.value != .oco else { return nil }
            let currentAmount = overSlippage.asRoutingOverSlipageDetail?.receivedAmount.toExact(decimal: decimalsOut)
            attr = [
                AttributedString("Your swap of ").build(),
                inputAmount.formatNumberOrder(suffix: outputTicker),
                AttributedString(" for \(outputTicker) could not be completed because the amount of \(outputTicker) available at the current rate ").build(),
                currentAmount?.formatNumberOrder(suffix: outputTicker),
                AttributedString(" is less than your minimum expected amount ").build(),
                detail.outputs.first?.satisfiedAmount.formatNumberOrder(suffix: outputTicker),
                AttributedString(". This can happen due to changes in market prices or liquidity.").build(),
            ]
        case "StopOverSlippageDetail":
            guard order.action.value != .oco else { return nil }
            let currentAmount = overSlippage.asStopOverSlippageDetail?.receivedAmount.toExact(decimal: decimalsOut)
            attr = [
                AttributedString("Your attempt to swap ").build(),
                inputAmount.formatNumberOrder(suffix: outputTicker),
                AttributedString(" for \(outputTicker) could not be completed because the amount of \(outputTicker) available at the current rate ").build(),
                currentAmount?.formatNumberOrder(suffix: outputTicker),
                AttributedString(" is greater than your stop amount ").build(),
                detail.outputs.first?.satisfiedAmount.formatNumberOrder(suffix: outputTicker),
                AttributedString(". This can happen due to changes in market prices or liquidity.").build(),
            ]
        case "OCOOverSlipageDetail":
            guard order.action.value == .oco else { return nil }
            let currentAmount = (Double(overSlippage.asOCOOverSlipageDetail?.receivedAmount ?? "0") ?? 0) / pow(10.0, Double(detail.outputs.first?.decimals ?? 0))
            let inputAmount = detail.inputs.first?.amount ?? 0
            attr = [
                AttributedString("Your attempt to swap ").build(),
                inputAmount.formatNumberOrder(suffix: inputTicker),
                AttributedString(" could not be completed because the amount of ").build(),
                AttributedString(outputTicker).build(font: .paragraphXSemiSmall),
                AttributedString(" available at the current rate ").build(),
                currentAmount.formatNumberOrder(suffix: outputTicker),
                AttributedString(" is greater than your stop amount ").build(),
                detail.outputs.first?.stopAmount.formatNumberOrder(suffix: outputTicker),
                AttributedString(" and less than your limit amount ").build(),
                detail.outputs.first?.limitAmount.formatNumberOrder(suffix: outputTicker),
                AttributedString(". This can occur due to changes in market prices or liquidity.").build(),
            ]

        case "PartialFillOverSlippageDetail":
            guard order.action.value == .partialSwap else { return nil }
            let swapableAmount = overSlippage.asPartialFillOverSlippageDetail?.swapableAmount.toExact(decimal: decimalsIn)
            attr = [
                AttributedString("Your attempt to partial swap at least ").build(),
                (detail.minimumAmountPerSwap / 1_000_000).formatNumberOrder(suffix: inputTicker),
                inputAmount.formatNumberOrder(suffix: inputTicker + "/ \(detail.maxSwapTime) times"),
                AttributedString(" for \(outputTicker) could not be completed because the executable amount of \(inputTicker) in the current rate ").build(),
                swapableAmount?.formatNumberOrder(prefix: "(", suffix: inputTicker),
                AttributedString(" is less than your minimum \(inputTicker) per swap ").build(),
                (detail.minimumAmountPerSwap / 1_000_000).formatNumberOrder(prefix: "(", suffix: inputTicker + ")"),
                AttributedString(". This can occur due to changes in market prices or liquidity.").build(),
            ]

        case "DepositOverSlippageDetail":
            guard order.action.value == .oco else { return nil }

            let currentAmount = overSlippage.asDepositOverSlippageDetail?.receivedLPAmount.toExact(decimal: decimalsOut)
            let inputATicker: String = detail.inputs.prefix(detail.inputs.count - 1).map { $0.currency }.joined(separator: ", ")
            let inputBTicker: String = detail.inputs.last?.currency ?? ""

            attr = [
                AttributedString("Your attempt to deposit \(inputATicker) and \(inputBTicker) to receive LP tokens could not be completed because the amount of LP tokens generated by the deposit, based on current rates ").build(),
                currentAmount?.formatNumberOrder(prefix: "(", suffix: "LP)"),
                AttributedString(" is less than your minimum expected amount ").build(),
                detail.outputs.first?.satisfiedAmount.formatNumberOrder(prefix: "(", suffix: "LP"),
                AttributedString(". This can occur due to changes in market prices or liquidity.").build(),
            ]
        case "ZapInOverSlippageDetail":
            guard order.action.value != .oco else { return nil }
            let currentAmount = overSlippage.asZapInOverSlippageDetail?.receivedLPAmount.toExact(decimal: decimalsOut)
            attr = [
                AttributedString("Your attempt to zap in \(inputTicker) to receive LP tokens could not be completed because the amount of LP tokens generated by the deposit based on current rates ").build(),
                currentAmount?.formatNumberOrder(prefix: "(", suffix: "LP)"),
                AttributedString(" is less than your minimum expected amount ").build(),
                detail.outputs.first?.satisfiedAmount.formatNumberOrder(prefix: "(", suffix: "LP"),
                AttributedString(". This can occur due to changes in market prices or liquidity.").build(),
            ]
        case "ZapOutOverSlippageDetail":
            guard order.action.value != .oco else { return nil }
            let currentAmount = overSlippage.asZapOutOverSlippageDetail?.receivedAmount.toExact(decimal: decimalsOut)
            attr = [
                AttributedString("Your attempt to zap out LP tokens to receive \(outputTicker) could not be completed because the amount of \(outputTicker) available based on current rates ").build(),
                currentAmount?.formatNumberOrder(prefix: "(", suffix: outputTicker + ")"),
                AttributedString(" is less than your minimum expected amount ").build(),
                detail.outputs.first?.satisfiedAmount.formatNumberOrder(prefix: "(", suffix: outputTicker + ")"),
                AttributedString(". This can occur due to changes in market prices or liquidity.").build(),
            ]
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
        roundingOffset: Int = 3
    ) -> AttributedString {
        self.formatNumber(prefix: prefix, suffix: suffix, roundingOffset: roundingOffset, font: .paragraphXSemiSmall, fontColor: .colorInteractiveToneWarning)
    }
}
