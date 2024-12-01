import SwiftUI
import FlowStacks


struct SplashView: View {
    @State private var scale = 0.7
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
            if !isActive {
                Color.color001947
                    .ignoresSafeArea(.all)
                VStack {
                    Image(.icSplash).resizable().frame(width: 140, height: 140)
                }
                .scaleEffect(scale)
                .onAppear {
                    withAnimation(.easeIn(duration: 0.7)) {
                        self.scale = 0.9
                    }
                }
            } else {
                HomeView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
