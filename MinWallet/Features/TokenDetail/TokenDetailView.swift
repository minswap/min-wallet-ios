import SwiftUI
import FlowStacks


struct TokenDetailView: View {
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    var appSetting: AppSetting
    @EnvironmentObject
    var portfolioOverviewViewModel: PortfolioOverviewViewModel
    @StateObject
    var viewModel: TokenDetailViewModel = .init()

    var body: some View {
        ZStack {
            Color.colorBaseBackground.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                smallHeader
                    .padding(.top, .md)
                    .padding(.bottom, .md)
                OffsetObservingScrollView(offset: $viewModel.scrollOffset) {
                    VStack(spacing: 0) {
                        largeHeader.background {
                            GeometryReader { proxy in
                                Color.clear
                                    .onAppear {
                                        viewModel.sizeOfLargeHeader = proxy.size
                                    }
                            }
                        }
                        tokenDetailChartView
                            .padding(.top, .xl)
                            .padding(.horizontal, .xl)
                        tokenDetailStatisticView
                            .padding(.top, .xl)
                            .padding(.horizontal, .xl)
                    }
                }
                Spacer()
                tokenDetailBottomView
                    .background(.colorBaseBackground)
                    .padding(.horizontal, .xl)
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 0)
            }
        }
    }
}

#Preview {
    TokenDetailView(viewModel: TokenDetailViewModel(token: TokenProtocolDefault()))
        .environmentObject(AppSetting.shared)
        .environmentObject(PortfolioOverviewViewModel())
}
