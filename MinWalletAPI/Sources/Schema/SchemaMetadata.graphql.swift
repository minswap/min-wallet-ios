// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == MinWalletAPI.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == MinWalletAPI.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == MinWalletAPI.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == MinWalletAPI.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
    switch typename {
    case "AMMPool": return MinWalletAPI.Objects.AMMPool
    case "AMMUtxo": return MinWalletAPI.Objects.AMMUtxo
    case "AdaPrice": return MinWalletAPI.Objects.AdaPrice
    case "Asset": return MinWalletAPI.Objects.Asset
    case "AssetAmount": return MinWalletAPI.Objects.AssetAmount
    case "AssetDetails": return MinWalletAPI.Objects.AssetDetails
    case "AssetMetadata": return MinWalletAPI.Objects.AssetMetadata
    case "AssetSocialLinks": return MinWalletAPI.Objects.AssetSocialLinks
    case "AssetsResponse": return MinWalletAPI.Objects.AssetsResponse
    case "DepositOverSlippageDetail": return MinWalletAPI.Objects.DepositOverSlippageDetail
    case "DexV2WithdrawImbalanceOverSlippageDetail": return MinWalletAPI.Objects.DexV2WithdrawImbalanceOverSlippageDetail
    case "OCOOverSlipageDetail": return MinWalletAPI.Objects.OCOOverSlipageDetail
    case "OrderHistory": return MinWalletAPI.Objects.OrderHistory
    case "OrderHistoryResponse": return MinWalletAPI.Objects.OrderHistoryResponse
    case "OrderLinkedPool": return MinWalletAPI.Objects.OrderLinkedPool
    case "OrderPaginationCursor": return MinWalletAPI.Objects.OrderPaginationCursor
    case "PartialFillOverSlippageDetail": return MinWalletAPI.Objects.PartialFillOverSlippageDetail
    case "PortfolioLPPosition": return MinWalletAPI.Objects.PortfolioLPPosition
    case "PortfolioNFTPosition": return MinWalletAPI.Objects.PortfolioNFTPosition
    case "PortfolioOverview": return MinWalletAPI.Objects.PortfolioOverview
    case "PortfolioTokenPosition": return MinWalletAPI.Objects.PortfolioTokenPosition
    case "Query": return MinWalletAPI.Objects.Query
    case "RiskScore": return MinWalletAPI.Objects.RiskScore
    case "RoutingOverSlipageDetail": return MinWalletAPI.Objects.RoutingOverSlipageDetail
    case "SimpleChart": return MinWalletAPI.Objects.SimpleChart
    case "StableswapWithdrawImbalanceOverSlippageDetail": return MinWalletAPI.Objects.StableswapWithdrawImbalanceOverSlippageDetail
    case "StopOverSlippageDetail": return MinWalletAPI.Objects.StopOverSlippageDetail
    case "SwapExactInOverSlippageDetail": return MinWalletAPI.Objects.SwapExactInOverSlippageDetail
    case "SwapExactOutOverSlippageDetail": return MinWalletAPI.Objects.SwapExactOutOverSlippageDetail
    case "TopAsset": return MinWalletAPI.Objects.TopAsset
    case "TopAssetsResponse": return MinWalletAPI.Objects.TopAssetsResponse
    case "TxIn": return MinWalletAPI.Objects.TxIn
    case "WalletAssetsPositions": return MinWalletAPI.Objects.WalletAssetsPositions
    case "WithdrawOverSlippageDetail": return MinWalletAPI.Objects.WithdrawOverSlippageDetail
    case "ZapInOverSlippageDetail": return MinWalletAPI.Objects.ZapInOverSlippageDetail
    case "ZapOutOverSlippageDetail": return MinWalletAPI.Objects.ZapOutOverSlippageDetail
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
