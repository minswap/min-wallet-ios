// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct AssetsInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    onlyVerified: GraphQLNullable<Bool> = nil,
    searchAfter: GraphQLNullable<[String]> = nil,
    term: GraphQLNullable<String> = nil
  ) {
    __data = InputDict([
      "onlyVerified": onlyVerified,
      "searchAfter": searchAfter,
      "term": term
    ])
  }

  public var onlyVerified: GraphQLNullable<Bool> {
    get { __data["onlyVerified"] }
    set { __data["onlyVerified"] = newValue }
  }

  public var searchAfter: GraphQLNullable<[String]> {
    get { __data["searchAfter"] }
    set { __data["searchAfter"] = newValue }
  }

  public var term: GraphQLNullable<String> {
    get { __data["term"] }
    set { __data["term"] = newValue }
  }
}
