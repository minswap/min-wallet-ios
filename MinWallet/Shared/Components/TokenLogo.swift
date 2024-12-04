import SwiftUI


struct TokenLogoView: View {
    let token: Token

    var body: some View {
        ZStack {
            Group {
                if token.currencySymbol.isEmpty && token.tokenName.isEmpty {
                    Image(.ada)
                        .resizable()
                        .scaledToFit()
                } else {
                    CustomWebImage(url: buildImageURL(currencySymbol: token.currencySymbol, tokenName: token.tokenName), frameSize: .init(width: 28, height: 28))
                }
            }
            .frame(width: 28, height: 28)
            .clipShape(Circle())

            if token.isVerified {
                Circle()
                    .fill(.colorBaseBackground)
                    .frame(width: 16, height: 16)
                    .overlay(
                        Image(.icVerifiedBadge)
                            .resizable()
                            .frame(width: 12, height: 12)
                    )
                    .overlay(
                        Circle()
                            .stroke(.colorSurfacePrimarySub, lineWidth: 1)
                    )
                    .position(x: 26, y: 26)
            }
        }
        .frame(width: 28, height: 28)
    }

    private func buildImageURL(currencySymbol: String, tokenName: String) -> URL? {
        let baseUrl = "https://asset-logos-testnet.minswap.org"
        let path = "\(currencySymbol)\(tokenName)"
        return URL(string: "\(baseUrl)/\(path)")
    }

    private func buildImageURL(currencySymbol: String, tokenName: String) -> String {
        let baseUrl = "https://asset-logos-testnet.minswap.org"
        let path = "\(currencySymbol)\(tokenName)"
        return "\(baseUrl)/\(path)"
    }
}

#Preview {
    VStack(spacing: 20) {
        TokenLogoView(
            token: Token(
                currencySymbol: "",
                tokenName: "",
                ticker: "ADA",
                project: "Cardano",
                decimals: 6,
                isVerified: true
            )
        )
        TokenLogoView(
            token: Token(
                currencySymbol: "0254a6ffa78edb03ea8933dbd4ca078758dbfc0fc6bb0d28b7a9c89f",
                tokenName: "444a4544",
                ticker: "DJED",
                project: "DJED",
                decimals: 6,
                isVerified: false
            )
        )
    }
}
