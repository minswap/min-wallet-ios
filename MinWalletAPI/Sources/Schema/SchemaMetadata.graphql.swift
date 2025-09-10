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
    case "CurrencyStats": return MinWalletAPI.Objects.CurrencyStats
    case "IosTradeEstimateOutput": return MinWalletAPI.Objects.IosTradeEstimateOutput
    case "Mutation": return MinWalletAPI.Objects.Mutation
    case "PortfolioLPPosition": return MinWalletAPI.Objects.PortfolioLPPosition
    case "PortfolioNFTPosition": return MinWalletAPI.Objects.PortfolioNFTPosition
    case "PortfolioOverview": return MinWalletAPI.Objects.PortfolioOverview
    case "PortfolioTokenPosition": return MinWalletAPI.Objects.PortfolioTokenPosition
    case "Query": return MinWalletAPI.Objects.Query
    case "RiskScore": return MinWalletAPI.Objects.RiskScore
    case "ScriptUtxo": return MinWalletAPI.Objects.ScriptUtxo
    case "SimpleChart": return MinWalletAPI.Objects.SimpleChart
    case "TopAsset": return MinWalletAPI.Objects.TopAsset
    case "TopAssetsResponse": return MinWalletAPI.Objects.TopAssetsResponse
    case "WalletAssetsPositions": return MinWalletAPI.Objects.WalletAssetsPositions
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
