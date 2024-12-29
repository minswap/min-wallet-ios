// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class WalletAssetsQuery: GraphQLQuery {
  public static let operationName: String = "WalletAssetsQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query WalletAssetsQuery($address: String!) { getWalletAssetsPositions(address: $address) { __typename lpTokens { __typename pnl24H amountLPAsset { __typename asset { __typename currencySymbol tokenName metadata { __typename isVerified name ticker decimals } } amount } lpAdaValue } assets { __typename amountAsset { __typename asset { __typename currencySymbol metadata { __typename isVerified name ticker decimals } tokenName } amount } pnl24H valueInAda } } }"#
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
          .field("pnl24H", MinWalletAPI.BigInt.self),
          .field("amountLPAsset", AmountLPAsset.self),
          .field("lpAdaValue", MinWalletAPI.BigInt.self),
        ] }

        public var pnl24H: MinWalletAPI.BigInt { __data["pnl24H"] }
        public var amountLPAsset: AmountLPAsset { __data["amountLPAsset"] }
        public var lpAdaValue: MinWalletAPI.BigInt { __data["lpAdaValue"] }

        /// GetWalletAssetsPositions.LpToken.AmountLPAsset
        ///
        /// Parent Type: `AssetAmount`
        public struct AmountLPAsset: MinWalletAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetAmount }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("asset", Asset.self),
            .field("amount", MinWalletAPI.BigInt.self),
          ] }

          public var asset: Asset { __data["asset"] }
          public var amount: MinWalletAPI.BigInt { __data["amount"] }

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
              .field("tokenName", String.self),
              .field("metadata", Metadata?.self),
            ] }

            public var currencySymbol: String { __data["currencySymbol"] }
            public var tokenName: String { __data["tokenName"] }
            public var metadata: Metadata? { __data["metadata"] }

            /// GetWalletAssetsPositions.LpToken.AmountLPAsset.Asset.Metadata
            ///
            /// Parent Type: `AssetMetadata`
            public struct Metadata: MinWalletAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetMetadata }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("isVerified", Bool.self),
                .field("name", String?.self),
                .field("ticker", String?.self),
                .field("decimals", Int?.self),
              ] }

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
          .field("pnl24H", MinWalletAPI.BigInt.self),
          .field("valueInAda", MinWalletAPI.BigInt.self),
        ] }

        public var amountAsset: AmountAsset { __data["amountAsset"] }
        public var pnl24H: MinWalletAPI.BigInt { __data["pnl24H"] }
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
            .field("asset", Asset.self),
            .field("amount", MinWalletAPI.BigInt.self),
          ] }

          public var asset: Asset { __data["asset"] }
          public var amount: MinWalletAPI.BigInt { __data["amount"] }

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
                .field("isVerified", Bool.self),
                .field("name", String?.self),
                .field("ticker", String?.self),
                .field("decimals", Int?.self),
              ] }

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
