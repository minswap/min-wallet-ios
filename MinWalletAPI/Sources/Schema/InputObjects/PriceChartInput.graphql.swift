// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct PriceChartInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    assetIn: InputAsset,
    assetOut: InputAsset,
    lpAsset: InputAsset,
    period: GraphQLEnum<ChartPeriod>
  ) {
    __data = InputDict([
      "assetIn": assetIn,
      "assetOut": assetOut,
      "lpAsset": lpAsset,
      "period": period
    ])
  }

  public var assetIn: InputAsset {
    get { __data["assetIn"] }
    set { __data["assetIn"] = newValue }
  }

  public var assetOut: InputAsset {
    get { __data["assetOut"] }
    set { __data["assetOut"] = newValue }
  }

  public var lpAsset: InputAsset {
    get { __data["lpAsset"] }
    set { __data["lpAsset"] = newValue }
  }

  public var period: GraphQLEnum<ChartPeriod> {
    get { __data["period"] }
    set { __data["period"] = newValue }
  }
}
