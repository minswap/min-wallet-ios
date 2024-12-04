import SwiftUI
import UIKit


struct SeedPhraseTextField: UIViewRepresentable {
    @Binding var text: String
    let typingColor: UIColor  // Color for text currently being typed
    let completedColor: UIColor  // Color for text after a space

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()

        textView.delegate = context.coordinator
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 14)

        // Configure the placeholder label
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Please write down your seed phrase ..."
        placeholderLabel.textColor = .colorInteractiveTentPrimarySub
        placeholderLabel.font = textView.font
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        textView.addSubview(placeholderLabel)

        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 5),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -5),
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 8),
        ])

        placeholderLabel.tag = 999  // Use a tag to identify the placeholder
        placeholderLabel.isHidden = !text.isEmpty  // Show or hide based on the initial text

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = context.coordinator.getAttributedText(from: text, typingColor: typingColor, completedColor: completedColor)
        updatePlaceholder(uiView)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: SeedPhraseTextField

        init(_ parent: SeedPhraseTextField) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            let sanitizedText = sanitizeInput(textView.text ?? "")

            if sanitizedText != parent.text {
                parent.text = sanitizedText
                textView.attributedText = getAttributedText(from: sanitizedText, typingColor: parent.typingColor, completedColor: parent.completedColor)
            }

            parent.updatePlaceholder(textView)
        }

        // Sanitize input to remove extra spaces
        private func sanitizeInput(_ text: String) -> String {
            let components = text.components(separatedBy: .whitespacesAndNewlines)
            let filteredComponents = components.filter { !$0.isEmpty }
            return filteredComponents.joined(separator: " ") + (text.last == " " ? " " : "")
        }

        // Generate attributed text with the desired coloring
        func getAttributedText(from text: String, typingColor: UIColor, completedColor: UIColor) -> NSAttributedString {
            let attributedString = NSMutableAttributedString(string: text)

            let words = text.split(separator: " ", omittingEmptySubsequences: false)

            // Apply color to each word or segment
            var startIndex = 0
            for (index, word) in words.enumerated() {
                let wordRange = NSRange(location: startIndex, length: word.count)
                let color = (index == words.count - 1 && !text.hasSuffix(" ")) ? typingColor : completedColor
                attributedString.addAttribute(.foregroundColor, value: color, range: wordRange)

                // Update the start index for the next word
                startIndex += word.count + 1  // Account for the space
            }

            return attributedString
        }
    }

    func updatePlaceholder(_ textView: UITextView) {
        if let placeholderLabel = textView.viewWithTag(999) as? UILabel {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
}
