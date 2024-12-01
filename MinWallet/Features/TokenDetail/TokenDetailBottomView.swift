import SwiftUI


struct TokenDetailBottomView: View {
    var body: some View {
        ZStack {
            VStack(alignment: .leading, content: {
                HStack {
                    Spacer()
                    Color.color050B1856FFFFFF48.frame(width: 36, height: 4)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    Spacer()
                }
                .padding(.vertical, 8)
                Text("My balance")
                    .font(.paragraphSmall)
                    .foregroundStyle(.color050B1856FFFFFF48)
                    .padding(.horizontal, .xl)
                    .padding(.top, .xl)
                    .padding(.bottom, .md)
                HStack(alignment: .lastTextBaseline) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("37,016.25")
                            .font(.titleH5)
                            .foregroundStyle(.color050B18FFFFFF)
                        Text("37,016.25 ₳")
                            .font(.paragraphSmall)
                            .foregroundStyle(.color050B1856FFFFFF48)
                    }
                    Spacer()
                    CustomButton(title: "Swap") {
                        
                    }
                    .frame(width: 90, height: 44)
                }
                .padding(.horizontal, .xl)
                .padding(.bottom, .xl)
            })
        }
        .foregroundStyle(.colorBackground)
        .cornerRadius(BorderRadius._3xl)
        .overlay(
            RoundedRectangle(cornerRadius: BorderRadius._3xl).stroke(.color050B1810FFFFFF10, lineWidth: 1)
        )
    }
}

#Preview {
    VStack {
        TokenDetailBottomView().frame(height: 136)
            .padding(.xl)
        Spacer()
    }
}
