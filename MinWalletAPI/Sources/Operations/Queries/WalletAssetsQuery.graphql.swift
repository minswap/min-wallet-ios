// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class WalletAssetsQuery: GraphQLQuery {
  public static let operationName: String = "WalletAssetsQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query WalletAssetsQuery($address: String!) { getWalletAssetsPositions(address: $address) { __typename nfts { __typename asset { __typename currencySymbol tokenName } displayName image } lovelace lpTokens { __typename ammType amountLPAsset { __typename amount asset { __typename currencySymbol metadata { __typename decimals description isVerified name ticker url } tokenName details { __typename categories project socialLinks { __typename coinGecko coinMarketCap discord telegram twitter website } } } } lpAdaValue pnl24H poolShare amountAssets { __typename amount asset { __typename currencySymbol metadata { __typename decimals description isVerified name ticker url } tokenName details { __typename categories project socialLinks { __typename coinGecko coinMarketCap discord telegram twitter website } } } } } assets { __typename amountAsset { __typename amount asset { __typename currencySymbol tokenName metadata { __typename decimals description isVerified name ticker url } details { __typename categories project socialLinks { __typename coinGecko coinMarketCap discord telegram twitter website } } } } pnl24H priceInAda valueInAda } } }"#
    ))

  public var address: String

  public init(address: String) {
    self.address = address
  }

  public var __variables: Variables? { ["address": address] }

  public struct Data: MinWalletAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("getWalletAssetsPositions", GetWalletAssetsPositions.self, arguments: ["address": .variable("address")]),
    ] }

    public var getWalletAssetsPositions: GetWalletAssetsPositions { __data["getWalletAssetsPositions"] }

    /// GetWalletAssetsPositions
    ///
    /// Parent Type: `WalletAssetsPositions`
    public struct GetWalletAssetsPositions: MinWalletAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.WalletAssetsPositions }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("nfts", [Nft].self),
        .field("lovelace", MinWalletAPI.BigInt.self),
        .field("lpTokens", [LpToken].self),
        .field("assets", [Asset].self),
      ] }

      public var nfts: [Nft] { __data["nfts"] }
      public var lovelace: MinWalletAPI.BigInt { __data["lovelace"] }
      public var lpTokens: [LpToken] { __data["lpTokens"] }
      public var assets: [Asset] { __data["assets"] }

      /// GetWalletAssetsPositions.Nft
      ///
      /// Parent Type: `PortfolioNFTPosition`
      public struct Nft: MinWalletAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.PortfolioNFTPosition }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("asset", Asset.self),
          .field("displayName", String?.self),
          .field("image", String?.self),
        ] }

        public var asset: Asset { __data["asset"] }
        public var displayName: String? { __data["displayName"] }
        public var image: String? { __data["image"] }

        /// GetWalletAssetsPositions.Nft.Asset
        ///
        /// Parent Type: `Asset`
        public struct Asset: MinWalletAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.Asset }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("currencySymbol", String.self),
            .field("tokenName", String.self),
          ] }

          public var currencySymbol: String { __data["currencySymbol"] }
          public var tokenName: String { __data["tokenName"] }
        }
      }

      /// GetWalletAssetsPositions.LpToken
      ///
      /// Parent Type: `PortfolioLPPosition`
      public struct LpToken: MinWalletAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.PortfolioLPPosition }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("ammType", GraphQLEnum<MinWalletAPI.AMMType>.self),
          .field("amountLPAsset", AmountLPAsset.self),
          .field("lpAdaValue", MinWalletAPI.BigInt.self),
          .field("pnl24H", MinWalletAPI.BigInt.self),
          .field("poolShare", Double.self),
          .field("amountAssets", [AmountAsset].self),
        ] }

        public var ammType: GraphQLEnum<MinWalletAPI.AMMType> { __data["ammType"] }
        public var amountLPAsset: AmountLPAsset { __data["amountLPAsset"] }
        public var lpAdaValue: MinWalletAPI.BigInt { __data["lpAdaValue"] }
        public var pnl24H: MinWalletAPI.BigInt { __data["pnl24H"] }
        public var poolShare: Double { __data["poolShare"] }
        public var amountAssets: [AmountAsset] { __data["amountAssets"] }

        /// GetWalletAssetsPositions.LpToken.AmountLPAsset
        ///
        /// Parent Type: `AssetAmount`
        public struct AmountLPAsset: MinWalletAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetAmount }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("amount", MinWalletAPI.BigInt.self),
            .field("asset", Asset.self),
          ] }

          public var amount: MinWalletAPI.BigInt { __data["amount"] }
          public var asset: Asset { __data["asset"] }

          /// GetWalletAssetsPositions.LpToken.AmountLPAsset.Asset
          ///
          /// Parent Type: `Asset`
          public struct Asset: MinWalletAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.Asset }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("currencySymbol", String.self),
              .field("metadata", Metadata?.self),
              .field("tokenName", String.self),
              .field("details", Details?.self),
            ] }

            public var currencySymbol: String { __data["currencySymbol"] }
            public var metadata: Metadata? { __data["metadata"] }
            public var tokenName: String { __data["tokenName"] }
            public var details: Details? { __data["details"] }

            /// GetWalletAssetsPositions.LpToken.AmountLPAsset.Asset.Metadata
            ///
            /// Parent Type: `AssetMetadata`
            public struct Metadata: MinWalletAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetMetadata }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("decimals", Int?.self),
                .field("description", String?.self),
                .field("isVerified", Bool.self),
                .field("name", String?.self),
                .field("ticker", String?.self),
                .field("url", String?.self),
              ] }

              public var decimals: Int? { __data["decimals"] }
              public var description: String? { __data["description"] }
              public var isVerified: Bool { __data["isVerified"] }
              public var name: String? { __data["name"] }
              public var ticker: String? { __data["ticker"] }
              public var url: String? { __data["url"] }
            }

            /// GetWalletAssetsPositions.LpToken.AmountLPAsset.Asset.Details
            ///
            /// Parent Type: `AssetDetails`
            public struct Details: MinWalletAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetDetails }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("categories", [String].self),
                .field("project", String.self),
                .field("socialLinks", SocialLinks?.self),
              ] }

              public var categories: [String] { __data["categories"] }
              public var project: String { __data["project"] }
              public var socialLinks: SocialLinks? { __data["socialLinks"] }

              /// GetWalletAssetsPositions.LpToken.AmountLPAsset.Asset.Details.SocialLinks
              ///
              /// Parent Type: `AssetSocialLinks`
              public struct SocialLinks: MinWalletAPI.SelectionSet {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetSocialLinks }
                public static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("coinGecko", String?.self),
                  .field("coinMarketCap", String?.self),
                  .field("discord", String?.self),
                  .field("telegram", String?.self),
                  .field("twitter", String?.self),
                  .field("website", String?.self),
                ] }

                public var coinGecko: String? { __data["coinGecko"] }
                public var coinMarketCap: String? { __data["coinMarketCap"] }
                public var discord: String? { __data["discord"] }
                public var telegram: String? { __data["telegram"] }
                public var twitter: String? { __data["twitter"] }
                public var website: String? { __data["website"] }
              }
            }
          }
        }

        /// GetWalletAssetsPositions.LpToken.AmountAsset
        ///
        /// Parent Type: `AssetAmount`
        public struct AmountAsset: MinWalletAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetAmount }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("amount", MinWalletAPI.BigInt.self),
            .field("asset", Asset.self),
          ] }

          public var amount: MinWalletAPI.BigInt { __data["amount"] }
          public var asset: Asset { __data["asset"] }

          /// GetWalletAssetsPositions.LpToken.AmountAsset.Asset
          ///
          /// Parent Type: `Asset`
          public struct Asset: MinWalletAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.Asset }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("currencySymbol", String.self),
              .field("metadata", Metadata?.self),
              .field("tokenName", String.self),
              .field("details", Details?.self),
            ] }

            public var currencySymbol: String { __data["currencySymbol"] }
            public var metadata: Metadata? { __data["metadata"] }
            public var tokenName: String { __data["tokenName"] }
            public var details: Details? { __data["details"] }

            /// GetWalletAssetsPositions.LpToken.AmountAsset.Asset.Metadata
            ///
            /// Parent Type: `AssetMetadata`
            public struct Metadata: MinWalletAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetMetadata }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("decimals", Int?.self),
                .field("description", String?.self),
                .field("isVerified", Bool.self),
                .field("name", String?.self),
                .field("ticker", String?.self),
                .field("url", String?.self),
              ] }

              public var decimals: Int? { __data["decimals"] }
              public var description: String? { __data["description"] }
              public var isVerified: Bool { __data["isVerified"] }
              public var name: String? { __data["name"] }
              public var ticker: String? { __data["ticker"] }
              public var url: String? { __data["url"] }
            }

            /// GetWalletAssetsPositions.LpToken.AmountAsset.Asset.Details
            ///
            /// Parent Type: `AssetDetails`
            public struct Details: MinWalletAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetDetails }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("categories", [String].self),
                .field("project", String.self),
                .field("socialLinks", SocialLinks?.self),
              ] }

              public var categories: [String] { __data["categories"] }
              public var project: String { __data["project"] }
              public var socialLinks: SocialLinks? { __data["socialLinks"] }

              /// GetWalletAssetsPositions.LpToken.AmountAsset.Asset.Details.SocialLinks
              ///
              /// Parent Type: `AssetSocialLinks`
              public struct SocialLinks: MinWalletAPI.SelectionSet {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetSocialLinks }
                public static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("coinGecko", String?.self),
                  .field("coinMarketCap", String?.self),
                  .field("discord", String?.self),
                  .field("telegram", String?.self),
                  .field("twitter", String?.self),
                  .field("website", String?.self),
                ] }

                public var coinGecko: String? { __data["coinGecko"] }
                public var coinMarketCap: String? { __data["coinMarketCap"] }
                public var discord: String? { __data["discord"] }
                public var telegram: String? { __data["telegram"] }
                public var twitter: String? { __data["twitter"] }
                public var website: String? { __data["website"] }
              }
            }
          }
        }
      }

      /// GetWalletAssetsPositions.Asset
      ///
      /// Parent Type: `PortfolioTokenPosition`
      public struct Asset: MinWalletAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.PortfolioTokenPosition }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("amountAsset", AmountAsset.self),
          .field("pnl24H", MinWalletAPI.BigInt.self),
          .field("priceInAda", MinWalletAPI.BigNumber.self),
          .field("valueInAda", MinWalletAPI.BigInt.self),
        ] }

        public var amountAsset: AmountAsset { __data["amountAsset"] }
        public var pnl24H: MinWalletAPI.BigInt { __data["pnl24H"] }
        public var priceInAda: MinWalletAPI.BigNumber { __data["priceInAda"] }
        public var valueInAda: MinWalletAPI.BigInt { __data["valueInAda"] }

        /// GetWalletAssetsPositions.Asset.AmountAsset
        ///
        /// Parent Type: `AssetAmount`
        public struct AmountAsset: MinWalletAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetAmount }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("amount", MinWalletAPI.BigInt.self),
            .field("asset", Asset.self),
          ] }

          public var amount: MinWalletAPI.BigInt { __data["amount"] }
          public var asset: Asset { __data["asset"] }

          /// GetWalletAssetsPositions.Asset.AmountAsset.Asset
          ///
          /// Parent Type: `Asset`
          public struct Asset: MinWalletAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.Asset }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("currencySymbol", String.self),
              .field("tokenName", String.self),
              .field("metadata", Metadata?.self),
              .field("details", Details?.self),
            ] }

            public var currencySymbol: String { __data["currencySymbol"] }
            public var tokenName: String { __data["tokenName"] }
            public var metadata: Metadata? { __data["metadata"] }
            public var details: Details? { __data["details"] }

            /// GetWalletAssetsPositions.Asset.AmountAsset.Asset.Metadata
            ///
            /// Parent Type: `AssetMetadata`
            public struct Metadata: MinWalletAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetMetadata }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("decimals", Int?.self),
                .field("description", String?.self),
                .field("isVerified", Bool.self),
                .field("name", String?.self),
                .field("ticker", String?.self),
                .field("url", String?.self),
              ] }

              public var decimals: Int? { __data["decimals"] }
              public var description: String? { __data["description"] }
              public var isVerified: Bool { __data["isVerified"] }
              public var name: String? { __data["name"] }
              public var ticker: String? { __data["ticker"] }
              public var url: String? { __data["url"] }
            }

            /// GetWalletAssetsPositions.Asset.AmountAsset.Asset.Details
            ///
            /// Parent Type: `AssetDetails`
            public struct Details: MinWalletAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetDetails }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("categories", [String].self),
                .field("project", String.self),
                .field("socialLinks", SocialLinks?.self),
              ] }

              public var categories: [String] { __data["categories"] }
              public var project: String { __data["project"] }
              public var socialLinks: SocialLinks? { __data["socialLinks"] }

              /// GetWalletAssetsPositions.Asset.AmountAsset.Asset.Details.SocialLinks
              ///
              /// Parent Type: `AssetSocialLinks`
              public struct SocialLinks: MinWalletAPI.SelectionSet {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetSocialLinks }
                public static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("coinGecko", String?.self),
                  .field("coinMarketCap", String?.self),
                  .field("discord", String?.self),
                  .field("telegram", String?.self),
                  .field("twitter", String?.self),
                  .field("website", String?.self),
                ] }

                public var coinGecko: String? { __data["coinGecko"] }
                public var coinMarketCap: String? { __data["coinMarketCap"] }
                public var discord: String? { __data["discord"] }
                public var telegram: String? { __data["telegram"] }
                public var twitter: String? { __data["twitter"] }
                public var website: String? { __data["website"] }
              }
            }
          }
        }
      }
    }
  }
}
