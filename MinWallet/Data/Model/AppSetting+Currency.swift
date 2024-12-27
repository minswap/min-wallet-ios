import SwiftUI
import Combine
import MinWalletAPI


extension AppSetting {
    func getAdaPrice() {
        Task {
            repeat {
                do {
                    let data = try await MinWalletService.shared.fetch(query: AdaPriceQuery(currency: .case(.usd)))
                    
                    currencyInADA = data?.adaPrice.value ?? 0
                    print("WTF \(currencyInADA)")
                } catch {
                    
                }
                
                try? await Task.sleep(for: .seconds(5))
            } while (!Task.isCancelled)
        }
    }
}
