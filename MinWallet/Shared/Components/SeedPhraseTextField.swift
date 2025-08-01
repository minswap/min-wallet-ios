import SwiftUI
import UIKit

struct SeedPhraseTextField: View {
    @Binding var text: String
    let typingColor: UIColor  // Color for text currently being typed
    let completedColor: UIColor  // Color for text after a space
    
    @State private var dynamicHeight: CGFloat = 50
    private var onCommit: (() -> Void)?
    
    init(
        text: Binding<String>,
        typingColor: UIColor,
        completedColor: UIColor,
        onCommit: (() -> Void)? = nil
    ) {
        self._text = text
        self.typingColor = typingColor
        self.completedColor = completedColor
        self.onCommit = onCommit
    }
    
    var body: some View {
        UITextViewWrapper(
            text: $text,
            typingColor: typingColor,
            completedColor: completedColor,
            calculatedHeight: $dynamicHeight,
            onDone: onCommit
        )
        .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
    }
    
}

private struct UITextViewWrapper: UIViewRepresentable {
    @Binding var text: String
    let typingColor: UIColor  // Color for text currently being typed
    let completedColor: UIColor  // Color for text after a space
    
    @Binding var calculatedHeight: CGFloat
    var onDone: (() -> Void)?
    
    /// Creates and configures a UITextView with a custom placeholder label for use in SwiftUI.
    /// - Parameter context: The context provided by SwiftUI for coordinating updates.
    /// - Returns: A UITextView instance set up with delegate, font, placeholder, and other properties suitable for multiline seed phrase input.
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isScrollEnabled = true
        textView.backgroundColor = .clear
        textView.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: .paragraphSmall ?? .systemFont(ofSize: 14))
        textView.adjustsFontForContentSizeCategory = true
        textView.autocorrectionType = .no
        textView.bounces = false
        // Configure the placeholder label
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Please write down your seed phrase ..."
        placeholderLabel.textColor = .colorInteractiveTentPrimarySub
        placeholderLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: .paragraphSmall ?? .systemFont(ofSize: 14))
        placeholderLabel.adjustsFontForContentSizeCategory = true
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.numberOfLines = 2
        textView.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 5),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -5),
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 8),
        ])
        
        placeholderLabel.tag = 999  // Use a tag to identify the placeholder
        placeholderLabel.isHidden = !text.isEmpty  // Show or hide based on the initial text
        
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return textView
    }
    
    /// Updates the UITextView's attributed text with color-coded segments, manages placeholder visibility, and recalculates the dynamic height based on content.
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = context.coordinator.getAttributedText(from: text, typingColor: typingColor, completedColor: completedColor)
        updatePlaceholder(uiView)
        
        UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight)
        
    }
    
    /// Calculates the required height for the given view based on its content and updates the provided binding if the height has changed.
    /// - Parameters:
    ///   - view: The UIView whose height should be measured.
    ///   - result: A binding to the height value that will be updated if a change is detected.
    fileprivate static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height
            }
        }
    }
    
    /// Creates and returns a coordinator to manage UITextView delegate methods and dynamic height updates.
    func makeCoordinator() -> Coordinator {
        Coordinator(self, height: $calculatedHeight, onDone: onDone)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: UITextViewWrapper
        var calculatedHeight: Binding<CGFloat>
        var onDone: (() -> Void)?
        
        init(_ parent: UITextViewWrapper, height: Binding<CGFloat>, onDone: (() -> Void)?) {
            self.parent = parent
            self.calculatedHeight = height
            self.onDone = onDone
        }
        
        /// Handles changes to the text view's content by sanitizing input, updating the bound text, applying color-coded formatting, managing placeholder visibility, and recalculating the dynamic height.
        func textViewDidChange(_ textView: UITextView) {
            let sanitizedText = sanitizeInput(textView.text ?? "")
            
            if sanitizedText != parent.text {
                parent.text = sanitizedText
                textView.attributedText = getAttributedText(from: sanitizedText, typingColor: parent.typingColor, completedColor: parent.completedColor)
            }
            
            parent.updatePlaceholder(textView)
            UITextViewWrapper.recalculateHeight(view: textView, result: calculatedHeight)
        }
        
        /// Handles text changes in the UITextView, triggering the onDone closure and dismissing the keyboard when the return key is pressed.
        /// - Returns: `false` to prevent insertion of a newline character when return is pressed; otherwise, `true` to allow the text change.
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                onDone?()
                textView.resignFirstResponder()
                return false
            }
            return true
        }
        
        /// Normalizes whitespace in the input text by collapsing consecutive spaces and newlines into single spaces, removing leading and trailing whitespace, and preserving a trailing space if present in the original text.
        /// - Parameter text: The input string to sanitize.
        /// - Returns: The sanitized string with normalized spacing, suitable for seed phrase entry.
        private func sanitizeInput(_ text: String) -> String {
            let components = text.components(separatedBy: .whitespacesAndNewlines)
            let filteredComponents = components.filter { !$0.isEmpty }
            return filteredComponents.joined(separator: " ") + (text.last == " " ? " " : "")
        }
        
        /// Returns an attributed string with color-coded and styled segments for a seed phrase input.
        /// - Parameters:
        ///   - text: The input seed phrase text.
        ///   - typingColor: The color applied to the word currently being typed (last word if not followed by a space).
        ///   - completedColor: The color applied to completed words (those followed by a space).
        /// - Returns: An attributed string with appropriate color and font styling applied to each word segment.
        func getAttributedText(from text: String, typingColor: UIColor, completedColor: UIColor) -> NSAttributedString {
            let attributedString = NSMutableAttributedString(string: text)
            
            let words = text.split(separator: " ", omittingEmptySubsequences: false)
            
            // Apply color to each word or segment
            var startIndex = 0
            for (index, word) in words.enumerated() {
                let wordRange = NSRange(location: startIndex, length: word.count)
                let color = (index == words.count - 1 && !text.hasSuffix(" ")) ? typingColor : completedColor
                attributedString.addAttribute(.foregroundColor, value: color, range: wordRange)
                attributedString.addAttribute(.font, value: UIFontMetrics(forTextStyle: .body).scaledFont(for: .paragraphSmall ?? .systemFont(ofSize: 14)), range: wordRange)
                // Update the start index for the next word
                startIndex += word.count + 1  // Account for the space
            }
            
            return attributedString
        }
    }
    
    /// Updates the visibility of the placeholder label in the given UITextView based on whether the text is empty.
    /// - Parameter textView: The UITextView containing the placeholder label.
    func updatePlaceholder(_ textView: UITextView) {
        if let placeholderLabel = textView.viewWithTag(999) as? UILabel {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
}


#Preview {
    ReInputSeedPhraseView(screenType: .restoreWallet)
}
