// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class PoolsByPairsQuery: GraphQLQuery {
  public static let operationName: String = "PoolsByPairsQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query PoolsByPairsQuery($pairs: [InputPair!]!) { poolsByPairs(pairs: $pairs) { __typename lpAsset { __typename currencySymbol metadata { __typename isVerified name ticker decimals } tokenName } poolAssets { __typename currencySymbol metadata { __typename decimals isVerified name ticker } tokenName } tvlInAda type utxo { __typename address txIn value } } }"#
    ))

  public var pairs: [InputPair]

  public init(pairs: [InputPair]) {
    self.pairs = pairs
  }

  public var __variables: Variables? { ["pairs": pairs] }

  public struct Data: MinWalletAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("poolsByPairs", [PoolsByPair].self, arguments: ["pairs": .variable("pairs")]),
    ] }

    public var poolsByPairs: [PoolsByPair] { __data["poolsByPairs"] }

    /// PoolsByPair
    ///
    /// Parent Type: `AMMPool`
    public struct PoolsByPair: MinWalletAPI.SelectionSet {
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

      /// PoolsByPair.LpAsset
      ///
      /// Parent Type: `Asset`
      public struct LpAsset: MinWalletAPI.SelectionSet {
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

        /// PoolsByPair.LpAsset.Metadata
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

      /// PoolsByPair.PoolAsset
      ///
      /// Parent Type: `Asset`
      public struct PoolAsset: MinWalletAPI.SelectionSet {
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

        /// PoolsByPair.PoolAsset.Metadata
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

      /// PoolsByPair.Utxo
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
  }
}
