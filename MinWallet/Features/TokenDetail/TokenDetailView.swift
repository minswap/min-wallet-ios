import SwiftUI
import FlowStacks
import ScalingHeaderScrollView


struct TokenDetailView: View {
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    var appSetting: AppSetting
    @State
    var progress: CGFloat = 0
   
    @StateObject
    var viewModel: TokenDetailViewModel = .init()
    
    private let minHeight: CGFloat = Self.smallLargeHeader
    private let maxHeight: CGFloat = Self.heightLargeHeader + Self.smallLargeHeader
    var datas = ["DEX", "DeFi", "Smart contract", "Staking"]
    
    var body: some View {
        ZStack {
            ScalingHeaderScrollView {
                ZStack {
                    Color.colorBaseBackground.ignoresSafeArea()
                    tokenDetailHeaderView
                }
            } content: {
                VStack(spacing: 0) {
                    tokenDetailChartView
                        .padding(.top, .xl)
                        .padding(.horizontal, .xl)
                    tokenDetailStatisticView
                        .padding(.top, .xl)
                        .padding(.horizontal, .xl)
                }
            }
            .height(min: minHeight + appSetting.safeArea + appSetting.extraSafeArea, max: maxHeight + appSetting.safeArea)
            .allowsHeaderCollapse()
            .collapseProgress($progress)
            .disableBounces()

            VStack(spacing: 0) {
                HStack(spacing: .lg) {
                    Button(
                        action: {
                            navigator.pop()
                        },
                        label: {
                            Image(.icBack)
                                .resizable()
                                .frame(width: ._3xl, height: ._3xl)
                                .padding(.md)
                                .background(RoundedRectangle(cornerRadius: BorderRadius.full).stroke(.colorBorderPrimaryTer, lineWidth: 1))
                        }
                    )
                    .buttonStyle(.plain)
                    Spacer()
                }
                .frame(height: 48)
                .padding(.horizontal, .xl)
                .padding(.top, appSetting.safeArea)
                //                .background(.colorBaseBackground)
                Spacer()
            }
            VStack {
                Spacer()
                tokenDetailBottomView
                    .background(.colorBaseBackground)
                    .padding(.horizontal, .xl)
            }

        }
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    TokenDetailView(viewModel: TokenDetailViewModel(token: TokenProtocolDefault()))
        .environmentObject(AppSetting.shared)
}
