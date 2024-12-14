import SwiftUI


struct SwipeToDeleteModifier: ViewModifier {
    @Binding var offset: CGFloat
    @Binding var isDeleted: Bool

    @State var height: CGFloat = 68

    let onDelete: () -> Void

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack {
                // Background (Delete Action)
                HStack {
                    Spacer()
                    Image(.icDelete)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, ._3xl)
                }
                .frame(height: geometry.size.height - 4)
                .background(Color.colorInteractiveDangerDefault)

                // Foreground (Content)
                content
                    .background(.colorBaseBackground)
                    .cornerRadius(offset < 0 ? 12 : 0, corners: [.topRight, .bottomRight])
                    .shadow(color: offset < 0 ? Color.black.opacity(0.1) : .clear, radius: 4, x: 0, y: 2)
                    .offset(x: offset)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                guard gesture.translation.width < 0 else { return }
                                offset = gesture.translation.width
                            }
                            .onEnded { _ in
                                if offset < -100 {
                                    withAnimation {
                                        isDeleted = true

                                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
                                            onDelete()
                                        }
                                    }
                                } else {
                                    withAnimation {
                                        offset = 0
                                    }
                                }
                            }
                    )
            }
            .opacity(isDeleted ? 0 : 1)
            //            .animation(.easeInOut(duration: 0.2), value: offset)
        }
        .frame(height: height)
    }
}

extension View {
    func swipeToDelete(offset: Binding<CGFloat>, isDeleted: Binding<Bool>, height: CGFloat, onDelete: @escaping () -> Void) -> some View {
        modifier(SwipeToDeleteModifier(offset: offset, isDeleted: isDeleted, height: height, onDelete: onDelete))
    }
}

#Preview(body: {
    SearchTokenView()
})
