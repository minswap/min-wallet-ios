// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct InputCancelBulkOrders: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    changeAddress: String,
    orders: [InputCancelOrder],
    type: GraphQLEnum<CancelOrderType>
  ) {
    __data = InputDict([
      "changeAddress": changeAddress,
      "orders": orders,
      "type": type
    ])
  }

  public var changeAddress: String {
    get { __data["changeAddress"] }
    set { __data["changeAddress"] = newValue }
  }

  public var orders: [InputCancelOrder] {
    get { __data["orders"] }
    set { __data["orders"] = newValue }
  }

  public var type: GraphQLEnum<CancelOrderType> {
    get { __data["type"] }
    set { __data["type"] = newValue }
  }
}
