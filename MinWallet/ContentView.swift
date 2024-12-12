import SwiftUI
import Foundation

struct ContentView: View {
  var body: some View {
    VStack {
      HomeScreen()
      Button("Tap Me") {
          print("DEBUG: Button tapped!")
          let phrase = genPhrase(wordCount: 12)
          print(phrase)
          let wallet = createWallet(phrase: "belt change crouch decorate advice emerge tongue loop cute olympic tuna donkey", password: "123456", networkEnv: "preprod")
          print(wallet.address)
          let txRaw = "84a400d9010281825820b92cd85195fcf6bcbab09fbac22b0018a9aad5c7f75d85bcd4ed6538985f7f62020181825839006980b40d8cf53e77a718cf753ff381846570cde86d325f49193fecc5598d578c63cfe8e4a4d7653144d1559c5146210d70177ec00826d2a9821b00000001fa051528a3581cb4dac0cea6dcf6f951a07add2ef6114c41be3cb7b4cfddf06a2eb593a14c0014df104361707962617261191cbb581ce16c2dc8ae937e8d3790c7fd7168d7b994621ba14ca11415f39fed72a4434d494e1a0001c094444d494e7419c53e44744254431909134d0014df104341545448554841491b00000001ad9e7c03581ce4214b7cce62ac6fbba385d164df48e157eae5863521b4b67ca71d86a4582029acf586bf10c3b25c488705a542400178f9c9116f123a581d89fa8fb25ed3fb1a001d53d758203bb0079303c57812462dec9de8fb867cef8fd3768de7f12c77f6f0dd80381d0d1a00022098582044d75b06a5aafc296e094bf3a450734f739449c62183d4e3bbd50c28522afc971a00058bde58205efbe6716c317ee3a9333ca42993b2f9608a0e8a383e8b750312cf4d21970ab41a012318bc021a0002bda9031a04aae77ca0f5f6"
          let witness = signTx(wallet: wallet, password: "123456", accountIndex: 0, txRaw: txRaw)
          print(witness)
          
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
