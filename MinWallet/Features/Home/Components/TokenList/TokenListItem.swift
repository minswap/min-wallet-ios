//
//  TokenListItem.swift
//  MinWallet
//
//  Created by James Ng on 19/11/24.
//

import SwiftUI

struct TokenListItem: View {
    let tokenWithPrice: TokenWithPrice
    
    var body: some View {
        HStack(spacing: 15) {
            TokenLogo(token: tokenWithPrice.token)
            VStack(alignment: .leading) {
                Text(tokenWithPrice.token.ticker)
                    .font(.labelMediumSecondary)
                    .foregroundColor(.interactiveTentPrimaryDefault)
                Text(tokenWithPrice.token.project)
                    .font(.typographyParagraphSmall)
                    .foregroundColor(.interactiveTentPrimarySub)
                    .lineLimit(1)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(tokenWithPrice.token.ticker)
                    .font(.labelMediumSecondary)
                    .foregroundColor(.interactiveTentPrimaryDefault)
                HStack(spacing: 0) {
                    Text(String(tokenWithPrice.changePercent))
                        .font(.typographyParagraphSmall)
                        .foregroundColor(.interactiveTentPrimarySub)
                    Icon(name: IconName.arrowUpS, size: 16)
                }
            }
        }
        .cornerRadius(8)
        .background(.gray)
    }
}

#Preview {
    TokenListItem(tokenWithPrice: TokenWithPrice(token: Token(currencySymbol: "", tokenName: "", ticker: "ADA", project: "Cardano", decimals: 6, isVerified: true), price: 37123.35, changePercent: 5.7))
}
