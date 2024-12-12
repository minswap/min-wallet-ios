import SwiftUI


struct TokenDetailStatisticView: View {
    let datas = ["DEX", "DeFi", "Smart contract", "Staking"]

    var body: some View {
        VStack(
            alignment: .leading, spacing: 0,
            content: {
                Text("Statistics")
                    .font(.titleH6)
                    .foregroundStyle(.colorBaseTent)
                    .padding(.bottom, .lg)
                HStack {
                    DashedUnderlineText(text: "Market cap", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                    Spacer()
                    Text("$223.5B")
                        .font(.labelMediumSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                .frame(height: 40)
                HStack {
                    DashedUnderlineText(text: "Circulating supply", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                    Spacer()
                    Text("5B MIN")
                        .font(.labelMediumSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                .frame(height: 40)

                HStack {
                    DashedUnderlineText(text: "Volume (24H)", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                    Spacer()
                    VStack(spacing: 4) {
                        Text("$9.5B")
                            .font(.labelMediumSecondary)
                            .foregroundStyle(.colorBaseTent)
                        HStack(spacing: 0) {
                            Text("5.7%")
                                .font(.labelSmallSecondary)
                                .foregroundStyle(.colorBaseSuccess)
                            Image(.icUp)
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                    }
                }
                .frame(height: 60)
                HStack {
                    DashedUnderlineText(text: "Volume (7D)", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                    Spacer()
                    VStack(spacing: 4) {
                        Text("$12.5B")
                            .font(.labelMediumSecondary)
                            .foregroundStyle(.colorBaseTent)
                        HStack(spacing: 0) {
                            Text("5.7%")
                                .font(.labelSmallSecondary)
                                .foregroundStyle(.colorBaseSuccess)
                            Image(.icUp)
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                    }
                }
                .frame(height: 60)
                HStack {
                    DashedUnderlineText(text: "All time high", textColor: .colorInteractiveTentPrimarySub, font: .paragraphSmall)
                    Spacer()
                    Text("$4.70")
                        .font(.labelMediumSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                .frame(height: 40)
                .padding(.bottom, .xl)
                Text("About MIN (Minswap)")
                    .font(.titleH6)
                    .foregroundStyle(.colorBaseTent)
                    .padding(.bottom, .lg)
                FlexibleView(
                    data: datas,
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
                .padding(.top, .xl)

                HStack(spacing: Spacing.md) {
                    Image(.icWarningYellow)
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text("Beware of scam tokens and always verify the policy ID. This token has not been verified yet. Please ensure the correct policyId")
                        .font(.paragraphXSmall)
                        .foregroundStyle(.colorInteractiveToneWarning)
                        .lineLimit(nil)
                }
                .padding(.md)
                .background(
                    RoundedRectangle(cornerRadius: 8).fill(.colorInteractiveToneDanger8)
                )
                .frame(minHeight: 32)
                .padding(.top, .xl)

                Text(
                    """
                    Minswap aims to bring an innovative multi-model liquidity pool decentralized exchange to the Cardano blockchain.

                    The combination of stable pools, multi-asset pools, and concentrated liquidity will benefit both traders and liquidity providers. MIN tokens are fairly distributed without any private or VC investment. This ensures the community is maximally rewarded, not speculators and insiders.
                    """
                )
                .lineLimit(nil)
                .font(.paragraphSmall)
                .foregroundStyle(.colorBaseTent)
                .padding(.vertical, .xl)
                Spacer()
            })
    }
}

#Preview {
    ScrollView {
        TokenDetailStatisticView().padding(.xl)
    }
}

struct DashedUnderlineText: UIViewRepresentable {
    let text: LocalizedStringKey
    var textColor: UIColor = .white
    var font: UIFont = .systemFont(ofSize: 14)

    func makeUIView(context: Context) -> UILabel {
        let text = text.toString()
        let label = UILabel()
        label.numberOfLines = 0

        let attributedString = NSMutableAttributedString(string: text)
        let underlineStyle = NSUnderlineStyle.patternDash.rawValue | NSUnderlineStyle.single.rawValue

        attributedString.addAttribute(
            .underlineStyle,
            value: underlineStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )

        attributedString.addAttributes(
            [
                NSAttributedString.Key.baselineOffset: 5,
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: textColor,

            ], range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {}
}

extension LocalizedStringKey {
    func toString() -> String {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if child.label == "key" {
                return child.value as? String ?? ""
            }
        }
        return ""
    }
}
