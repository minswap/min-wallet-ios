import SwiftUI
import FlowStacks


struct HomeView: View {
    @StateObject
    private var viewModel: HomeViewModel = .init()
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    
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
            Color.colorBackground.ignoresSafeArea()
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
                        Circle().stroke(.color050B1810FFFFFF10, lineWidth: 1)
                    )
                    .shadow(
                        color: Color(red: 0, green: 0.1, blue: 0.28).opacity(0.1),
                        radius: 3, x: 0, y: 4
                    )
                    .shadow(
                        color: Color(red: 0, green: 0.1, blue: 0.28).opacity(0.06),
                        radius: 2, x: 0, y: 2)
                    .onTapGesture {
                        withAnimation {
                            showSideMenu = true
                        }
                    }
                    
                    Text(viewModel.accountName)
                        .font(.labelMediumSecondary)
                        .foregroundColor(.color050B18FFFFFF)
                    
                    Spacer()
                    Image(.icSearch)
                        .resizable()
                        .scaledToFill()
                        .padding(8)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.color050B184FFFFFF20, lineWidth: 1)
                        )
                }
                .padding(.horizontal, .xl)
                .padding(.vertical, .xs)
                
                VStack(alignment: .leading, spacing: 4) {
                    Button(action: {
                        
                    }) {
                        HStack(spacing: 4) {
                            Text(viewModel.address.shortenAddress)
                                .font(.paragraphXSmall)
                                .foregroundStyle(.color050B1856FFFFFF48)
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
                            .foregroundStyle(.color050B18FFFFFF)
                        Text(".00 ₳")
                            .font(.titleH5)
                            .foregroundStyle(.color050B1840FFFFFF38)
                    }
                }
                .padding(.horizontal, .xl)
                .padding(.vertical, .lg)
                
                HStack(spacing: Spacing.md) {
                    CustomButton(
                        title: "Receive",
                        icon: .icReceive) {
                            
                        }
                        .frame(height: 44)
                    CustomButton(
                        title: "Send",
                        variant: .secondary,
                        icon: .icSend) {
                            
                        }
                        .frame(height: 44)
                    CustomButton(
                        title: "QR",
                        variant: .secondary,
                        icon: .icQrCode) {
                            
                        }
                        .frame(height: 44)
                }
                .padding(.vertical, Spacing.md)
                .padding(.horizontal, Spacing.xl)
                
                Carousel().frame(height: 98)
                
                    .padding(.vertical, Spacing.md)
                    .padding(.horizontal, Spacing.xl)
                
                TokenListView(label: "Crypto prices", tokens: Self.tokens, tabType: $viewModel.tabType)
                    .padding(.top, .xl)
                Spacer()
                CustomButton(title: "Swap") {
                    
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
}

extension HomeView {
    static let tokens: [TokenWithPrice] = Array(
        repeating: TokenWithPrice(
            id: UUID(),
            token: Token(
                currencySymbol: "", tokenName: "", ticker: "ADA", project: "Cardano", decimals: 6,
                isVerified: true), price: 37123.35, changePercent: 5.7), count: 20)
    
    
}

