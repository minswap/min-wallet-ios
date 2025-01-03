import Foundation


struct WrapTokenModel: Hashable {
    private let _isEqual: (WrapTokenModel) -> Bool
    let uniquedID: UUID = UUID()
    let base: TokenProtocol
    
    init<T: TokenProtocol & Equatable>(_ value: T) {
        self.base = value
        self._isEqual = { other in
            guard let otherBase = other.base as? T else { return false }
            return value == otherBase
        }
    }
    
    static func == (lhs: WrapTokenModel, rhs: WrapTokenModel) -> Bool {
        lhs._isEqual(rhs)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uniquedID)
    }
}
