import SwiftUI
import MinWalletAPI


struct TokenLogoView: View {
    @State
    var currencySymbol: String?
    @State
    var tokenName: String?
    @State
    var isVerified: Bool?
    @State
    var size: CGSize = .init(width: 28, height: 28)

    var body: some View {
        ZStack {
            Group {
                if let image = UserInfo.TOKEN_IMAGE_DEFAULT[currencySymbol ?? ""] ?? UserInfo.TOKEN_IMAGE_DEFAULT[tokenName ?? ""] {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                } else if currencySymbol?.isEmpty == true && (tokenName?.isEmpty) == true {
                    Image(.ada)
                        .resizable()
                        .scaledToFit()
                } else {
                    CustomWebImage(url: buildImageURL(currencySymbol: currencySymbol ?? "", tokenName: tokenName ?? ""), frameSize: size)
                }
            }
            .frame(width: size.width, height: size.height)
            .clipShape(Circle())
            if isVerified == true || UserInfo.TOKEN_IMAGE_DEFAULT[currencySymbol ?? ""] != nil || UserInfo.TOKEN_IMAGE_DEFAULT[tokenName ?? ""] != nil {
                Circle()
                    .fill(.colorBaseBackground)
                    .frame(width: size.width * 16 / 28, height: size.width * 16 / 28)
                    .overlay(
                        Image(.icVerifiedBadge)
                            .resizable()
                            .frame(width: size.width * 12 / 28, height: size.width * 12 / 28)
                    )
                    .overlay(
                        Circle()
                            .stroke(.colorSurfacePrimarySub, lineWidth: 1)
                    )
                    .position(x: size.width - 2, y: size.width - 2)
            }
        }
        .frame(width: size.width, height: size.height)
    }

    private func buildImageURL(currencySymbol: String, tokenName: String) -> String {
        let baseUrl = "https://asset-logos-testnet.minswap.org"
        let path = "\(currencySymbol)\(tokenName)"
        return "\(baseUrl)/\(path)"
    }
}

#Preview {
    VStack {
        TokenLogoView(currencySymbol: "", tokenName: "", isVerified: true, size: .init(width: 24, height: 24))
        //            .frame(width: 28, height: 28)
    }
    .background(.pink)

}
