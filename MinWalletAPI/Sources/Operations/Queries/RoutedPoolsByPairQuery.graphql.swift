// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class RoutedPoolsByPairQuery: GraphQLQuery {
  public static let operationName: String = "RoutedPoolsByPairQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query RoutedPoolsByPairQuery($isApplied: Boolean!, $pair: InputPair!) { routedPoolsByPair(isApplied: $isApplied, pair: $pair) { __typename pools { __typename lpAsset { __typename currencySymbol tokenName metadata { __typename name ticker decimals description isVerified } details { __typename categories project socialLinks { __typename coinGecko coinMarketCap discord telegram twitter website } } } poolAssets { __typename currencySymbol tokenName metadata { __typename name ticker isVerified description decimals } details { __typename categories socialLinks { __typename coinGecko coinMarketCap discord telegram twitter website } } } tvlInAda type utxo { __typename address txIn value } } routings { __typename routing { __typename currencySymbol tokenName metadata { __typename name ticker } } type } } }"#
    ))

  public var isApplied: Bool
  public var pair: InputPair

  public init(
    isApplied: Bool,
    pair: InputPair
  ) {
    self.isApplied = isApplied
    self.pair = pair
  }

  public var __variables: Variables? { [
    "isApplied": isApplied,
    "pair": pair
  ] }

  public struct Data: MinWalletAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("routedPoolsByPair", RoutedPoolsByPair.self, arguments: [
        "isApplied": .variable("isApplied"),
        "pair": .variable("pair")
      ]),
    ] }

    public var routedPoolsByPair: RoutedPoolsByPair { __data["routedPoolsByPair"] }

    /// RoutedPoolsByPair
    ///
    /// Parent Type: `RoutedPools`
    public struct RoutedPoolsByPair: MinWalletAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.RoutedPools }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("pools", [Pool].self),
        .field("routings", [Routing].self),
      ] }

      public var pools: [Pool] { __data["pools"] }
      public var routings: [Routing] { __data["routings"] }

      /// RoutedPoolsByPair.Pool
      ///
      /// Parent Type: `AMMPool`
      public struct Pool: MinWalletAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AMMPool }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("lpAsset", LpAsset.self),
          .field("poolAssets", [PoolAsset].self),
          .field("tvlInAda", MinWalletAPI.BigInt?.self),
          .field("type", GraphQLEnum<MinWalletAPI.AMMType>.self),
          .field("utxo", Utxo.self),
        ] }

        public var lpAsset: LpAsset { __data["lpAsset"] }
        public var poolAssets: [PoolAsset] { __data["poolAssets"] }
        public var tvlInAda: MinWalletAPI.BigInt? { __data["tvlInAda"] }
        public var type: GraphQLEnum<MinWalletAPI.AMMType> { __data["type"] }
        public var utxo: Utxo { __data["utxo"] }

        /// RoutedPoolsByPair.Pool.LpAsset
        ///
        /// Parent Type: `Asset`
        public struct LpAsset: MinWalletAPI.SelectionSet {
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

          /// RoutedPoolsByPair.Pool.LpAsset.Metadata
          ///
          /// Parent Type: `AssetMetadata`
          public struct Metadata: MinWalletAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetMetadata }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("name", String?.self),
              .field("ticker", String?.self),
              .field("decimals", Int?.self),
              .field("description", String?.self),
              .field("isVerified", Bool.self),
            ] }

            public var name: String? { __data["name"] }
            public var ticker: String? { __data["ticker"] }
            public var decimals: Int? { __data["decimals"] }
            public var description: String? { __data["description"] }
            public var isVerified: Bool { __data["isVerified"] }
          }

          /// RoutedPoolsByPair.Pool.LpAsset.Details
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

            /// RoutedPoolsByPair.Pool.LpAsset.Details.SocialLinks
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

        /// RoutedPoolsByPair.Pool.PoolAsset
        ///
        /// Parent Type: `Asset`
        public struct PoolAsset: MinWalletAPI.SelectionSet {
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

          /// RoutedPoolsByPair.Pool.PoolAsset.Metadata
          ///
          /// Parent Type: `AssetMetadata`
          public struct Metadata: MinWalletAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetMetadata }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("name", String?.self),
              .field("ticker", String?.self),
              .field("isVerified", Bool.self),
              .field("description", String?.self),
              .field("decimals", Int?.self),
            ] }

            public var name: String? { __data["name"] }
            public var ticker: String? { __data["ticker"] }
            public var isVerified: Bool { __data["isVerified"] }
            public var description: String? { __data["description"] }
            public var decimals: Int? { __data["decimals"] }
          }

          /// RoutedPoolsByPair.Pool.PoolAsset.Details
          ///
          /// Parent Type: `AssetDetails`
          public struct Details: MinWalletAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetDetails }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("categories", [String].self),
              .field("socialLinks", SocialLinks?.self),
            ] }

            public var categories: [String] { __data["categories"] }
            public var socialLinks: SocialLinks? { __data["socialLinks"] }

            /// RoutedPoolsByPair.Pool.PoolAsset.Details.SocialLinks
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

        /// RoutedPoolsByPair.Pool.Utxo
        ///
        /// Parent Type: `AMMUtxo`
        public struct Utxo: MinWalletAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AMMUtxo }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("address", String.self),
            .field("txIn", String.self),
            .field("value", String.self),
          ] }

          public var address: String { __data["address"] }
          public var txIn: String { __data["txIn"] }
          public var value: String { __data["value"] }
        }
      }

      /// RoutedPoolsByPair.Routing
      ///
      /// Parent Type: `Routing`
      public struct Routing: MinWalletAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.Routing }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("routing", [Routing].self),
          .field("type", GraphQLEnum<MinWalletAPI.AMMType>.self),
        ] }

        public var routing: [Routing] { __data["routing"] }
        public var type: GraphQLEnum<MinWalletAPI.AMMType> { __data["type"] }

        /// RoutedPoolsByPair.Routing.Routing
        ///
        /// Parent Type: `Asset`
        public struct Routing: MinWalletAPI.SelectionSet {
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

          /// RoutedPoolsByPair.Routing.Routing.Metadata
          ///
          /// Parent Type: `AssetMetadata`
          public struct Metadata: MinWalletAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetMetadata }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("name", String?.self),
              .field("ticker", String?.self),
            ] }

            public var name: String? { __data["name"] }
            public var ticker: String? { __data["ticker"] }
          }
        }
      }
    }
  }
}
