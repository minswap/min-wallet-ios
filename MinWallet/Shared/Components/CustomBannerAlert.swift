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
    
    /// Overlays a banner alert at the top of the view when `isShowing` is true.
    /// 
    /// The banner displays custom content provided by `infoContent`, appears with a top-edge transition, and automatically dismisses after 4 seconds or when tapped. The banner overlays the existing content and is sized to fit the screen width minus extra-large padding.
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            if isShowing {
                VStack(alignment: .center) {
                    infoContent()
                }
                .frame(width: UIScreen.main.bounds.width - .xl)
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .top),
                        removal: .move(edge: .top)
                    )
                )
                .onTapGesture {
                    withAnimation {
                        self.isShowing = false
                    }
                }
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        withAnimation {
                            self.isShowing = false
                        }
                    }
                })
                .zIndex(999)
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
    
    /// Returns a view that overlays a blue circular progress indicator when loading is active, hiding the underlying content.
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
    ///Using inside view
    func loading(isShowing: Binding<Bool>) -> some View {
        self.modifier(LoadingViewModifier(isShowing: isShowing))
    }
}


private struct ProgressViewModifier: ViewModifier {
    @Binding private var isShowing: Bool
    
    init(isShowing: Binding<Bool>) {
        _isShowing = isShowing
    }
    
    /// Overlays the view with a semi-transparent background and a large blue progress indicator when active.
    /// - Parameter content: The underlying view content.
    /// - Returns: The modified view with a modal-style progress overlay when `isShowing` is true.
    func body(content: Content) -> some View {
        content
            .overlay {
                if isShowing {
                    Color.black.opacity(0.2).ignoresSafeArea().transition(.fade)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(2, anchor: .center)
                        .transition(.fade)
                        .zIndex(1000)
                }
            }
    }
}


extension View {
    ///Using overlay view
    func progressView(isShowing: Binding<Bool>) -> some View {
        self.modifier(ProgressViewModifier(isShowing: isShowing))
    }
}
