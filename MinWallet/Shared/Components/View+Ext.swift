import SwiftUI

extension View {
    func disableBounces() -> some View {
        modifier(DisableBouncesModifier())
    }
}

struct DisableBouncesModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                UIScrollView.appearance().bounces = false
            }
            .onDisappear {
                UIScrollView.appearance().bounces = true
            }
    }
}

extension View {
    /// Overlays a placeholder view on top of the current view when a condition is met.
    /// - Parameters:
    ///   - shouldShow: A Boolean value that determines whether the placeholder is visible.
    ///   - alignment: The alignment for the placeholder within the overlay. Defaults to `.leading`.
    ///   - placeholder: A view builder that provides the placeholder content.
    /// - Returns: A view that displays the placeholder when `shouldShow` is true.
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    /// Overlays a text placeholder on the view when a condition is met.
    /// - Parameters:
    ///   - text: The placeholder text to display.
    ///   - font: The font to use for the placeholder text. Defaults to `.paragraphSmall`.
    ///   - shouldShow: A Boolean value that determines whether the placeholder is visible.
    ///   - alignment: The alignment for the placeholder within the view. Defaults to `.leading`.
    /// - Returns: A view with the placeholder text overlayed when `shouldShow` is true.
    func placeholder(
        _ text: String,
        font: Font = .paragraphSmall,
        when shouldShow: Bool,
        alignment: Alignment = .leading
    ) -> some View {
        
        placeholder(when: shouldShow, alignment: alignment) { Text(text).font(font).foregroundColor(.colorInteractiveTentPrimarySub) }
    }
}

struct DismissingKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                content.hideKeyboard()
            }
    }
}

extension View {
    
    /// Dismisses the keyboard by resigning the first responder status from the current input field.
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    func getFrame(onChange: @escaping (CGRect) -> Void) -> some View {
        background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: FramePreferenceKey.self, value: geo.frame(in: .global))
            }
        )
        .onPreferenceChange(FramePreferenceKey.self, perform: onChange)
    }
}

private struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}


extension UIApplication {
    static var safeArea: UIEdgeInsets {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene?.windows.first?.safeAreaInsets ?? .zero
    }
}

extension Binding where Value == String {
    /// Limits the length of the bound string to a specified maximum.
    /// - Parameter limit: The maximum allowed number of characters.
    /// - Returns: The binding with its value truncated to the specified length if necessary.
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            self.wrappedValue = String(self.wrappedValue.prefix(limit))
            
        }
        return self
    }
}

extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}


extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}

extension MinWalletApp {
    static func openAppSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL)
            }
        }
    }
}

extension View {
    func openAppNotificationSettings() {
        if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }
    }
}
