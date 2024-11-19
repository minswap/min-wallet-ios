//
//  TokenLogo.swift
//  MinWallet
//
//  Created by James Ng on 19/11/24.
//

import SwiftUI

struct TokenLogo: View {
    let token: Token
    
    var body: some View {
        ZStack {
            Group {
                if token.currencySymbol.isEmpty && token.tokenName.isEmpty {
                    Image("ada")
                        .resizable()
                        .scaledToFit()
                } else {
                    AsyncImage(url: buildImageURL(currencySymbol: token.currencySymbol, tokenName: token.tokenName)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Circle()
                            .fill(Color.surfacePrimarySub)
                            .overlay(
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            )
                    }
                }
            }
            .frame(width: 28, height: 28)
            .clipShape(Circle())
            
            if token.isVerified {
                Circle()
                    .fill(Color.baseBackground)
                    .frame(width: 16, height: 16)
                    .overlay(
                        Icon(name: IconName.verifiedBadge, size: 12)
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.surfacePrimarySub, lineWidth: 1)
                    )
                    .position(x: 26, y: 26)
            }
        }.frame(width: 28, height: 28)
    }
    
    private func buildImageURL(currencySymbol: String, tokenName: String) -> URL? {
        let baseUrl = "https://asset-logos-testnet.minswap.org"
        let path = "\(currencySymbol)\(tokenName)"
        return URL(string: "\(baseUrl)/\(path)")
    }
}

#Preview {
    VStack(spacing: 20) {
        TokenLogo(token: Token(currencySymbol: "", tokenName: "", ticker: "ADA", project: "Cardano", decimals: 6, isVerified: true))
        TokenLogo(token: Token(currencySymbol: "0254a6ffa78edb03ea8933dbd4ca078758dbfc0fc6bb0d28b7a9c89f", tokenName: "444a4544", ticker: "DJED", project: "DJED", decimals: 6, isVerified: false))
    }
}
