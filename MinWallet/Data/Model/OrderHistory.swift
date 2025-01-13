import SwiftUI
import Then
import MinWalletAPI
import SwiftyJSON


typealias ContractType = AMMType

extension OrderV2Action: Identifiable {
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

extension OrderV2Status: Identifiable {
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

extension ContractType: Identifiable {
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
            .colorDecorativeBrandSub
        case .dexV2:
            .colorDecorativeYellowSub
        case .stableswap:
            .colorDecorativeLeafSub
        }
    }
}

extension OrderHistoryQuery.Data.Orders {
    struct WrapOrder: Hashable {
        var order: OrderHistoryQuery.Data.Orders.Order?
        var detail: Detail = .init()

        init(order: OrderHistoryQuery.Data.Orders.Order?) {
            self.order = order
            let json = JSON(parseJSON: order?.details ?? "")
            let linkedPools = order?.linkedPools ?? []

            detail.isKillable = json["isKillable"].int
            detail.inputs = json["inputs"].arrayValue
                .map({ input in
                    let amount = input["amount"]["$bigint"].doubleValue
                    let asset = input["asset"]["$asset"].stringValue
                    let assetSplit = asset.split(separator: ".")
                    let currencySymbol = String(assetSplit.first ?? "")
                    let tokenName: String? = assetSplit.count > 1 ? String(assetSplit.last ?? "") : nil

                    let metaData: OrderHistoryQuery.Data.Orders.Order.LinkedPool.Asset.Metadata? = linkedPools.flatMap { $0.assets }.first { ($0.currencySymbol + "." + $0.tokenName) == asset }?.metadata

                    let isVerified: Bool? = metaData?.isVerified
                    let name: String? = metaData?.ticker ?? tokenName?.adaName ?? tokenName ?? "ADA"
                    let decimals: Int? = metaData?.decimals ?? 6

                    return OrderHistoryQuery.Data.Orders.WrapOrder.Detail.Token(
                        currencySymbol: currencySymbol,
                        tokenName: tokenName,
                        isVerified: isVerified,
                        amount: amount / pow(10.0, Double(decimals ?? 0)),
                        currency: name ?? "")
                })
            detail.outputs = json["outputs"].arrayValue
                .map({ input in
                    let amount = input["executedAmount"]["$bigint"].doubleValue
                    let satisfiedAmount = input["satisfiedAmount"]["$bigint"].doubleValue
                    let asset = input["asset"]["$asset"].stringValue
                    let assetSplit = asset.split(separator: ".")
                    let currencySymbol = String(assetSplit.first ?? "")
                    let tokenName: String? = assetSplit.count > 1 ? String(assetSplit.last ?? "") : nil

                    let metaData: OrderHistoryQuery.Data.Orders.Order.LinkedPool.Asset.Metadata? = linkedPools.flatMap { $0.assets }.first { ($0.currencySymbol + "." + $0.tokenName) == asset }?.metadata

                    let isVerified: Bool? = metaData?.isVerified
                    let name: String? = metaData?.ticker ?? tokenName?.adaName ?? tokenName ?? "ADA"
                    let decimals: Int? = metaData?.decimals ?? 6


                    return OrderHistoryQuery.Data.Orders.WrapOrder.Detail.Token(
                        currencySymbol: currencySymbol,
                        tokenName: tokenName,
                        isVerified: isVerified,
                        amount: amount / pow(10.0, Double(decimals ?? 0)),
                        satisfiedAmount: satisfiedAmount / pow(10.0, Double(decimals ?? 0)),
                        currency: name ?? "")
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
                    let name: String? =
                        assets.first { ($0.currencySymbol + "." + $0.tokenName) == asset }?.metadata?.ticker ?? tokenName?.adaName ?? tokenName
                        ?? lpAssets.first { ($0.currencySymbol + "." + $0.tokenName) == asset }?.metadata?.ticker
                    let decimals: Int? =
                        assets.first { ($0.currencySymbol + "." + $0.tokenName) == asset }?.metadata?.decimals
                        ?? lpAssets.first { ($0.currencySymbol + "." + $0.tokenName) == asset }?.metadata?.decimals

                    return OrderHistoryQuery.Data.Orders.WrapOrder.Detail.Token(
                        currencySymbol: currencySymbol,
                        tokenName: tokenName,
                        isVerified: isVerified,
                        amount: amount / pow(10.0, Double(decimals ?? 0)),
                        currency: name ?? "")
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
                    let name: String? =
                        assets.first { ($0.currencySymbol + "." + $0.tokenName) == asset }?.metadata?.ticker ?? tokenName?.adaName ?? tokenName
                        ?? lpAssets.first { ($0.currencySymbol + "." + $0.tokenName) == asset }?.metadata?.ticker
                    let decimals: Int? =
                        assets.first { ($0.currencySymbol + "." + $0.tokenName) == asset }?.metadata?.decimals
                        ?? lpAssets.first { ($0.currencySymbol + "." + $0.tokenName) == asset }?.metadata?.decimals

                    return OrderHistoryQuery.Data.Orders.WrapOrder.Detail.Token(
                        currencySymbol: currencySymbol,
                        tokenName: tokenName,
                        isVerified: isVerified,
                        amount: amount / pow(10.0, Double(decimals ?? 0)),
                        currency: name ?? "")
                })

            let name = detail.inputs.map { $0.currency }.joined(separator: ", ") + " - " + detail.outputs.map({ $0.currency }).joined(separator: ",")
            detail.name = name
            detail.depositAda = json["depositAda"]["$bigint"].doubleValue
            detail.estimatedBatcherFee = json["maxBatcherFee"]["$bigint"].doubleValue
            detail.executedBatcherFee = json["executedBatcherFee"]["$bigint"].doubleValue
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
        //TODO: route
    }
}

extension OrderHistoryQuery.Data.Orders.WrapOrder.Detail {
    struct Token: Hashable, Identifiable {
        var id: UUID = .init()
        var currencySymbol: String?
        var tokenName: String?
        var isVerified: Bool?
        ///net receive
        var amount: Double = 0
        ///minimumReceive
        var satisfiedAmount: Double = 0
        var currency: String = ""
    }
}
