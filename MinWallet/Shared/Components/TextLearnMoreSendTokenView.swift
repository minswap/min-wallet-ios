import SwiftUI
import SwiftyAttributes


struct TextLearnMoreSendTokenView: UIViewRepresentable {
    let text: LocalizedStringKey
    let textClickAble: LocalizedStringKey

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.onViewTap(recognizer:)))
        tapGesture.delegate = context.coordinator
        tapGesture.numberOfTapsRequired = 1
        label.addGestureRecognizer(tapGesture)

        context.coordinator.label = label
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        context.coordinator.label = uiView
        uiView.attributedText = context.coordinator.getAttributedText(text: text, textClickAble: textClickAble)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var parent: TextLearnMoreSendTokenView
        weak var label: UILabel?
        var text: LocalizedStringKey = ""
        var textClickAble: LocalizedStringKey = ""

        init(_ parent: TextLearnMoreSendTokenView) {
            self.parent = parent
        }

        @objc
        func onViewTap(recognizer: UITapGestureRecognizer) {
            guard let label = self.label,
                let text = label.attributedText?.string
            else {
                return
            }

            if let range = text.range(of: textClickAble.toString()),
                recognizer.didTapAttributedTextInLabel(label: label, inRange: NSRange(range, in: text))
            {
                UIApplication.shared.open(URL(string: "https://google.com")!, options: [:], completionHandler: nil)
            }
        }

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }

        func getAttributedText(text: LocalizedStringKey, textClickAble: LocalizedStringKey) -> NSAttributedString {
            self.text = text
            self.textClickAble = textClickAble
            let attributedString = NSMutableAttributedString()
                .then {
                    $0.append(
                        text.toString()
                            .withAttributes([
                                .font(UIFont.systemFont(ofSize: 15, weight: .regular)),
                                .textColor(UIColor.colorInteractiveTentPrimarySub),
                            ]))
                    $0.append(
                        textClickAble.toString()
                            .withAttributes([
                                .font(UIFont.systemFont(ofSize: 15, weight: .regular)),
                                .textColor(UIColor.colorInteractiveTentSecondaryDefault),
                                .underlineStyle(.single),
                                //                    .baselineOffset(0)

                            ]))
                    $0.append(NSAttributedString(string: " "))
                }

            let textAttachment = NSTextAttachment()
            textAttachment.image = UIImage(resource: .icExternalLink)
            textAttachment.bounds = CGRect(x: 0, y: -2, width: 16, height: 16)
            let imageString = NSAttributedString(attachment: textAttachment)
            attributedString.append(imageString)

            return attributedString
        }
    }
}
