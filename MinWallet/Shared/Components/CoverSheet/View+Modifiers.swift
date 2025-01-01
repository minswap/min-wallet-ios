import SwiftUI


extension View {
    func presentSheet<Content: View>(isPresented: Binding<Bool>, height: CGFloat, @ViewBuilder content: () -> Content) -> some View {
        self.modifier(PartialSheetModifier(isPresented: isPresented, height: height, sheet: AnyView(content())))
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

    func body(content: Content) -> some View {
        content.onAppear {
            if didAppearBefore == false {
                didAppearBefore = true
                action()
            }
        }
    }
}


extension Image {
    func fixSize(_ size: CGFloat) -> some View {
        self
            .resizable()
            .frame(width: size, height: size)
    }
}
