import SwiftUI


struct OrderHistoryItemView: View {
    let colors: [Color] = [.red, .blue, .purple]
    var body: some View {
        VStack(spacing: .lg) {
            tokenView
            HStack {
                Text("ADA - MIN")
                    .font(.labelMediumSecondary)
                    .foregroundStyle(.colorBaseTent)
                Spacer()
                HStack(spacing: 4) {
                    Circle().frame(width: 4, height: 4)
                        .foregroundStyle(.colorBaseTent)
                    Text("Pending")
                        .font(.paragraphXMediumSmall)
                        .foregroundStyle(.colorInteractiveToneHighlight)
                }
                .padding(.horizontal, .lg)
                .padding(.vertical, .xs)
                .background(
                    RoundedRectangle(cornerRadius: BorderRadius.full).fill(.colorSurfaceHighlightDefault)
                )
                .frame(height: 20)
                .lineLimit(1)
            }
            HStack {
                Text("You paid")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
                Spacer()
                Text("20 MINv2LP")
                    .font(.labelSmallSecondary)
                    .foregroundStyle(.colorBaseTent)
            }
            HStack(alignment: .top) {
                Text("You receive")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
                Spacer()
                VStack(
                    spacing: 4,
                    content: {
                        Text("20 MINv2LP")
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorBaseTent)
                        Text("20 MINv2LP")
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorBaseTent)
                    })
            }
            HStack(spacing: Spacing.md) {
                Image(.icWarningYellow)
                    .resizable()
                    .frame(width: 16, height: 16)
                Text("Although this order has been labeled as \"Expired,\" in order to completely cancel the order, you should click on \"Cancel.\" You have the option to update the order as well by clicking “Update.”")
                    .font(.paragraphXSmall)
                    .foregroundStyle(.colorInteractiveToneWarning)
                    .lineLimit(nil)
            }
            .padding(.md)
            .background(
                RoundedRectangle(cornerRadius: .lg).fill(.colorInteractiveToneDanger8)
            )
            .frame(minHeight: 32)
            HStack(spacing: .xl) {
                CustomButton(title: "Cancel", variant: .secondary) {

                }
                .frame(height: 36)
                CustomButton(title: "Update") {

                }
                .frame(height: 36)
            }
            Color.colorBorderPrimarySub.frame(height: 1)
        }
    }

    private var tokenView: some View {
        HStack(spacing: .xs) {
            HStack(spacing: -4) {
                ForEach(0..<colors.count) { i in
                    TokenLogoView()
                        .frame(width: 24, height: 24)
                }
            }
            Image(.icBack)
                .resizable()
                .rotationEffect(.degrees(180))
                .frame(width: 16, height: 16)
                .padding(.horizontal, 2)
            HStack(spacing: -4) {
                ForEach(0..<colors.count) { i in
                    TokenLogoView()
                        .frame(width: 24, height: 24)
                }
            }
            Text("V1")
                .font(.paragraphXMediumSmall)
                .foregroundStyle(.colorInteractiveToneHighlight)
                .padding(.horizontal, .md)
                .padding(.vertical, .xs)
                .background(
                    RoundedRectangle(cornerRadius: BorderRadius.full).fill(.colorSurfaceHighlightDefault)
                )
                .frame(height: 20)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .padding(.trailing)
            Spacer()
            Text("Fill")
                .font(.labelMediumSecondary)
                .foregroundStyle(.colorBaseTent)
        }
    }
}

#Preview {
    VStack {
        OrderHistoryItemView()
            .padding(.horizontal, .xl)
        Spacer()
    }

}