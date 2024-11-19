import SwiftUI

struct HomeScreen: View {
    var body: some View {
        NavigationView {
            VStack {
                AppBar()
                Spacer()
            }
        }.toolbar(.hidden)
    }
}

struct HomeScreen_Preview: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
