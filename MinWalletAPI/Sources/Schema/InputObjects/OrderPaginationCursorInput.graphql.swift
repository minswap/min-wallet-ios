// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct OrderPaginationCursorInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    stableswap: GraphQLNullable<BigInt> = nil,
    v1: GraphQLNullable<BigInt> = nil,
    v2: GraphQLNullable<BigInt> = nil
  ) {
    __data = InputDict([
      "stableswap": stableswap,
      "v1": v1,
      "v2": v2
    ])
  }

  public var stableswap: GraphQLNullable<BigInt> {
    get { __data["stableswap"] }
    set { __data["stableswap"] = newValue }
  }

  public var v1: GraphQLNullable<BigInt> {
    get { __data["v1"] }
    set { __data["v1"] = newValue }
  }

  public var v2: GraphQLNullable<BigInt> {
    get { __data["v2"] }
    set { __data["v2"] = newValue }
  }
}
