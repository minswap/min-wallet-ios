import SwiftUI


public struct SideMenu<MenuContent: View>: ViewModifier {
    @Binding var isShowing: Bool
    private let menuContent: () -> MenuContent

    public init(
        isShowing: Binding<Bool>,
        @ViewBuilder menuContent: @escaping () -> MenuContent
    ) {
        _isShowing = isShowing
        self.menuContent = menuContent
    }

    public func body(content: Content) -> some View {
        let drag = DragGesture()
            .onEnded { event in
                if event.location.x < 200 && abs(event.translation.height) < 50 && abs(event.translation.width) > 50 {
                    withAnimation {
                        self.isShowing = event.translation.width > 0
                    }
                }
            }
        return GeometryReader { geometry in
            ZStack(alignment: .leading) {
                ZStack {
                    content
                        .disabled(isShowing)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(x: self.isShowing ? geometry.size.width * 0.8 : 0)

                    VisualEffectBlurView()  // Replace .light with .dark or .systemMaterial
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)
                        .opacity(isShowing ? 1 : 0)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .onTapGesture {
                    withAnimation {
                        isShowing = false
                    }
                }

                menuContent()
                    .frame(width: geometry.size.width * 0.8)
                    .transition(.move(edge: .leading))
                    .offset(x: self.isShowing ? 0 : -geometry.size.width * 0.8)
                    .shadow(color: isShowing ? .black.opacity(0.1) : .clear, radius: 2, x: 2, y: 0)
                    .zIndex(999)
            }
            .gesture(drag)
        }
    }
}

public extension View {
    func sideMenu<MenuContent: View>(
        isShowing: Binding<Bool>,
        @ViewBuilder menuContent: @escaping () -> MenuContent
    ) -> some View {
        self.modifier(SideMenu(isShowing: isShowing, menuContent: menuContent))
    }
}

private struct SideMenuTest: View {
    @State private var showSideMenu = false

    var body: some View {
        NavigationView {
            List(1..<6) { index in
                Text("Item \(index)")
            }
            .navigationBarTitle("Dashboard", displayMode: .inline)
            .navigationBarItems(
                leading: (Button(action: {
                    withAnimation {
                        self.showSideMenu.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .imageScale(.large)
                }))
        }
        .sideMenu(isShowing: $showSideMenu) {
            VStack(alignment: .leading) {
                Button(action: {
                    withAnimation {
                        self.showSideMenu = false
                    }
                }) {
                    HStack {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                        Text("close menu")
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .padding(.leading, 15.0)
                    }
                }
                .padding(.top, 20)
                Divider()
                    .frame(height: 20)
                Text("Sample item 1")
                    .foregroundColor(.white)
                Text("Sample item 2")
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct SideMenu_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AppSetting.shared)
            .environmentObject(UserInfo.shared)
    }
}
