// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class TopAssetQuery: GraphQLQuery {
  public static let operationName: String = "TopAssetQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query TopAssetQuery($asset: InputAsset!) { topAsset(asset: $asset) { __typename asset { __typename currencySymbol metadata { __typename decimals isVerified name ticker } } marketCap price price24hAgo price30dAgo price7dAgo priceChange24h priceChange7d totalSupply tvl volume24h volume30d volume7d fdMarketCap circulatingSupply } }"#
    ))

  public var asset: InputAsset

  public init(asset: InputAsset) {
    self.asset = asset
  }

  public var __variables: Variables? { ["asset": asset] }

  public struct Data: MinWalletAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("topAsset", TopAsset?.self, arguments: ["asset": .variable("asset")]),
    ] }

    public var topAsset: TopAsset? { __data["topAsset"] }

    /// TopAsset
    ///
    /// Parent Type: `TopAsset`
    public struct TopAsset: MinWalletAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.TopAsset }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("asset", Asset.self),
        .field("marketCap", MinWalletAPI.BigNumber.self),
        .field("price", MinWalletAPI.BigNumber.self),
        .field("price24hAgo", MinWalletAPI.BigNumber.self),
        .field("price30dAgo", MinWalletAPI.BigNumber.self),
        .field("price7dAgo", MinWalletAPI.BigNumber.self),
        .field("priceChange24h", MinWalletAPI.BigNumber.self),
        .field("priceChange7d", MinWalletAPI.BigNumber.self),
        .field("totalSupply", MinWalletAPI.BigNumber.self),
        .field("tvl", MinWalletAPI.BigInt.self),
        .field("volume24h", MinWalletAPI.BigNumber.self),
        .field("volume30d", MinWalletAPI.BigNumber.self),
        .field("volume7d", MinWalletAPI.BigNumber.self),
        .field("fdMarketCap", MinWalletAPI.BigNumber.self),
        .field("circulatingSupply", MinWalletAPI.BigNumber.self),
      ] }

      public var asset: Asset { __data["asset"] }
      public var marketCap: MinWalletAPI.BigNumber { __data["marketCap"] }
      public var price: MinWalletAPI.BigNumber { __data["price"] }
      public var price24hAgo: MinWalletAPI.BigNumber { __data["price24hAgo"] }
      public var price30dAgo: MinWalletAPI.BigNumber { __data["price30dAgo"] }
      public var price7dAgo: MinWalletAPI.BigNumber { __data["price7dAgo"] }
      public var priceChange24h: MinWalletAPI.BigNumber { __data["priceChange24h"] }
      public var priceChange7d: MinWalletAPI.BigNumber { __data["priceChange7d"] }
      public var totalSupply: MinWalletAPI.BigNumber { __data["totalSupply"] }
      public var tvl: MinWalletAPI.BigInt { __data["tvl"] }
      public var volume24h: MinWalletAPI.BigNumber { __data["volume24h"] }
      public var volume30d: MinWalletAPI.BigNumber { __data["volume30d"] }
      public var volume7d: MinWalletAPI.BigNumber { __data["volume7d"] }
      public var fdMarketCap: MinWalletAPI.BigNumber { __data["fdMarketCap"] }
      public var circulatingSupply: MinWalletAPI.BigNumber { __data["circulatingSupply"] }

      /// TopAsset.Asset
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
        ] }

        public var currencySymbol: String { __data["currencySymbol"] }
        public var metadata: Metadata? { __data["metadata"] }

        /// TopAsset.Asset.Metadata
        ///
        /// Parent Type: `AssetMetadata`
        public struct Metadata: MinWalletAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetMetadata }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("decimals", Int?.self),
            .field("isVerified", Bool.self),
            .field("name", String?.self),
            .field("ticker", String?.self),
          ] }

          public var decimals: Int? { __data["decimals"] }
          public var isVerified: Bool { __data["isVerified"] }
          public var name: String? { __data["name"] }
          public var ticker: String? { __data["ticker"] }
        }
      }
    }
  }
}
