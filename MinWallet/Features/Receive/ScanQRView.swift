import SwiftUI
import CodeScanner
import FlowStacks


struct ScanQRView: View {
    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @State
    private var qrCode: String?
    @State
    private var needReset: Bool = false
    
    var body: some View {
        ZStack {
            CodeScannerView(
                codeTypes: [.qr],
                scanMode: .oncePerCode,
                showViewfinder: true,
                needsReset: $needReset
            ) { response in
                if case let .success(result) = response {
                    qrCode = result.string
                    needReset = true
                    //TODO: ScanQR
                }
            }
            .ignoresSafeArea()
            
            VStack {
                HStack(spacing: .lg) {
                    Image(.icCloseScreen)
                        .fixSize(40)
                        .onTapGesture {
                            navigator.pop()
                        }
                    Text("Scan QR code")
                        .font(.labelMediumSecondary)
                        .foregroundColor(.colorInteractiveToneTent)
                    Spacer()
                }
                .padding(.horizontal, .xl)
                .frame(height: 48)
                Spacer()
                CustomButton(title: "Show my QR") {
                    navigator.push(.receiveToken(.qrCode))
                }
                .frame(height: 56)
                .padding(.horizontal, .xl)
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 0)
                }
            }
        }
    }
}

#Preview {
    ScanQRView()
}
