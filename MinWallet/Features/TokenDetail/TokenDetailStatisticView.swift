import SwiftUI


extension TokenDetailView {
    var tokenDetailStatisticView: some View {
        VStack(
            alignment: .leading, spacing: 0,
            content: {
                Text("Statistics")
                    .font(.titleH6)
                    .foregroundStyle(.colorBaseTent)
                    .padding(.bottom, .lg)
                HStack {
                    DashedUnderlineText(text: "Avg. price", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                    Spacer()
                    let priceValue = (viewModel.topAsset?.price ?? "").getPriceValue(appSetting: appSetting)
                    Text(priceValue.1)
                        .font(.labelMediumSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                .frame(height: 40)
                HStack(spacing: 2) {
                    let priceChange24h: Double = (Double(viewModel.topAsset?.priceChange24h ?? "") ?? 0)
                    DashedUnderlineText(text: "Avg. price change (24h)", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                    Spacer()
                    if priceChange24h != 0 {
                        Text(priceChange24h.formatSNumber(maximumFractionDigits: 2) + "%")
                            .font(.labelSmallSecondary)
                            .foregroundStyle(priceChange24h > 0 ? .colorBaseSuccess : .colorBorderDangerDefault)
                        Image(priceChange24h > 0 ? .icUp : .icDown)
                            .resizable()
                            .frame(width: 16, height: 16)
                    } else {
                        Text("--")
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorBaseTent)
                    }
                }
                .frame(height: 40)
                HStack {
                    DashedUnderlineText(text: "Volume (24h)", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                    Spacer()
                    let volume24hValue = (viewModel.topAsset?.volume24h ?? "").toExact(decimal: 6).getPriceValue(appSetting: appSetting)
                    Text(volume24hValue.value > 0 ? volume24hValue.attribute : AttributedString("--"))
                        .font(.labelMediumSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                .frame(height: 40)
                if viewModel.token.decimals > 0 {
                    HStack {
                        DashedUnderlineText(text: "Decimal", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                        Spacer()
                        Text("\(viewModel.token.decimals)")
                            .font(.labelMediumSecondary)
                            .foregroundStyle(.colorBaseTent)
                    }
                    .frame(height: 40)
                }
                HStack {
                    DashedUnderlineText(text: "Market cap", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                    Spacer()
                    let value = (viewModel.topAsset?.marketCap ?? "").toExact(decimal: 6).getPriceValue(appSetting: appSetting, isFormatK: true)
                    Text(value.value > 0 ? value.attribute : AttributedString("--"))
                        .font(.labelMediumSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                .frame(height: 40)
                HStack {
                    DashedUnderlineText(text: "Fd Market cap", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                    Spacer()
                    let value = (viewModel.topAsset?.fdMarketCap ?? "").toExact(decimal: 6).getPriceValue(appSetting: appSetting, isFormatK: true)
                    Text(value.value > 0 ? value.attribute : AttributedString("--"))
                        .font(.labelMediumSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                .frame(height: 40)
                HStack {
                    DashedUnderlineText(text: "Circulating supply", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                    Spacer()
                    let value = (viewModel.topAsset?.circulatingSupply ?? "").toExact(decimal: 6).getPriceValue(appSetting: appSetting, isFormatK: true)
                    Text(value.value > 0 ? value.attribute : AttributedString("--"))
                        .font(.labelMediumSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                .frame(height: 40)
                HStack {
                    DashedUnderlineText(text: "Total supply", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                    Spacer()
                    let value = (viewModel.topAsset?.totalSupply ?? "").toExact(decimal: 6).getPriceValue(appSetting: appSetting, isFormatK: true)
                    Text(value.value > 0 ? value.attribute : AttributedString("--"))
                        .font(.labelMediumSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                .frame(height: 40)
                .padding(.bottom, .xl)
                Text("About \(viewModel.token.adaName) (\(viewModel.token.name))")
                    .font(.titleH6)
                    .foregroundStyle(.colorBaseTent)
                    .padding(.bottom, .lg)
                if !viewModel.token.category.isEmpty {
                    FlexibleView(
                        data: viewModel.token.category,
                        spacing: .xs,
                        alignment: .leading
                    ) { item in
                        Text(verbatim: item)
                            .font(.paragraphXSmall)
                            .foregroundStyle(.colorInteractiveTentPrimarySub)
                            .padding(.horizontal, .lg)
                            .frame(height: 24)
                            .background(RoundedRectangle(cornerRadius: 12).fill(.colorSurfacePrimaryDefault))
                    }
                    .padding(.bottom, .xl)
                }
                if viewModel.isSuspiciousToken {
                    HStack(spacing: Spacing.md) {
                        Image(.icWarning)
                            .resizable()
                            .frame(width: 16, height: 16)
                        Text("Scam token")
                            .font(.paragraphXSmall)
                            .foregroundStyle(.colorInteractiveToneDanger)
                    }
                    .padding(.md)
                    .background(
                        RoundedRectangle(cornerRadius: 8).fill(.colorInteractiveToneDanger8)
                    )
                    .frame(height: 32)
                    .padding(.bottom, .xl)
                }
                if !viewModel.token.isVerified {
                    HStack(spacing: Spacing.md) {
                        Image(.icWarningYellow)
                            .resizable()
                            .frame(width: 16, height: 16)
                        Text("This token has not been verified yet. Please ensure the correct policyId")
                            .font(.paragraphXSmall)
                            .foregroundStyle(.colorInteractiveToneWarning)
                            .lineLimit(nil)
                    }
                    .padding(.md)
                    .background(
                        RoundedRectangle(cornerRadius: 8).fill(.colorSurfaceWarningDefault)
                    )
                    .frame(minHeight: 32)
                    .padding(.bottom, .xl)
                }
                if let description = viewModel.topAsset?.asset.metadata?.description, !description.isBlank {
                    Text(description)
                        .lineLimit(nil)
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorBaseTent)
                        .padding(.bottom, .xl)
                }
                HStack(spacing: 4) {
                    DashedUnderlineText(text: "Token name", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                    Spacer()
                    Text(viewModel.token.tokenName)
                        .font(.labelMediumSecondary)
                        .foregroundStyle(.colorBaseTent)
                        .lineLimit(1)
                    Image(.icCopySeedPhrase)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                        .frame(width: 16, height: 16)
                }
                .frame(height: 40)
                .containerShape(.rect)
                .onTapGesture {
                    UIPasteboard.general.string = viewModel.token.tokenName
                }
                HStack(spacing: 4) {
                    DashedUnderlineText(text: "Policy ID", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                    Spacer()
                    Text(viewModel.token.currencySymbol)
                        .font(.labelMediumSecondary)
                        .foregroundStyle(.colorBaseTent)
                        .lineLimit(1)
                    Image(.icCopySeedPhrase)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                        .frame(width: 16, height: 16)
                }
                .frame(height: 40)
                .containerShape(.rect)
                .onTapGesture {
                    UIPasteboard.general.string = viewModel.token.currencySymbol
                }
                if let riskCategory = viewModel.riskCategory {
                    HStack(spacing: 4) {
                        DashedUnderlineText(text: "Risk score", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                        Spacer()
                        Text(riskCategory.rawValue.uppercased())
                            .font(.paragraphXSemiSmall)
                            .foregroundStyle(riskCategory.textColor)
                            .padding(.horizontal, .lg)
                            .frame(height: 24)
                            .background(
                                RoundedRectangle(cornerRadius: BorderRadius.full).fill(riskCategory.backgroundColor)
                            )
                    }
                    .frame(height: 40)
                }

                let socialLinks = viewModel.token.socialLinks
                let keys = socialLinks.map { $0.key }
                if !socialLinks.isEmpty {
                    Text("External links")
                        .font(.labelSemiSecondary)
                        .foregroundStyle(.colorBaseTent)
                        .frame(height: 28)
                        .padding(.top, .xl)
                    FlexibleView(
                        data: keys,
                        spacing: 0,
                        alignment: .leading
                    ) { key in
                        Image(key.image)
                            .resizable()
                            .frame(width: 32, height: 32)
                            .onTapGesture {
                                guard let link = socialLinks[key],
                                    let url = URL(string: link)
                                else { return }
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                    }
                    .padding(.top, .md)
                    .padding(.bottom, .xl)
                }

                HStack(alignment: .center, spacing: 4) {
                    Text("For projects")
                        .font(.labelSemiSecondary)
                        .foregroundStyle(.colorBaseTent)
                        .frame(height: 28)
                    Spacer()
                    Text("Update token supply")
                        .underline()
                        .baselineOffset(4)
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorInteractiveToneHighlight)
                        .onTapGesture {
                            UIApplication.shared.open(URL(string: "https://github.com/minswap/minswap-tokens")!, options: [:], completionHandler: nil)
                        }
                        .offset(y: 2)
                    Image(.icArrowUp)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.colorInteractiveToneHighlight)
                        .frame(width: 16, height: 16)
                        .onTapGesture {
                            UIApplication.shared.open(URL(string: "https://github.com/minswap/minswap-tokens")!, options: [:], completionHandler: nil)
                        }
                        .offset(y: 1)
                }
                .padding(.bottom, .xl)
            })
    }
}

#Preview {
    ScrollView {
        TokenDetailView(viewModel: TokenDetailViewModel(token: TokenProtocolDefault()))
            .environmentObject(AppSetting.shared)
    }
}
