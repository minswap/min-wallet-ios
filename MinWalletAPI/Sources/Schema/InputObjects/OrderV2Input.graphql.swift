// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct OrderV2Input: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    action: GraphQLNullable<GraphQLEnum<OrderV2Action>> = nil,
    address: String,
    ammType: GraphQLNullable<GraphQLEnum<AMMType>> = nil,
    asset: GraphQLNullable<String> = nil,
    fromDate: GraphQLNullable<String> = nil,
    pagination: GraphQLNullable<OrderPaginationCursorInput> = nil,
    status: GraphQLNullable<GraphQLEnum<OrderV2Status>> = nil,
    toDate: GraphQLNullable<String> = nil,
    txId: GraphQLNullable<String> = nil
  ) {
    __data = InputDict([
      "action": action,
      "address": address,
      "ammType": ammType,
      "asset": asset,
      "fromDate": fromDate,
      "pagination": pagination,
      "status": status,
      "toDate": toDate,
      "txId": txId
    ])
  }

  public var action: GraphQLNullable<GraphQLEnum<OrderV2Action>> {
    get { __data["action"] }
    set { __data["action"] = newValue }
  }

  public var address: String {
    get { __data["address"] }
    set { __data["address"] = newValue }
  }

  public var ammType: GraphQLNullable<GraphQLEnum<AMMType>> {
    get { __data["ammType"] }
    set { __data["ammType"] = newValue }
  }

  public var asset: GraphQLNullable<String> {
    get { __data["asset"] }
    set { __data["asset"] = newValue }
  }

  public var fromDate: GraphQLNullable<String> {
    get { __data["fromDate"] }
    set { __data["fromDate"] = newValue }
  }

  public var pagination: GraphQLNullable<OrderPaginationCursorInput> {
    get { __data["pagination"] }
    set { __data["pagination"] = newValue }
  }

  public var status: GraphQLNullable<GraphQLEnum<OrderV2Status>> {
    get { __data["status"] }
    set { __data["status"] = newValue }
  }

  public var toDate: GraphQLNullable<String> {
    get { __data["toDate"] }
    set { __data["toDate"] = newValue }
  }

  public var txId: GraphQLNullable<String> {
    get { __data["txId"] }
    set { __data["txId"] = newValue }
  }
}
