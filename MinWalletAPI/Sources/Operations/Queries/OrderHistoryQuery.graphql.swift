// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class OrderHistoryQuery: GraphQLQuery {
  public static let operationName: String = "OrderHistoryQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query OrderHistoryQuery($ordersInput2: OrderV2Input!) { orders(input: $ordersInput2) { __typename orders { __typename action createdAt details type txIn { __typename txId txIndex } expiredAt linkedPools { __typename assets { __typename currencySymbol metadata { __typename decimals isVerified name ticker } tokenName } lpAsset { __typename currencySymbol metadata { __typename isVerified decimals ticker name } tokenName } } status } } }"#
    ))

  public var ordersInput2: OrderV2Input

  public init(ordersInput2: OrderV2Input) {
    self.ordersInput2 = ordersInput2
  }

  public var __variables: Variables? { ["ordersInput2": ordersInput2] }

  public struct Data: MinWalletAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("orders", Orders.self, arguments: ["input": .variable("ordersInput2")]),
    ] }

    public var orders: Orders { __data["orders"] }

    /// Orders
    ///
    /// Parent Type: `OrderHistoryResponse`
    public struct Orders: MinWalletAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.OrderHistoryResponse }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("orders", [Order].self),
      ] }

      public var orders: [Order] { __data["orders"] }

      /// Orders.Order
      ///
      /// Parent Type: `OrderHistory`
      public struct Order: MinWalletAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.OrderHistory }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("action", GraphQLEnum<MinWalletAPI.OrderV2Action>.self),
          .field("createdAt", String.self),
          .field("details", String.self),
          .field("type", GraphQLEnum<MinWalletAPI.AMMType>.self),
          .field("txIn", TxIn.self),
          .field("expiredAt", String?.self),
          .field("linkedPools", [LinkedPool].self),
          .field("status", GraphQLEnum<MinWalletAPI.OrderV2Status>.self),
        ] }

        public var action: GraphQLEnum<MinWalletAPI.OrderV2Action> { __data["action"] }
        public var createdAt: String { __data["createdAt"] }
        public var details: String { __data["details"] }
        public var type: GraphQLEnum<MinWalletAPI.AMMType> { __data["type"] }
        public var txIn: TxIn { __data["txIn"] }
        public var expiredAt: String? { __data["expiredAt"] }
        public var linkedPools: [LinkedPool] { __data["linkedPools"] }
        public var status: GraphQLEnum<MinWalletAPI.OrderV2Status> { __data["status"] }

        /// Orders.Order.TxIn
        ///
        /// Parent Type: `TxIn`
        public struct TxIn: MinWalletAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.TxIn }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("txId", String.self),
            .field("txIndex", Int.self),
          ] }

          public var txId: String { __data["txId"] }
          public var txIndex: Int { __data["txIndex"] }
        }

        /// Orders.Order.LinkedPool
        ///
        /// Parent Type: `OrderLinkedPool`
        public struct LinkedPool: MinWalletAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.OrderLinkedPool }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("assets", [Asset].self),
            .field("lpAsset", LpAsset.self),
          ] }

          public var assets: [Asset] { __data["assets"] }
          public var lpAsset: LpAsset { __data["lpAsset"] }

          /// Orders.Order.LinkedPool.Asset
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

            /// Orders.Order.LinkedPool.Asset.Metadata
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

          /// Orders.Order.LinkedPool.LpAsset
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

            /// Orders.Order.LinkedPool.LpAsset.Metadata
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
}
