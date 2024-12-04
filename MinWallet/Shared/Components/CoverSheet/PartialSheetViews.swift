import SwiftUI

private struct BlockingView: View {
    @Binding var isPresented: Bool
    @Binding var showingContent: Bool

    func showContent() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation {
                self.showingContent = true
            }
        }
    }

    func hideContent() {
        withAnimation {
            self.showingContent = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
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
    var content: Content
    let height: CGFloat

    @State private var showingContent = false

    init(isPresented: Binding<Bool>, height: CGFloat, @ViewBuilder content: () -> Content) {
        _isPresented = isPresented
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
    var height: CGFloat
    let sheet: AnyView

    func body(content: Content) -> some View {
        content
            .blur(radius: isPresented ? 4.0 : 0.0)
            .overlay(
                Group {
                    if isPresented {
                        PartialSheet(isPresented: self.$isPresented, height: height) { sheet }
                    } else {
                        EmptyView()
                    }
                }
            )
    }
}
