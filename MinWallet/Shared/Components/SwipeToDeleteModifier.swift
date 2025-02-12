import SwiftUI


struct SwipeToDeleteModifier: ViewModifier {
    @Binding var offset: CGFloat
    @Binding var isDeleted: Bool
    @GestureState private var isDragging = false

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
                        .onTapGesture {
                            onDelete()
                        }
                }
                .frame(height: geometry.size.height + 4)
                .background(Color.colorInteractiveDangerDefault)
                // Foreground (Content)
                content
                    .background(.colorBaseBackground)
                    .cornerRadius(offset < 0 ? 12 : 0, corners: [.topRight, .bottomRight])
                    .shadow(color: offset < 0 ? .colorBaseTent.opacity(0.18) : .clear, radius: 4, x: 2, y: 4)
                    .offset(x: offset)
                    .gesture(
                        DragGesture()
                            .updating($isDragging) { value, state, _ in
                                state = true
                            }
                            .onChanged { gesture in
                                offset = max(min(gesture.translation.width, 0), -68)
                            }
                            .onEnded { gesture in
                                withAnimation {
                                    offset = gesture.translation.width < -30 ? -68 : 0
                                }
                            }
                    )
            }
            .opacity(isDeleted ? 0 : 1)
            //.animation(.easeInOut(duration: 0.2), value: offset)
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
