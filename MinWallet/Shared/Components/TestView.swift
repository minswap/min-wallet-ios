import SwiftUI
import UIKit


struct TestView: View {
    @State private var inputText: String = "Highlight this word!"
    
    var body: some View {
        VStack {
            TextLearnMoreSendTokenView(text: "When available, uses multiple pools for better liquidity and prices. ",
                                       textClickAble: "Learn more")
            .padding(.horizontal, .xl)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    TestView()
}
