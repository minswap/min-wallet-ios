import SwiftUI
import Foundation

struct ContentView: View {
  var body: some View {
    VStack {
      HomeScreen()
      Button("Tap Me") {
          let pharse = genPhrase(wordCount: 12)
          // let result = add(a: 1, b: 2)
          print(pharse)
          print("DEBUG: Button tapped!")
      }
      .padding()
      .background(Color.blue)
      .foregroundColor(.white)
      .cornerRadius(8)
    }
  }
}

#Preview {
  ContentView()
}
