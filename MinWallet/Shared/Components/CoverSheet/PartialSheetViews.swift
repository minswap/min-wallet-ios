import SwiftUI


private struct ModalTypeView<Modal: View>: ViewModifier {
    @Binding var isPresented: Bool
    @State var modalHeight: CGFloat?
    @ViewBuilder var modal: () -> Modal

    func body(content: Content) -> some View {
        ZStack {
            content
            VisualEffectBlurView(blurRadius: 2)
                .ignoresSafeArea()
                .transition(.opacity)
                .opacity(isPresented ? 1 : 0)
                .onTapGesture {
                    withAnimation {
                        isPresented.toggle()
                    }
                }
        }
        .overlay(alignment: .bottom) {
            modal()
                .frame(height: modalHeight)
                .opacity(isPresented ? 1 : 0)
                .offset(y: isPresented ? 0 : 1000)
        }
        .environment(
            \.partialSheetDismiss,
            {
                withAnimation {
                    isPresented = false
                }
            })
    }
}

extension View {
    func presentSheet<Modal: View>(
        isPresented: Binding<Bool>,
        height: CGFloat? = nil,
        content: @escaping () -> Modal
    ) -> some View {
        modifier(
            ModalTypeView(
                isPresented: isPresented,
                modalHeight: height,
                modal: content)
        )
    }
}

struct PartialSheetDismissKey: EnvironmentKey {
    static let defaultValue: (() -> Void)? = nil
}

extension EnvironmentValues {
    var partialSheetDismiss: (() -> Void)? {
        get { self[PartialSheetDismissKey.self] }
        set { self[PartialSheetDismissKey.self] = newValue }
    }
}


extension Binding where Value == Bool {
    func showSheet() {
        withAnimation {
            self.wrappedValue = true
        }
    }
}
