import Foundation


enum AggregatorSource: Int, CaseIterable {
    case MinswapV2
    case Minswap
    case MinswapStable
    case MuesliSwap
    case Splash
    case SplashStable
    case Spectrum
    case SundaeSwapV3
    case SundaeSwap
    case VyFinance
    case WingRidersV2
    case WingRiders
    case WingRidersStableV1
    case WingRidersStableV2

    var name: String {
        switch self {
        case .MinswapV2:
            "Minswap V2"
        case .Minswap:
            "Minswap V1"
        case .MinswapStable:
            "Minswap Stable"
        case .MuesliSwap:
            "MuesliSwap"
        case .Splash:
            "Splash"
        case .SundaeSwapV3:
            "Sundae V3"
        case .SundaeSwap:
            "Sundae V1"
        case .VyFinance:
            "VyFinance"
        case .WingRidersV2:
            "Wingriders V2"
        case .WingRiders:
            "Wingriders V1"
        case .WingRidersStableV1:
            "Wingriders Stable V1"
        case .WingRidersStableV2:
            "Wingriders Stable V2"
        case .Spectrum:
            "Spectrum"
        case .SplashStable:
            "Splash Stable"
        }
    }

    var image: String {
        switch self {
        case .MinswapV2:
            "Minswap V2"
        case .Minswap:
            "Minswap V1"
        case .MinswapStable:
            "Minswap Stable"
        case .MuesliSwap:
            "MuesliSwap"
        case .Splash:
            "Splash"
        case .SundaeSwapV3:
            "Sundae V3"
        case .SundaeSwap:
            "Sundae V1"
        case .VyFinance:
            "VyFinance"
        case .WingRidersV2:
            "Wingriders V2"
        case .WingRiders:
            "Wingriders V1"
        case .WingRidersStableV1:
            "Wingriders Stable V1"
        case .WingRidersStableV2:
            "Wingriders Stable V2"
        case .Spectrum:
            "Spectrum"
        case .SplashStable:
            "Splash Stable"
        }
    }

    var isLocked: Bool {
        switch self {
        case .MinswapV2, .Minswap, .MinswapStable:
            true
        default:
            false
        }
    }
    
    var id: String {
        switch self {
            case .MinswapV2:
                "MinswapV2"
            case .Minswap:
                "Minswap"
            case .MinswapStable:
                "MinswapStable"
            case .MuesliSwap:
                "MuesliSwap"
            case .Splash:
                "Splash"
            case .SundaeSwapV3:
                "SundaeSwapV3"
            case .SundaeSwap:
                "SundaeSwap"
            case .VyFinance:
                "VyFinance"
            case .WingRidersV2:
                "WingRidersV2"
            case .WingRiders:
                "WingRiders"
            case .WingRidersStableV1:
                "WingRidersStableV1"
            case .WingRidersStableV2:
                "WingRidersStableV2"
            case .Spectrum:
                "Spectrum"
            case .SplashStable:
                "SplashStable"
        }
    }
}
