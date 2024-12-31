// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class PortfolioOverviewQuery: GraphQLQuery {
  public static let operationName: String = "PortfolioOverviewQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query PortfolioOverviewQuery($address: String!) { portfolioOverview(address: $address) { __typename netAdaValue pnl24H adaValue } }"#
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
      .field("portfolioOverview", PortfolioOverview.self, arguments: ["address": .variable("address")]),
    ] }

    public var portfolioOverview: PortfolioOverview { __data["portfolioOverview"] }

    /// PortfolioOverview
    ///
    /// Parent Type: `PortfolioOverview`
    public struct PortfolioOverview: MinWalletAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.PortfolioOverview }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("netAdaValue", MinWalletAPI.BigInt.self),
        .field("pnl24H", MinWalletAPI.BigInt.self),
        .field("adaValue", MinWalletAPI.BigInt.self),
      ] }

      public var netAdaValue: MinWalletAPI.BigInt { __data["netAdaValue"] }
      public var pnl24H: MinWalletAPI.BigInt { __data["pnl24H"] }
      public var adaValue: MinWalletAPI.BigInt { __data["adaValue"] }
    }
  }
}
