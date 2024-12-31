// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class TopAssetQuery: GraphQLQuery {
  public static let operationName: String = "TopAssetQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query TopAssetQuery($input: TopAssetsInput) { topAssets(input: $input) { __typename searchAfter topAssets { __typename price asset { __typename currencySymbol metadata { __typename isVerified decimals ticker name } tokenName } priceChange24h } } }"#
    ))

  public var input: GraphQLNullable<TopAssetsInput>

  public init(input: GraphQLNullable<TopAssetsInput>) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: MinWalletAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("topAssets", TopAssets.self, arguments: ["input": .variable("input")]),
    ] }

    public var topAssets: TopAssets { __data["topAssets"] }

    /// TopAssets
    ///
    /// Parent Type: `TopAssetsResponse`
    public struct TopAssets: MinWalletAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.TopAssetsResponse }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("searchAfter", [String]?.self),
        .field("topAssets", [TopAsset].self),
      ] }

      public var searchAfter: [String]? { __data["searchAfter"] }
      public var topAssets: [TopAsset] { __data["topAssets"] }

      /// TopAssets.TopAsset
      ///
      /// Parent Type: `TopAsset`
      public struct TopAsset: MinWalletAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.TopAsset }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("price", MinWalletAPI.BigNumber.self),
          .field("asset", Asset.self),
          .field("priceChange24h", MinWalletAPI.BigNumber.self),
        ] }

        public var price: MinWalletAPI.BigNumber { __data["price"] }
        public var asset: Asset { __data["asset"] }
        public var priceChange24h: MinWalletAPI.BigNumber { __data["priceChange24h"] }

        /// TopAssets.TopAsset.Asset
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

          /// TopAssets.TopAsset.Asset.Metadata
          ///
          /// Parent Type: `AssetMetadata`
          public struct Metadata: MinWalletAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetMetadata }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("isVerified", Bool.self),
              .field("decimals", Int?.self),
              .field("ticker", String?.self),
              .field("name", String?.self),
            ] }

            public var isVerified: Bool { __data["isVerified"] }
            public var decimals: Int? { __data["decimals"] }
            public var ticker: String? { __data["ticker"] }
            public var name: String? { __data["name"] }
          }
        }
      }
    }
  }
}
