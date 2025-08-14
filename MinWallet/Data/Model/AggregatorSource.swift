import SwiftUI


enum AggregatorSource: Int, CaseIterable, Identifiable, Hashable {
    var id: Int { self.rawValue }
    
    case MinswapV2
    case Minswap
    case MinswapStable
    case Splash
    case SplashStable
    case Spectrum
    case SundaeSwapV3
    case SundaeSwap
    case VyFinance
    case WingRidersV2
    case WingRiders
    case WingRidersStableV2
    case MuesliSwap
    
    var name: LocalizedStringKey {
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
        case .WingRidersStableV2:
            "Wingriders Stable V2"
        case .Spectrum:
            "Spectrum"
        case .SplashStable:
            "Splash Stable"
        }
    }
    
    var image: ImageResource {
        switch self {
        case .MinswapV2, .Minswap, .MinswapStable:
            .min
        case .MuesliSwap:
            .icMuliswap
        case .Splash, .SplashStable, .Spectrum:
            .icSplashLogo
        case .SundaeSwapV3, .SundaeSwap:
            .icSundae
        case .VyFinance:
            .icVyfinance
        case .WingRidersV2, .WingRiders, .WingRidersStableV2:
            .icWingriders
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
    
    var rawId: String {
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
        case .WingRidersStableV2:
            "WingRidersStableV2"
        case .Spectrum:
            "Spectrum"
        case .SplashStable:
            "SplashStable"
        }
    }
    
    public init?(title: String) {
        switch title {
        case AggregatorSource.MinswapV2.name.toString():
            self = .MinswapV2
        case AggregatorSource.Minswap.name.toString():
            self = .Minswap
        case AggregatorSource.MinswapStable.name.toString():
            self = .MinswapStable
        case AggregatorSource.MuesliSwap.name.toString():
            self = .MuesliSwap
        case AggregatorSource.Splash.name.toString():
            self = .Splash
        case AggregatorSource.SplashStable.name.toString():
            self = .SplashStable
        case AggregatorSource.Spectrum.name.toString():
            self = .Spectrum
        case AggregatorSource.SundaeSwapV3.name.toString():
            self = .SundaeSwapV3
        case AggregatorSource.SundaeSwap.name.toString():
            self = .SundaeSwap
        case AggregatorSource.VyFinance.name.toString():
            self = .VyFinance
        case AggregatorSource.WingRidersV2.name.toString():
            self = .WingRidersV2
        case AggregatorSource.WingRiders.name.toString():
            self = .WingRiders
        case AggregatorSource.WingRidersStableV2.name.toString():
            self = .WingRidersStableV2
        default:
            self = .Minswap
        }
    }
    public init?(rawId: String) {
        switch rawId {
        case AggregatorSource.MinswapV2.rawId:
            self = .MinswapV2
        case AggregatorSource.Minswap.rawId:
            self = .Minswap
        case AggregatorSource.MinswapStable.rawId:
            self = .MinswapStable
        case AggregatorSource.MuesliSwap.rawId:
            self = .MuesliSwap
        case AggregatorSource.Splash.rawId:
            self = .Splash
        case AggregatorSource.SplashStable.rawId:
            self = .SplashStable
        case AggregatorSource.Spectrum.rawId:
            self = .Spectrum
        case AggregatorSource.SundaeSwapV3.rawId:
            self = .SundaeSwapV3
        case AggregatorSource.SundaeSwap.rawId:
            self = .SundaeSwap
        case AggregatorSource.VyFinance.rawId:
            self = .VyFinance
        case AggregatorSource.WingRidersV2.rawId:
            self = .WingRidersV2
        case AggregatorSource.WingRiders.rawId:
            self = .WingRiders
        case AggregatorSource.WingRidersStableV2.rawId:
            self = .WingRidersStableV2
        default:
            self = .Minswap
        }
    }
}

extension AggregatorSource {
    var nameVersion: String {
        switch self {
        case .MinswapV2, .WingRidersV2, .WingRidersStableV2:
            return "V2"
        case .Minswap, .SundaeSwap, .WingRiders:
            return "V1"
        case .MinswapStable, .SplashStable:
            return "Stable"
        case .MuesliSwap, .Splash, .Spectrum, .VyFinance:
            return ""
        case .SundaeSwapV3:
            return "V3"
        }
    }
}


extension String {
    var foregroundColor: Color? {
        switch self {
        case "V1":
            return .colorDecorativeYellowSub
        case "V2":
            return .colorDecorativeBrandSub
        case "V3":
            return .colorDecorativeRoseSub
        case "Stable":
            return .colorDecorativeLeafSub
        default:
            return nil
        }
    }
    
    var backgroundColor: Color? {
        switch self {
        case "V1":
            return .colorDecorativeYellowDefault
        case "V2":
            return .colorBrandRiver
        case "V3":
            return .colorDecorativeRoseDefault
        case "Stable":
            return .colorDecorativeLeaf
        default:
            return nil
        }
    }
}


enum AggrSource: String {
    case Minswap = "MINSWAP"
    case SteelSwap = "STEELSWAP"
    case DexHunter = "DEX_HUNTER"
    case MuesliSwap = "MUESLISWAP"
    case Cardexscan = "CARDEXSCAN"
    
    var image: ImageResource {
        switch self {
        case .Minswap:
            .min
        case .SteelSwap:
            .steelswap
        case .DexHunter:
            .dexhunter
        case .MuesliSwap:
            .muesliswap
        case .Cardexscan:
            .cardexscan
        }
    }
    
}
