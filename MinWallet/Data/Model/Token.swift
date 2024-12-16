import Foundation
import Then

struct TokenWithPrice: Identifiable, Hashable, Then {
    var id: UUID = UUID()
    var token: Token = .init()
    var price: Double = 0
    var changePercent: Double = 0
}
