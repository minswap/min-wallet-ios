// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class AdaPriceQuery: GraphQLQuery {
  public static let operationName: String = "AdaPriceQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query AdaPriceQuery($currency: SupportedCurrency!) { adaPrice(currency: $currency) { __typename value currency } }"#
    ))

  public var currency: GraphQLEnum<SupportedCurrency>

  public init(currency: GraphQLEnum<SupportedCurrency>) {
    self.currency = currency
  }

  public var __variables: Variables? { ["currency": currency] }

  public struct Data: MinWalletAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("adaPrice", AdaPrice.self, arguments: ["currency": .variable("currency")]),
    ] }

    public var adaPrice: AdaPrice { __data["adaPrice"] }

    /// AdaPrice
    ///
    /// Parent Type: `AdaPrice`
    public struct AdaPrice: MinWalletAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.AdaPrice }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("value", Double?.self),
        .field("currency", GraphQLEnum<MinWalletAPI.SupportedCurrency>.self),
      ] }

      public var value: Double? { __data["value"] }
      public var currency: GraphQLEnum<MinWalletAPI.SupportedCurrency> { __data["currency"] }
    }
  }
}
