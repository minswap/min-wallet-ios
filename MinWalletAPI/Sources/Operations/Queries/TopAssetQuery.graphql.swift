// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class TopAssetQuery: GraphQLQuery {
  public static let operationName: String = "TopAssetQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query TopAssetQuery { topAssets { __typename searchAfter } }"#
    ))

  public init() {}

  public struct Data: MinWalletAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("topAssets", TopAssets.self),
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
      ] }

      public var searchAfter: [String]? { __data["searchAfter"] }
    }
  }
}
