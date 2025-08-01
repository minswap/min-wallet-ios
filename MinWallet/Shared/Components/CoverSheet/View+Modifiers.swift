import SwiftUI

extension Image {
    func fixSize(_ size: CGFloat) -> some View {
        self
            .resizable()
            .frame(width: size, height: size)
    }
}

extension View {
    func onFirstAppear(perform action: @escaping () -> Void) -> some View {
        modifier(ViewFirstAppearModifier(perform: action))
    }
}

struct ViewFirstAppearModifier: ViewModifier {
    @State private var didAppearBefore = false
    private let action: () -> Void
    
    init(perform action: @escaping () -> Void) {
        self.action = action
    }
    
    /// Modifies the view to execute the stored action only the first time the view appears.
    /// - Parameter content: The original view content.
    /// - Returns: The modified view that triggers the action on its first appearance.
    func body(content: Content) -> some View {
        content.onAppear {
            if didAppearBefore == false {
                didAppearBefore = true
                action()
            }
        }
    }
}
