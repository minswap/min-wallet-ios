import Foundation


struct TokenWithPrice: Identifiable, Hashable {
    let id: UUID
    let token: Token
    let price: Double
    let changePercent: Double
}
