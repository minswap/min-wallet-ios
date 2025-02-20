// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class OrderHistoryQuery: GraphQLQuery {
  public static let operationName: String = "OrderHistoryQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query OrderHistoryQuery($ordersInput2: OrderV2Input!) { orders(input: $ordersInput2) { __typename orders { __typename action createdAt details type txIn { __typename txId } expiredAt linkedPools { __typename assets { __typename currencySymbol metadata { __typename decimals isVerified name ticker } tokenName } lpAsset { __typename currencySymbol metadata { __typename isVerified decimals ticker name } tokenName } } status updatedAt updatedTxId overSlippage { __typename ... on DepositOverSlippageDetail { receivedLPAmount type } ... on DexV2WithdrawImbalanceOverSlippageDetail { receivedAmountA receivedAmountB type } ... on OCOOverSlipageDetail { receivedAmount type } ... on PartialFillOverSlippageDetail { swapableAmount type } ... on RoutingOverSlipageDetail { receivedAmount type } ... on StableswapWithdrawImbalanceOverSlippageDetail { necessaryLPAmount type } ... on StopOverSlippageDetail { receivedAmount type } ... on SwapExactInOverSlippageDetail { maxReceivableOut receivedAmount type } ... on SwapExactOutOverSlippageDetail { maxReceivableOut necessarySwapAmount type } ... on WithdrawOverSlippageDetail { maxWithdrawawls receivedAmounts type } ... on ZapInOverSlippageDetail { receivedLPAmount type } ... on ZapOutOverSlippageDetail { receivedAmount type } } datum } cursor { __typename stableswap v1 v2 } } }"#
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
        .field("cursor", Cursor.self),
      ] }

      public var orders: [Order] { __data["orders"] }
      public var cursor: Cursor { __data["cursor"] }

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
          .field("updatedAt", String?.self),
          .field("updatedTxId", String?.self),
          .field("overSlippage", OverSlippage?.self),
          .field("datum", String.self),
        ] }

        public var action: GraphQLEnum<MinWalletAPI.OrderV2Action> { __data["action"] }
        public var createdAt: String { __data["createdAt"] }
        public var details: String { __data["details"] }
        public var type: GraphQLEnum<MinWalletAPI.AMMType> { __data["type"] }
        public var txIn: TxIn { __data["txIn"] }
        public var expiredAt: String? { __data["expiredAt"] }
        public var linkedPools: [LinkedPool] { __data["linkedPools"] }
        public var status: GraphQLEnum<MinWalletAPI.OrderV2Status> { __data["status"] }
        public var updatedAt: String? { __data["updatedAt"] }
        public var updatedTxId: String? { __data["updatedTxId"] }
        public var overSlippage: OverSlippage? { __data["overSlippage"] }
        public var datum: String { __data["datum"] }

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
          ] }

          public var txId: String { __data["txId"] }
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

        /// Orders.Order.OverSlippage
        ///
        /// Parent Type: `OrderOverSlippageDetail`
        public struct OverSlippage: MinWalletAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Unions.OrderOverSlippageDetail }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .inlineFragment(AsDepositOverSlippageDetail.self),
            .inlineFragment(AsDexV2WithdrawImbalanceOverSlippageDetail.self),
            .inlineFragment(AsOCOOverSlipageDetail.self),
            .inlineFragment(AsPartialFillOverSlippageDetail.self),
            .inlineFragment(AsRoutingOverSlipageDetail.self),
            .inlineFragment(AsStableswapWithdrawImbalanceOverSlippageDetail.self),
            .inlineFragment(AsStopOverSlippageDetail.self),
            .inlineFragment(AsSwapExactInOverSlippageDetail.self),
            .inlineFragment(AsSwapExactOutOverSlippageDetail.self),
            .inlineFragment(AsWithdrawOverSlippageDetail.self),
            .inlineFragment(AsZapInOverSlippageDetail.self),
            .inlineFragment(AsZapOutOverSlippageDetail.self),
          ] }

          public var asDepositOverSlippageDetail: AsDepositOverSlippageDetail? { _asInlineFragment() }
          public var asDexV2WithdrawImbalanceOverSlippageDetail: AsDexV2WithdrawImbalanceOverSlippageDetail? { _asInlineFragment() }
          public var asOCOOverSlipageDetail: AsOCOOverSlipageDetail? { _asInlineFragment() }
          public var asPartialFillOverSlippageDetail: AsPartialFillOverSlippageDetail? { _asInlineFragment() }
          public var asRoutingOverSlipageDetail: AsRoutingOverSlipageDetail? { _asInlineFragment() }
          public var asStableswapWithdrawImbalanceOverSlippageDetail: AsStableswapWithdrawImbalanceOverSlippageDetail? { _asInlineFragment() }
          public var asStopOverSlippageDetail: AsStopOverSlippageDetail? { _asInlineFragment() }
          public var asSwapExactInOverSlippageDetail: AsSwapExactInOverSlippageDetail? { _asInlineFragment() }
          public var asSwapExactOutOverSlippageDetail: AsSwapExactOutOverSlippageDetail? { _asInlineFragment() }
          public var asWithdrawOverSlippageDetail: AsWithdrawOverSlippageDetail? { _asInlineFragment() }
          public var asZapInOverSlippageDetail: AsZapInOverSlippageDetail? { _asInlineFragment() }
          public var asZapOutOverSlippageDetail: AsZapOutOverSlippageDetail? { _asInlineFragment() }

          /// Orders.Order.OverSlippage.AsDepositOverSlippageDetail
          ///
          /// Parent Type: `DepositOverSlippageDetail`
          public struct AsDepositOverSlippageDetail: MinWalletAPI.InlineFragment {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public typealias RootEntityType = OrderHistoryQuery.Data.Orders.Order.OverSlippage
            public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.DepositOverSlippageDetail }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("receivedLPAmount", MinWalletAPI.BigInt.self),
              .field("type", GraphQLEnum<MinWalletAPI.OrderOverSlippage>.self),
            ] }

            public var receivedLPAmount: MinWalletAPI.BigInt { __data["receivedLPAmount"] }
            public var type: GraphQLEnum<MinWalletAPI.OrderOverSlippage> { __data["type"] }
          }

          /// Orders.Order.OverSlippage.AsDexV2WithdrawImbalanceOverSlippageDetail
          ///
          /// Parent Type: `DexV2WithdrawImbalanceOverSlippageDetail`
          public struct AsDexV2WithdrawImbalanceOverSlippageDetail: MinWalletAPI.InlineFragment {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public typealias RootEntityType = OrderHistoryQuery.Data.Orders.Order.OverSlippage
            public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.DexV2WithdrawImbalanceOverSlippageDetail }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("receivedAmountA", MinWalletAPI.BigInt.self),
              .field("receivedAmountB", MinWalletAPI.BigInt.self),
              .field("type", GraphQLEnum<MinWalletAPI.OrderOverSlippage>.self),
            ] }

            public var receivedAmountA: MinWalletAPI.BigInt { __data["receivedAmountA"] }
            public var receivedAmountB: MinWalletAPI.BigInt { __data["receivedAmountB"] }
            public var type: GraphQLEnum<MinWalletAPI.OrderOverSlippage> { __data["type"] }
          }

          /// Orders.Order.OverSlippage.AsOCOOverSlipageDetail
          ///
          /// Parent Type: `OCOOverSlipageDetail`
          public struct AsOCOOverSlipageDetail: MinWalletAPI.InlineFragment {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public typealias RootEntityType = OrderHistoryQuery.Data.Orders.Order.OverSlippage
            public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.OCOOverSlipageDetail }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("receivedAmount", MinWalletAPI.BigInt.self),
              .field("type", GraphQLEnum<MinWalletAPI.OrderOverSlippage>.self),
            ] }

            public var receivedAmount: MinWalletAPI.BigInt { __data["receivedAmount"] }
            public var type: GraphQLEnum<MinWalletAPI.OrderOverSlippage> { __data["type"] }
          }

          /// Orders.Order.OverSlippage.AsPartialFillOverSlippageDetail
          ///
          /// Parent Type: `PartialFillOverSlippageDetail`
          public struct AsPartialFillOverSlippageDetail: MinWalletAPI.InlineFragment {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public typealias RootEntityType = OrderHistoryQuery.Data.Orders.Order.OverSlippage
            public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.PartialFillOverSlippageDetail }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("swapableAmount", MinWalletAPI.BigInt.self),
              .field("type", GraphQLEnum<MinWalletAPI.OrderOverSlippage>.self),
            ] }

            public var swapableAmount: MinWalletAPI.BigInt { __data["swapableAmount"] }
            public var type: GraphQLEnum<MinWalletAPI.OrderOverSlippage> { __data["type"] }
          }

          /// Orders.Order.OverSlippage.AsRoutingOverSlipageDetail
          ///
          /// Parent Type: `RoutingOverSlipageDetail`
          public struct AsRoutingOverSlipageDetail: MinWalletAPI.InlineFragment {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public typealias RootEntityType = OrderHistoryQuery.Data.Orders.Order.OverSlippage
            public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.RoutingOverSlipageDetail }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("receivedAmount", MinWalletAPI.BigInt.self),
              .field("type", GraphQLEnum<MinWalletAPI.OrderOverSlippage>.self),
            ] }

            public var receivedAmount: MinWalletAPI.BigInt { __data["receivedAmount"] }
            public var type: GraphQLEnum<MinWalletAPI.OrderOverSlippage> { __data["type"] }
          }

          /// Orders.Order.OverSlippage.AsStableswapWithdrawImbalanceOverSlippageDetail
          ///
          /// Parent Type: `StableswapWithdrawImbalanceOverSlippageDetail`
          public struct AsStableswapWithdrawImbalanceOverSlippageDetail: MinWalletAPI.InlineFragment {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public typealias RootEntityType = OrderHistoryQuery.Data.Orders.Order.OverSlippage
            public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.StableswapWithdrawImbalanceOverSlippageDetail }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("necessaryLPAmount", MinWalletAPI.BigInt.self),
              .field("type", GraphQLEnum<MinWalletAPI.OrderOverSlippage>.self),
            ] }

            public var necessaryLPAmount: MinWalletAPI.BigInt { __data["necessaryLPAmount"] }
            public var type: GraphQLEnum<MinWalletAPI.OrderOverSlippage> { __data["type"] }
          }

          /// Orders.Order.OverSlippage.AsStopOverSlippageDetail
          ///
          /// Parent Type: `StopOverSlippageDetail`
          public struct AsStopOverSlippageDetail: MinWalletAPI.InlineFragment {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public typealias RootEntityType = OrderHistoryQuery.Data.Orders.Order.OverSlippage
            public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.StopOverSlippageDetail }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("receivedAmount", MinWalletAPI.BigInt.self),
              .field("type", GraphQLEnum<MinWalletAPI.OrderOverSlippage>.self),
            ] }

            public var receivedAmount: MinWalletAPI.BigInt { __data["receivedAmount"] }
            public var type: GraphQLEnum<MinWalletAPI.OrderOverSlippage> { __data["type"] }
          }

          /// Orders.Order.OverSlippage.AsSwapExactInOverSlippageDetail
          ///
          /// Parent Type: `SwapExactInOverSlippageDetail`
          public struct AsSwapExactInOverSlippageDetail: MinWalletAPI.InlineFragment {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public typealias RootEntityType = OrderHistoryQuery.Data.Orders.Order.OverSlippage
            public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.SwapExactInOverSlippageDetail }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("maxReceivableOut", MinWalletAPI.BigInt?.self),
              .field("receivedAmount", MinWalletAPI.BigInt.self),
              .field("type", GraphQLEnum<MinWalletAPI.OrderOverSlippage>.self),
            ] }

            public var maxReceivableOut: MinWalletAPI.BigInt? { __data["maxReceivableOut"] }
            public var receivedAmount: MinWalletAPI.BigInt { __data["receivedAmount"] }
            public var type: GraphQLEnum<MinWalletAPI.OrderOverSlippage> { __data["type"] }
          }

          /// Orders.Order.OverSlippage.AsSwapExactOutOverSlippageDetail
          ///
          /// Parent Type: `SwapExactOutOverSlippageDetail`
          public struct AsSwapExactOutOverSlippageDetail: MinWalletAPI.InlineFragment {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public typealias RootEntityType = OrderHistoryQuery.Data.Orders.Order.OverSlippage
            public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.SwapExactOutOverSlippageDetail }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("maxReceivableOut", MinWalletAPI.BigInt?.self),
              .field("necessarySwapAmount", MinWalletAPI.BigInt.self),
              .field("type", GraphQLEnum<MinWalletAPI.OrderOverSlippage>.self),
            ] }

            public var maxReceivableOut: MinWalletAPI.BigInt? { __data["maxReceivableOut"] }
            public var necessarySwapAmount: MinWalletAPI.BigInt { __data["necessarySwapAmount"] }
            public var type: GraphQLEnum<MinWalletAPI.OrderOverSlippage> { __data["type"] }
          }

          /// Orders.Order.OverSlippage.AsWithdrawOverSlippageDetail
          ///
          /// Parent Type: `WithdrawOverSlippageDetail`
          public struct AsWithdrawOverSlippageDetail: MinWalletAPI.InlineFragment {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public typealias RootEntityType = OrderHistoryQuery.Data.Orders.Order.OverSlippage
            public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.WithdrawOverSlippageDetail }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("maxWithdrawawls", [MinWalletAPI.BigInt]?.self),
              .field("receivedAmounts", [MinWalletAPI.BigInt].self),
              .field("type", GraphQLEnum<MinWalletAPI.OrderOverSlippage>.self),
            ] }

            public var maxWithdrawawls: [MinWalletAPI.BigInt]? { __data["maxWithdrawawls"] }
            public var receivedAmounts: [MinWalletAPI.BigInt] { __data["receivedAmounts"] }
            public var type: GraphQLEnum<MinWalletAPI.OrderOverSlippage> { __data["type"] }
          }

          /// Orders.Order.OverSlippage.AsZapInOverSlippageDetail
          ///
          /// Parent Type: `ZapInOverSlippageDetail`
          public struct AsZapInOverSlippageDetail: MinWalletAPI.InlineFragment {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public typealias RootEntityType = OrderHistoryQuery.Data.Orders.Order.OverSlippage
            public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.ZapInOverSlippageDetail }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("receivedLPAmount", MinWalletAPI.BigInt.self),
              .field("type", GraphQLEnum<MinWalletAPI.OrderOverSlippage>.self),
            ] }

            public var receivedLPAmount: MinWalletAPI.BigInt { __data["receivedLPAmount"] }
            public var type: GraphQLEnum<MinWalletAPI.OrderOverSlippage> { __data["type"] }
          }

          /// Orders.Order.OverSlippage.AsZapOutOverSlippageDetail
          ///
          /// Parent Type: `ZapOutOverSlippageDetail`
          public struct AsZapOutOverSlippageDetail: MinWalletAPI.InlineFragment {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public typealias RootEntityType = OrderHistoryQuery.Data.Orders.Order.OverSlippage
            public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.ZapOutOverSlippageDetail }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("receivedAmount", MinWalletAPI.BigInt.self),
              .field("type", GraphQLEnum<MinWalletAPI.OrderOverSlippage>.self),
            ] }

            public var receivedAmount: MinWalletAPI.BigInt { __data["receivedAmount"] }
            public var type: GraphQLEnum<MinWalletAPI.OrderOverSlippage> { __data["type"] }
          }
        }
      }

      /// Orders.Cursor
      ///
      /// Parent Type: `OrderPaginationCursor`
      public struct Cursor: MinWalletAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { MinWalletAPI.Objects.OrderPaginationCursor }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("stableswap", MinWalletAPI.BigInt?.self),
          .field("v1", MinWalletAPI.BigInt?.self),
          .field("v2", MinWalletAPI.BigInt?.self),
        ] }

        public var stableswap: MinWalletAPI.BigInt? { __data["stableswap"] }
        public var v1: MinWalletAPI.BigInt? { __data["v1"] }
        public var v2: MinWalletAPI.BigInt? { __data["v2"] }
      }
    }
  }
}
