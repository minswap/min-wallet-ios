import SwiftUI

private struct BlockingView: View {
    @Binding var isPresented: Bool
    @Binding var showingContent: Bool

    func showContent() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation {
                self.showingContent = true
            }
        }
    }

    func hideContent() {
        withAnimation {
            self.showingContent = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation {
                self.isPresented = false
            }
        }
    }

    var body: some View {
        Color.black.opacity(0.35)
            .onTapGesture {
                self.hideContent()
            }
            .onAppear {
                self.showContent()
            }
    }
}

struct PartialSheet<Content: View>: View {
    @Binding var isPresented: Bool
    @Binding var showingContent: Bool

    var content: Content
    let height: CGFloat

    init(isPresented: Binding<Bool>, showingContent: Binding<Bool>, height: CGFloat, @ViewBuilder content: () -> Content) {
        _isPresented = isPresented
        _showingContent = showingContent
        self.height = height
        self.content = content()
    }

    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .bottom) {
                BlockingView(isPresented: self.$isPresented, showingContent: self.$showingContent)
                    .zIndex(0)

                if showingContent {
                    self.content
                        .zIndex(1)
                        .frame(width: reader.size.width, height: self.height)
                        .clipped()
                        .shadow(radius: 10)
                        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}


struct PartialSheetModifier: ViewModifier {
    @Binding var isPresented: Bool
    @State private var showingContent = false

    var height: CGFloat
    let sheet: AnyView

    func hideContent() {
        withAnimation {
            self.showingContent = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation {
                self.isPresented = false
            }
        }
    }

    func body(content: Content) -> some View {
        ZStack {
            content
            VisualEffectBlurView(tintAlpha: 0, blurRadius: 2)
                .ignoresSafeArea()
                .transition(.opacity)
                .opacity(isPresented ? 1 : 0)
        }
        .overlay(
            Group {
                if isPresented {
                    PartialSheet(isPresented: self.$isPresented, showingContent: $showingContent, height: height) { sheet }
                } else {
                    EmptyView()
                }
            }
        )
        .environment(\.partialSheetDismiss, { self.hideContent() })
    }
}

#Preview {
    HomeView()
        .environmentObject(AppSetting.shared)
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
