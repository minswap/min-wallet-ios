import SwiftUI
import Foundation

struct ContentView: View {
  var body: some View {
    VStack {
      HomeScreen()
      Button("Tap Me") {
          let phrase = genPhrase(wordCount: 12)
          // let result = add(a: 1, b: 2)
          print(phrase)
          let wallet = createWallet(phrase: phrase, password: "123456", networkEnv: "preprod")
          print(wallet.address)
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
