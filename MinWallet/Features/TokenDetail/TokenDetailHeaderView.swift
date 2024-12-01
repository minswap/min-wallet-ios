import SwiftUI


struct TokenDetailHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, content: {
                TokenLogoView(token: .sampleData)
                HStack(alignment: .firstTextBaseline, spacing: 4, content: {
                    Text("MIN")
                        .foregroundStyle(.color050B18FFFFFF78)
                        .font(.labelMediumSecondary)
                    Text("Minswap")
                        .foregroundStyle(.color050B1856FFFFFF48)
                        .font(.labelMediumSecondary)
                })
                Spacer()
            })
            Text("0.0422 ₳")
                .foregroundStyle(.color050B18FFFFFF78)
                .font(.titleH4)
                .padding(.top, .lg)
                .padding(.bottom, .xs)
            HStack(spacing: 4) {
                Text("5.7%")
                    .font(.labelSmallSecondary)
                    .foregroundStyle(.color0087661ABB93)
                Image(.icUp)
                    .resizable()
                    .frame(width: 16, height: 16)
            }            
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 0, content: {
        TokenDetailHeaderView()
            .padding(.xl)
        Spacer()
    })
}
