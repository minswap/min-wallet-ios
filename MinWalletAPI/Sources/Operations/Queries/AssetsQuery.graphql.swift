// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class AssetsQuery: GraphQLQuery {
  public static let operationName: String = "AssetsQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query AssetsQuery($input: AssetsInput) { assets(input: $input) { __typename assets { __typename currencySymbol metadata { __typename decimals isVerified name ticker } tokenName } searchAfter } }"#
    ))

  public var input: GraphQLNullable<AssetsInput>

  public init(input: GraphQLNullable<AssetsInput>) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: MinWalletAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("assets", Assets.self, arguments: ["input": .variable("input")]),
    ] }

    public var assets: Assets { __data["assets"] }

    /// Assets
    ///
    /// Parent Type: `AssetsResponse`
    public struct Assets: MinWalletAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AssetsResponse }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("assets", [Asset].self),
        .field("searchAfter", [String]?.self),
      ] }

      public var assets: [Asset] { __data["assets"] }
      public var searchAfter: [String]? { __data["searchAfter"] }

      /// Assets.Asset
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

        /// Assets.Asset.Metadata
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
