import SwiftUI
import FlowStacks


struct TokenDetailView: View {
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    var appSetting: AppSetting
    @EnvironmentObject
    var userInfo: UserInfo
    @StateObject
    var tokenManager: TokenManager = TokenManager.shared
    @StateObject
    var viewModel: TokenDetailViewModel = .init()
    @State
    var isShowToolTip: Bool = false
    @State
    var content: LocalizedStringKey = ""
    @State
    var title: LocalizedStringKey = ""

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
            .presentSheet(isPresented: $isShowToolTip) {
                TokenDetailToolTipView(title: $title, content: $content)
                    .background(content: {
                        RoundedCorners(lineWidth: 0, tl: 24, tr: 24, bl: 0, br: 0)
                            .fill(.colorBaseBackground)
                            .ignoresSafeArea()

                    })
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
}
