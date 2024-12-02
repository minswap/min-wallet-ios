import SwiftUI

extension String {
    var shortenAddress: String {
        if self.count <= 12 {
            return self
        }
        
        let first6Characters = self.prefix(6)
        let last6Characters = self.suffix(6)
        return "\(first6Characters)...\(last6Characters)"
    }
}


extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
