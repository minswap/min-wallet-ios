import SwiftUI


struct DashedUnderlineText: UIViewRepresentable {
    let text: LocalizedStringKey
    var textColor: UIColor = .white
    var font: UIFont? = .systemFont(ofSize: 14)
    
    func makeUIView(context: Context) -> UILabel {
        let text = text.toString()
        let label = UILabel()
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .horizontal)
        let attributedString = NSMutableAttributedString(string: text)
        let underlineStyle = NSUnderlineStyle.patternDash.rawValue | NSUnderlineStyle.single.rawValue
        
        attributedString.addAttribute(
            .underlineStyle,
            value: underlineStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )
        
        attributedString.addAttributes(
            [
                NSAttributedString.Key.baselineOffset: 5,
                NSAttributedString.Key.font: font ?? .systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: textColor,
                
            ], range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {}
}

extension LocalizedStringKey {
    func toString() -> String {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if child.label == "key" {
                return child.value as? String ?? ""
            }
        }
        return ""
    }
}
