import SwiftUI
import FlowStacks


struct ReceiveTokenView: View {
    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>

    @State
    private var address: String = "addr1g08hmca9gsnkzguqnevszcz2ea53krrx2h3gjrruap3yd2jxu2ssx0ktcajjr3x8lm5tdxxufu0qnmk68lmxlwnckj0q9qrf9o"

    private let qrImage: UIImage? = {
        "address".generateQRCode(with: "address", centerImage: UIImage(resource: .icLogoQr), size: .init(width: 200, height: 200))
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Receive")
                .font(.titleH5)
                .foregroundStyle(.colorBaseTent)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, .lg)
                .padding(.horizontal, .xl)
            Text("Share this wallet address to receive payments.")
                .font(.paragraphSmall)
                .foregroundStyle(.colorInteractiveTentPrimarySub)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
                .padding(.horizontal, .xl)
                .padding(.bottom, .lg)
            VStack(spacing: 8) {
                Image(uiImage: qrImage ?? UIImage())
                    .resizable()
                    .frame(width: 180, height: 180)
                Text(address)
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
                    .multilineTextAlignment(.center)
            }
            .padding(.xl)
            .padding(.top, 24)
            .padding(.bottom, .xl)
            .overlay(RoundedRectangle(cornerRadius: .xl).stroke(.colorBorderPrimaryDefault, lineWidth: 1))
            .padding(.xl)
            Spacer()
            HStack(spacing: .xl) {
                CustomButton(title: "Share", variant: .secondary) {

                }
                .frame(height: 44)

                CustomButton(title: "Copy", variant: .secondary) {

                }
                .frame(height: 44)
            }
            .padding(.horizontal, .xl)
        }
        .modifier(
            BaseContentView(
                screenTitle: " ",
                actionLeft: {
                    navigator.pop()
                }))
    }
}

#Preview {
    ReceiveTokenView()
}
