import Foundation


struct SwapTokenSetting {
    var predictSwapPrice  : Bool   = true
    var routeSorting      : RouteSorting   = .most
    var autoRouter        : Bool   = true
    var slippageTolerance : String = ""
    var slippageSelected:  SwapTokenSettingView.Slippage? = ._01
    
    init() {}
}

extension SwapTokenSetting {
    enum RouteSorting {
        case most
        case high
    }
}
