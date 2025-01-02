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

    var doubleValue: Double {
        Double(self) ?? 0
    }

    var hexToText: String? {
        var hexStr = self
        var text = ""

        while hexStr.count >= 2 {
            let hexChar = String(hexStr.prefix(2))
            hexStr = String(hexStr.dropFirst(2))

            if let charCode = UInt8(hexChar, radix: 16) {
                text.append(Character(UnicodeScalar(charCode)))
            } else {
                return nil
            }
        }

        return text
    }
    
    var formattedDateGMT: String {
        let inputDateString = self
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = inputFormatter.date(from: inputDateString) else {
            return self
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd HH:mm 'GMT'XXX"

        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        return outputFormatter.string(from: date)
    }
    
    var adaName: String? {
        if self.count < 6 {
            return self
        }
        if self.count == 6 {
            return self.hexToText
        }
        
        return self.shortenAddress
    }
}


extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}


extension Double {
    var formatNumber: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.usesGroupingSeparator = true
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }

    func formatNumber(
        prefix: String = "",
        suffix: String = "",
        roundingOffset: Int = 3,
        font: Font = .labelMediumSecondary,
        fontColor: Color = .colorBaseTent
    ) -> AttributedString {
        var prefix: AttributedString = AttributedString(prefix)
        prefix.font = font
        prefix.foregroundColor = fontColor
        var suffix: AttributedString = AttributedString(suffix.isEmpty ? "" : " \(suffix)")
        suffix.font = font
        suffix.foregroundColor = fontColor

        var result = AttributedString(self.formatted())
        result.font = font
        result.foregroundColor = fontColor

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.usesGroupingSeparator = true
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 15
        formatter.minimumFractionDigits = 0

        guard let formattedString = formatter.string(from: NSNumber(value: self))
        else {
            prefix.append(result)
            prefix.append(suffix)
            return prefix
        }

        result = AttributedString(formattedString)
        result.font = font
        result.foregroundColor = fontColor

        let components = formattedString.components(separatedBy: ".")

        guard components.count > 1
        else {
            prefix.append(result)
            prefix.append(suffix)
            return prefix
        }

        let decimalPart = components[1]

        result = AttributedString("")
        result.append(AttributedString(components[0] + "."))

        var zerosCount = 0
        var startIndex = decimalPart.startIndex

        for char in decimalPart {
            if char == "0" {
                zerosCount += 1
            } else {
                break
            }
            startIndex = decimalPart.index(after: startIndex)
        }

        let roundingIndex = decimalPart.index(startIndex, offsetBy: roundingOffset, limitedBy: decimalPart.endIndex) ?? decimalPart.endIndex
        let roundedDecimal = String(decimalPart[startIndex..<roundingIndex])

        if zerosCount >= 4 {
            result.append(AttributedString("0"))
            result.font = font
            result.foregroundColor = fontColor

            var subscriptText = AttributedString(String(zerosCount))
            subscriptText.font = .paragraphXSmall
            subscriptText.foregroundColor = fontColor
            subscriptText.baselineOffset = -4

            result.append(subscriptText)

            var roundedAtt = AttributedString(roundedDecimal)
            roundedAtt.font = font
            roundedAtt.foregroundColor = fontColor
            result.append(roundedAtt)
        } else {
            let subNumber = String(repeating: "0", count: zerosCount)
            result.append(AttributedString(subNumber))
            result.append(AttributedString(roundedDecimal))
            result.font = font
            result.foregroundColor = fontColor
        }

        prefix.append(result)
        prefix.append(suffix)
        return prefix
    }
}
