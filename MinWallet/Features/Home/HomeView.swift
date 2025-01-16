import SwiftUI
import FlowStacks


struct HomeView: View {
    @StateObject
    private var viewModel: HomeViewModel = .init()
    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    private var userInfo: UserInfo
    @EnvironmentObject
    private var appSetting: AppSetting
    @EnvironmentObject
    private var portfolioOverviewViewModel: PortfolioOverviewViewModel
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
                    HStack(alignment: .center, spacing: 4) {
                        if !userInfo.adaHandleName.isBlank {
                            Image(.icAdahandle)
                                .resizable()
                                .frame(width: 16, height: 16)
                            Text(userInfo.adaHandleName)
                                .font(.labelMediumSecondary)
                                .foregroundStyle(.colorInteractiveToneHighlight)
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                                .padding(.trailing, 4)
                            Text(userInfo.walletName)
                                .font(.paragraphXMediumSmall)
                                .foregroundStyle(.colorInteractiveToneHighlight)
                                .padding(.horizontal, .lg)
                                .padding(.vertical, .xs)
                                .background(
                                    RoundedRectangle(cornerRadius: BorderRadius.full).fill(.colorSurfaceHighlightDefault)
                                )
                                .frame(height: 20)
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                        } else {
                            Text(userInfo.minWallet?.walletName ?? UserInfo.nickNameDefault)
                                .font(.titleH7)
                                .foregroundStyle(.colorBaseTent)
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                        }
                    }
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
                        UIPasteboard.general.string = userInfo.minWallet?.address
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
                    let prefix: String = appSetting.currency == Currency.usd.rawValue ? Currency.usd.prefix : ""
                    let suffix: String = appSetting.currency == Currency.ada.rawValue ? " \(Currency.ada.prefix)" : ""
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        let netValue: Double = appSetting.currency == Currency.ada.rawValue ? portfolioOverviewViewModel.netAdaValue : (portfolioOverviewViewModel.netAdaValue * appSetting.currencyInADA)
                        let netValueString: String = netValue.formatSNumber(maximumFractionDigits: 2)
                        let components = netValueString.split(separator: ".")
                        Text(prefix + String(components.first ?? ""))
                            .font(.titleH3)
                            .foregroundStyle(.colorBaseTent)
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                        if components.count > 1 {
                            Text(".\(components[1])" + suffix)
                                .font(.titleH5)
                                .foregroundStyle(.colorInteractiveTentPrimaryDisable)
                                .lineLimit(1)
                                .minimumScaleFactor(0.01)
                        } else {
                            Text(suffix)
                                .font(.titleH5)
                                .foregroundStyle(.colorInteractiveTentPrimaryDisable)
                                .lineLimit(1)
                                .minimumScaleFactor(0.01)
                        }
                    }
                    if !portfolioOverviewViewModel.pnl24H.isZero {
                        HStack(spacing: 4) {
                            let pnl24H: Double = appSetting.currency == Currency.ada.rawValue ? portfolioOverviewViewModel.pnl24H : (portfolioOverviewViewModel.pnl24H * appSetting.currencyInADA)
                            let foregroundStyle: Color = portfolioOverviewViewModel.pnl24H > 0 ? .colorBaseSuccess : .colorBorderDangerDefault
                            Text("\(prefix)\(pnl24H.formatSNumber(maximumFractionDigits: 2))\(suffix)")
                                .font(.paragraphSmall)
                                .foregroundStyle(foregroundStyle)
                            Circle().frame(width: 4, height: 4)
                                .foregroundStyle(.colorBaseTent)
                            Text((portfolioOverviewViewModel.pnl24H * 100 / portfolioOverviewViewModel.netAdaValue).formatSNumber(maximumFractionDigits: 2) + "%")
                                .font(.paragraphSmall)
                                .foregroundStyle(foregroundStyle)
                            if !portfolioOverviewViewModel.pnl24H.isZero {
                                Image(portfolioOverviewViewModel.pnl24H > 0 ? .icUp : .icDown)
                                    .resizable()
                                    .frame(width: 16, height: 16)
                            }
                        }
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
                        title: "Orders",
                        variant: .secondary,
                        icon: .icOrderHistory
                    ) {
                        navigator.push(.orderHistory)
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
        .presentSheet(isPresented: $isShowAppearance) {
            AppearanceView()
                .padding(.xl)
        }
        .presentSheet(isPresented: $isShowCurrency) {
            CurrencyView()
                .padding(.xl)
        }
        .presentSheet(isPresented: $isShowTimeZone) {
            TimeZoneView()
                .padding(.xl)
        }
        .task {
            portfolioOverviewViewModel.initPortfolioOverview()
        }
        .onFirstAppear {
            Task {
                userInfo.adaHandleName = await portfolioOverviewViewModel.fetchAdaHandleName()
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppSetting.shared)
        .environmentObject(UserInfo.shared)
        .environmentObject(PortfolioOverviewViewModel())
}
