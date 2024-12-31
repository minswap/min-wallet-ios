import SwiftUI
import Then
import MinWalletAPI

typealias ContractType = AMMType

extension OrderV2Action: Identifiable {
    public var id: String { UUID().uuidString }

    var title: LocalizedStringKey {
        switch self {
        case .deposit:
            "Deposit"
        case .donation:
            "Donation"
        case .limit:
            "Limit"
        case .market:
            "Market"
        case .oco:
            "OCO"
        case .partialSwap:
            "Partial swap"
        case .stopLoss:
            "Stop loss"
        case .withdraw:
            "Withdraw"
        case .zapIn:
            "Zap in"
        case .zapOut:
            "Zap out"
        }
    }
}

extension OrderV2Status: Identifiable {
    public var id: String { UUID().uuidString }

    var title: LocalizedStringKey {
        switch self {
        case .batched:
            "Completed"
        case .cancelled:
            "Cancelled"
        case .created:
            "Pending"
        }
    }
}

extension ContractType: Identifiable {
    public var id: String { UUID().uuidString }
    
    var title: LocalizedStringKey {
        switch self {
        case .dex:
            "V1"
        case .dexV2:
            "V2"
        case .stableswap:
            "Stableswap"
        }
    }
}
