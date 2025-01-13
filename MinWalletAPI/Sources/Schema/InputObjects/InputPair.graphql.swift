// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct InputPair: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    assetA: InputAsset,
    assetB: InputAsset
  ) {
    __data = InputDict([
      "assetA": assetA,
      "assetB": assetB
    ])
  }

  public var assetA: InputAsset {
    get { __data["assetA"] }
    set { __data["assetA"] = newValue }
  }

  public var assetB: InputAsset {
    get { __data["assetB"] }
    set { __data["assetB"] = newValue }
  }
}
