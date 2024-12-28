import SwiftUI
import FlowStacks


struct HomeView: View {
    @StateObject
    private var viewModel: HomeViewModel = .init()
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    var userInfo: UserInfo

    @State
    private var isShowAppearance: Bool = false
    @State
    private var isShowTimeZone: Bool = false
    @State
    private var isShowCurrency: Bool = false
    @State
    private var showSideMenu: Bool = false

    var body: some View {
        ZStack {
            Color.colorBaseBackground.ignoresSafeArea()
            VStack(alignment: .leading, spacing: .zero) {
                HStack(spacing: .md) {
                    HStack {
                        Image(.icAvatar)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 36)
                            .clipShape(Circle())
                    }
                    .padding(2)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(.colorBorderPrimarySub, lineWidth: 1)
                    )
                    .shadow(
                        color: Color(red: 0, green: 0.1, blue: 0.28).opacity(0.1),
                        radius: 3, x: 0, y: 4
                    )
                    .shadow(
                        color: Color(red: 0, green: 0.1, blue: 0.28).opacity(0.06),
                        radius: 2, x: 0, y: 2
                    )
                    .onTapGesture {
                        withAnimation {
                            showSideMenu = true
                        }
                    }
                    Text(userInfo.minWallet?.walletName)
                        .lineLimit(1)
                        .font(.labelMediumSecondary)
                        .foregroundColor(.colorBaseTent)
                        .frame(maxWidth: 200, alignment: .leading)
                    Spacer()
                    Image(.icSearch)
                        .resizable()
                        .scaledToFill()
                        .padding(8)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.colorBorderPrimaryTer, lineWidth: 1)
                        )
                        .contentShape(.rect)
                        .onTapGesture {
                            navigator.push(.searchToken)
                        }
                }
                .padding(.horizontal, .xl)
                .padding(.vertical, .xs)

                VStack(alignment: .leading, spacing: 4) {
                    Button(action: {

                    }) {
                        HStack(spacing: 4) {
                            Text(userInfo.minWallet?.address.shortenAddress)
                                .font(.paragraphXSmall)
                                .foregroundStyle(.colorInteractiveTentPrimarySub)
                            Image(.icCopy)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 16, height: 16)
                        }
                        .buttonStyle(.plain)
                    }
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        Text("0")
                            .font(.titleH3)
                            .foregroundStyle(.colorBaseTent)
                        Text(".00 ₳")
                            .font(.titleH5)
                            .foregroundStyle(.colorInteractiveTentPrimaryDisable)
                    }
                }
                .padding(.horizontal, .xl)
                .padding(.vertical, .lg)

                HStack(spacing: Spacing.md) {
                    CustomButton(
                        title: "Receive",
                        icon: .icReceive
                    ) {
                        navigator.push(.receiveToken)
                    }
                    .frame(height: 44)
                    CustomButton(
                        title: "Send",
                        variant: .secondary,
                        icon: .icSend
                    ) {
                        navigator.push(.sendToken(.sendToken))
                    }
                    .frame(height: 44)
                    CustomButton(
                        title: "QR",
                        variant: .secondary,
                        icon: .icQrCode
                    ) {

                    }
                    .frame(height: 44)
                }
                .padding(.vertical, Spacing.md)
                .padding(.horizontal, Spacing.xl)
                /*
                Carousel().frame(height: 98)

                    .padding(.vertical, Spacing.md)
                    .padding(.horizontal, Spacing.xl)
*/
                TokenListView(viewModel: viewModel)
                    .padding(.top, .xl)
                Spacer()
                CustomButton(title: "Swap") {
                    navigator.push(.swapToken(.swapToken))
                }
                .frame(height: 44)
                .padding(.horizontal, .xl)
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 0)
                }
            }
        }
        .sideMenu(isShowing: $showSideMenu) {
            SettingView(isShowAppearance: $isShowAppearance, isShowTimeZone: $isShowTimeZone, isShowCurrency: $isShowCurrency)
        }
        .presentSheet(isPresented: $isShowAppearance, height: 600) {
            AppearanceView(isShowAppearance: $isShowAppearance)
                .padding(.xl)
        }
        .presentSheet(isPresented: $isShowCurrency, height: 400) {
            CurrencyView(isShowCurrency: $isShowCurrency)
                .padding(.xl)
        }
        .presentSheet(isPresented: $isShowTimeZone, height: 400) {
            TimeZoneView(isShowTimeZone: $isShowTimeZone)
                .padding(.xl)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppSetting())
        .environmentObject(UserInfo())
}
