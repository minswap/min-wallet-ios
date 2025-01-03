// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class PriceChartQuery: GraphQLQuery {
  public static let operationName: String = "PriceChartQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query PriceChartQuery($input: PriceChartInput!) { priceChart(input: $input) { __typename time value } }"#
    ))

  public var input: PriceChartInput

  public init(input: PriceChartInput) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: MinWalletAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("priceChart", [PriceChart].self, arguments: ["input": .variable("input")]),
    ] }

    public var priceChart: [PriceChart] { __data["priceChart"] }

    /// PriceChart
    ///
    /// Parent Type: `SimpleChart`
    public struct PriceChart: MinWalletAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.SimpleChart }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("time", String.self),
        .field("value", String.self),
      ] }

      public var time: String { __data["time"] }
      public var value: String { __data["value"] }
    }
  }
}
