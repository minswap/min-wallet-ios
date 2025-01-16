// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension Unions {
  static let OrderOverSlippageDetail = Union(
    name: "OrderOverSlippageDetail",
    possibleTypes: [
      Objects.DepositOverSlippageDetail.self,
      Objects.DexV2WithdrawImbalanceOverSlippageDetail.self,
      Objects.OCOOverSlipageDetail.self,
      Objects.PartialFillOverSlippageDetail.self,
      Objects.RoutingOverSlipageDetail.self,
      Objects.StableswapWithdrawImbalanceOverSlippageDetail.self,
      Objects.StopOverSlippageDetail.self,
      Objects.SwapExactInOverSlippageDetail.self,
      Objects.SwapExactOutOverSlippageDetail.self,
      Objects.WithdrawOverSlippageDetail.self,
      Objects.ZapInOverSlippageDetail.self,
      Objects.ZapOutOverSlippageDetail.self
    ]
  )
}