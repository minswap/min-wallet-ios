// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class WalletAssetsQuery: GraphQLQuery {
  public static let operationName: String = "WalletAssetsQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query WalletAssetsQuery($address: String!) { getWalletAssetsPositions(address: $address) { __typename lpTokens { __typename amountAssets { __typename asset { __typename currencySymbol metadata { __typename description isVerified name ticker decimals } tokenName } } } assets { __typename amountAsset { __typename asset { __typename currencySymbol metadata { __typename description isVerified name ticker decimals } tokenName } } priceInAda } } }"#
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
        .field("lpTokens", [LpToken].self),
        .field("assets", [Asset].self),
      ] }

      public var lpTokens: [LpToken] { __data["lpTokens"] }
      public var assets: [Asset] { __data["assets"] }

      /// GetWalletAssetsPositions.LpToken
      ///
      /// Parent Type: `PortfolioLPPosition`
      public struct LpToken: MinWalletAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.PortfolioLPPosition }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("amountAssets", [AmountAsset].self),
        ] }

        public var amountAssets: [AmountAsset] { __data["amountAssets"] }

        /// GetWalletAssetsPositions.LpToken.AmountAsset
        ///
        /// Parent Type: `AssetAmount`
        public struct AmountAsset: MinWalletAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetAmount }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("asset", Asset.self),
          ] }

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
            ] }

            public var currencySymbol: String { __data["currencySymbol"] }
            public var metadata: Metadata? { __data["metadata"] }
            public var tokenName: String { __data["tokenName"] }

            /// GetWalletAssetsPositions.LpToken.AmountAsset.Asset.Metadata
            ///
            /// Parent Type: `AssetMetadata`
            public struct Metadata: MinWalletAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetMetadata }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("description", String?.self),
                .field("isVerified", Bool.self),
                .field("name", String?.self),
                .field("ticker", String?.self),
                .field("decimals", Int?.self),
              ] }

              public var description: String? { __data["description"] }
              public var isVerified: Bool { __data["isVerified"] }
              public var name: String? { __data["name"] }
              public var ticker: String? { __data["ticker"] }
              public var decimals: Int? { __data["decimals"] }
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
          .field("priceInAda", MinWalletAPI.BigNumber.self),
        ] }

        public var amountAsset: AmountAsset { __data["amountAsset"] }
        public var priceInAda: MinWalletAPI.BigNumber { __data["priceInAda"] }

        /// GetWalletAssetsPositions.Asset.AmountAsset
        ///
        /// Parent Type: `AssetAmount`
        public struct AmountAsset: MinWalletAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetAmount }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("asset", Asset.self),
          ] }

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
              .field("metadata", Metadata?.self),
              .field("tokenName", String.self),
            ] }

            public var currencySymbol: String { __data["currencySymbol"] }
            public var metadata: Metadata? { __data["metadata"] }
            public var tokenName: String { __data["tokenName"] }

            /// GetWalletAssetsPositions.Asset.AmountAsset.Asset.Metadata
            ///
            /// Parent Type: `AssetMetadata`
            public struct Metadata: MinWalletAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetMetadata }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("description", String?.self),
                .field("isVerified", Bool.self),
                .field("name", String?.self),
                .field("ticker", String?.self),
                .field("decimals", Int?.self),
              ] }

              public var description: String? { __data["description"] }
              public var isVerified: Bool { __data["isVerified"] }
              public var name: String? { __data["name"] }
              public var ticker: String? { __data["ticker"] }
              public var decimals: Int? { __data["decimals"] }
            }
          }
        }
      }
    }
  }
}
