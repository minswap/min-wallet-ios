import SwiftUI


struct TokenDetailHeaderView: View {
    static let heightLargeHeader: CGFloat = 116
    static let smallLargeHeader: CGFloat = 48

    @Binding
    var progress: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
            ZStack(alignment: .leading) {
                HStack(alignment: .center, spacing: 12) {
                    TokenLogoView(token: .sampleData)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("MIN")
                            .foregroundStyle(.colorBaseTent)
                            .font(.labelMediumSecondary)
                        HStack(spacing: 4) {
                            Text("0.0422 ₳")
                                .foregroundStyle(.colorInteractiveTentPrimarySub)
                                .font(.paragraphXSmall)
                            Circle().frame(width: 2, height: 2).background(.colorInteractiveTentPrimarySub)
                            Text("5.7%")
                                .font(.paragraphXSmall)
                                .foregroundStyle(.colorBaseSuccess)
                            Image(.icUp)
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                    }
                    Spacer()
                }
                .padding(.leading, 68)
                .background(.colorBaseBackground)
                .opacity(max(0, min(1, (progress - 0.75) * 4.0)))
                .frame(height: Self.smallLargeHeader)

                VStack(alignment: .leading, spacing: 0) {
                    Color.clear.frame(height: 12)
                    HStack(
                        alignment: .center,
                        content: {
                            TokenLogoView(token: .sampleData)
                            HStack(
                                alignment: .firstTextBaseline,
                                spacing: 4,
                                content: {
                                    Text("MIN")
                                        .foregroundStyle(.colorBaseTent)
                                        .font(.labelMediumSecondary)
                                    Text("Minswap")
                                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                                        .font(.labelMediumSecondary)
                                }
                            )
                            Spacer()
                        }
                    )
                    Text("0.0422 ₳")
                        .foregroundStyle(.colorBaseTent)
                        .font(.titleH4)
                        .padding(.top, .lg)
                        .padding(.bottom, .xs)
                    HStack(spacing: 4) {
                        Text("5.7%")
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorBaseSuccess)
                        Image(.icUp)
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                }
                .padding(.horizontal, .xl)
                //                .background(.yellow)
                .frame(height: Self.heightLargeHeader)
                .opacity(1 - max(0, min(1, (progress - 0.75) * 4.0)))
            }
        }
    }
}

#Preview {
    VStack(
        alignment: .leading,
        spacing: 0,
        content: {
            TokenDetailHeaderView(progress: .constant(0))
                .background(.red)
            Spacer()
        }
    )
}
