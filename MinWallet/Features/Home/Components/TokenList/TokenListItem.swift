//
//  TokenListItem.swift
//  MinWallet
//
//  Created by James Ng on 19/11/24.
//

import SwiftUI

struct TokenListItem: View {
  let tokenWithPrice: TokenWithPrice
  let isPositive: Bool

  init(tokenWithPrice: TokenWithPrice) {
    self.tokenWithPrice = tokenWithPrice
    self.isPositive = tokenWithPrice.changePercent >= 0
  }

  var body: some View {
    HStack(spacing: 15) {
      TokenLogo(token: tokenWithPrice.token)
      HStack(spacing: 0) {
        VStack(alignment: .leading) {
          Text(tokenWithPrice.token.ticker)
            .font(.labelMediumSecondary)
            .foregroundColor(.appTentPrimary)
          Text(tokenWithPrice.token.project)
            .font(.paragraphSmall)
            .foregroundColor(.appTentPrimarySub)
            .lineLimit(1)
        }
        Spacer()
        VStack(alignment: .trailing, spacing: 0) {
          Text("\(String(tokenWithPrice.price)) ₳")
            .lineSpacing(24)
            .font(.labelMediumSecondary)
            .foregroundColor(.appTentPrimary)
          HStack(spacing: 0) {
            Text("\(String(abs(tokenWithPrice.changePercent)))%")
              .font(.labelSmallSecondary)
              .foregroundColor(isPositive ? .appSuccess : .appDanger)
            AppIcon(name: IconName.arrowUpS, size: 16, color: isPositive ? .appSuccess : .appDanger)
              .rotationEffect(.degrees(isPositive ? 0 : 180))
          }
        }
      }.padding(.vertical, 12)
        .overlay(
          Rectangle().frame(height: 1).foregroundColor(.appBorderPrimaryTer), alignment: .bottom
        )
    }
    .padding(.horizontal, 16)
  }
}

#Preview {
  VStack(spacing: 0) {
    TokenListItem(
      tokenWithPrice: TokenWithPrice(
        id: UUID(),
        token: Token(
          currencySymbol: "", tokenName: "", ticker: "ADA", project: "Cardano", decimals: 6,
          isVerified: true), price: 37123.35, changePercent: 5.7))
    TokenListItem(
      tokenWithPrice: TokenWithPrice(
        id: UUID(),
        token: Token(
          currencySymbol: "", tokenName: "", ticker: "ADA", project: "Cardano", decimals: 6,
          isVerified: true), price: 37123.35, changePercent: -5.7))
  }
}
