import SwiftUI


private struct CustomBannerAlertModifier<InfoContent: View>: ViewModifier {
    @Binding var isShowing: Bool

    private let infoContent: () -> InfoContent

    init(
        isShowing: Binding<Bool>,
        @ViewBuilder infoContent: @escaping () -> InfoContent
    ) {
        _isShowing = isShowing
        self.infoContent = infoContent
    }

    func body(content: Content) -> some View {
        ZStack {
            content
            if isShowing {
                VStack {
                    infoContent()
                    Spacer()
                }
                .padding()
                .animation(.easeInOut)
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                .onTapGesture {
                    withAnimation {
                        self.isShowing = false
                    }
                }
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            self.isShowing = false
                        }
                    }
                })
            }
        }
    }
}

extension View {
    func banner<InfoContent: View>(
        isShowing: Binding<Bool>,
        @ViewBuilder infoContent: @escaping () -> InfoContent
    ) -> some View {
        self.modifier(CustomBannerAlertModifier(isShowing: isShowing, infoContent: infoContent))
    }
}



private struct LoadingViewModifier: ViewModifier {
    @Binding var isShowing: Bool
    
    init(isShowing: Binding<Bool>) {
        _isShowing = isShowing
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content.opacity(isShowing ? 0 : 1)
            if isShowing {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(1.0, anchor: .center)
            }
        }
    }
}

extension View {
    func loading(isShowing: Binding<Bool>) -> some View {
        self.modifier(LoadingViewModifier(isShowing: isShowing))
    }
}
