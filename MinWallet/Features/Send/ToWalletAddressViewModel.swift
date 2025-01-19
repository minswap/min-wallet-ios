import SwiftUI


@MainActor
class ToWalletAddressViewModel: ObservableObject {

    @Published
    var adaAddress: AdaAddress?
    @Published
    var isChecking: Bool?

    @Published
    var address: String = ""

    init() {}

    func checkAddress() {
        guard !address.isBlank else { return }
        Task {
            isChecking = true
            try? await Task.sleep(for: .seconds(3))

            adaAddress = .init()
            isChecking = false
        }
    }
}

struct AdaAddress {
    var name: String = "hieunguyen"
    var address: String = "addr1qxjd7yhl8d8aezz0spg4zghgtn7rx7zun7fkekrtk2zvw9vsxg93khf9crelj4wp6kkmyvarlrdvtq49akzc8g58w9cq5svq4r"

    init() {}
}
