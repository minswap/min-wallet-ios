import SwiftUI
import MinWalletAPI


struct TokenLogoView: View {
    @State
    var currencySymbol: String?
    @State
    var tokenName: String?
    @State
    var isVerified: Bool?

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
                    CustomWebImage(url: buildImageURL(currencySymbol: currencySymbol ?? "", tokenName: tokenName ?? ""), frameSize: .init(width: 28, height: 28))
                }
            }
            .frame(width: 28, height: 28)
            .clipShape(Circle())
            if isVerified == true || UserInfo.TOKEN_IMAGE_DEFAULT[currencySymbol ?? ""] != nil || UserInfo.TOKEN_IMAGE_DEFAULT[tokenName ?? ""] != nil {
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
    }

    private func buildImageURL(currencySymbol: String, tokenName: String) -> String {
        let baseUrl = "https://asset-logos-testnet.minswap.org"
        let path = "\(currencySymbol)\(tokenName)"
        return "\(baseUrl)/\(path)"
    }
}
