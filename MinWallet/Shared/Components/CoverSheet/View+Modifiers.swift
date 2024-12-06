import SwiftUI


extension View {
    func presentSheet<Content: View>(isPresented: Binding<Bool>, height: CGFloat, @ViewBuilder content: () -> Content) -> some View {
        self.modifier(PartialSheetModifier(isPresented: isPresented, height: height, sheet: AnyView(content())))
    }
}
