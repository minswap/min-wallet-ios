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
    case "AssetMetadata": return MinWalletAPI.Objects.AssetMetadata
    case "AssetsResponse": return MinWalletAPI.Objects.AssetsResponse
    case "OrderHistory": return MinWalletAPI.Objects.OrderHistory
    case "OrderHistoryResponse": return MinWalletAPI.Objects.OrderHistoryResponse
    case "OrderLinkedPool": return MinWalletAPI.Objects.OrderLinkedPool
    case "OrderPaginationCursor": return MinWalletAPI.Objects.OrderPaginationCursor
    case "PortfolioLPPosition": return MinWalletAPI.Objects.PortfolioLPPosition
    case "PortfolioNFTPosition": return MinWalletAPI.Objects.PortfolioNFTPosition
    case "PortfolioOverview": return MinWalletAPI.Objects.PortfolioOverview
    case "PortfolioTokenPosition": return MinWalletAPI.Objects.PortfolioTokenPosition
    case "Query": return MinWalletAPI.Objects.Query
    case "SimpleChart": return MinWalletAPI.Objects.SimpleChart
    case "TopAsset": return MinWalletAPI.Objects.TopAsset
    case "TopAssetsResponse": return MinWalletAPI.Objects.TopAssetsResponse
    case "TxIn": return MinWalletAPI.Objects.TxIn
    case "WalletAssetsPositions": return MinWalletAPI.Objects.WalletAssetsPositions
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
