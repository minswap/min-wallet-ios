import SwiftUI
import FlowStacks
import ScalingHeaderScrollView


struct OrderHistoryView: View {
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    var appSetting: AppSetting

    @State var progress: CGFloat = 0
    private var minHeight: CGFloat = OrderHistoryHeaderView.smallLargeHeader
    private var maxHeight: CGFloat = OrderHistoryHeaderView.heightLargeHeader + OrderHistoryHeaderView.smallLargeHeader

    var body: some View {
        ZStack {
            ScalingHeaderScrollView {
                ZStack {
                    Color.colorBaseBackground.ignoresSafeArea()
                    OrderHistoryHeaderView(progress: $progress)
                }
            } content: {
                OrderHistoryContentView()
            }
            .height(min: minHeight + appSetting.safeArea + appSetting.extraSafeArea, max: maxHeight + appSetting.safeArea)
            .allowsHeaderCollapse()
            .collapseProgress($progress)

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
//                                .background(.colorBaseBackground)
                Spacer()
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    OrderHistoryView()
        .environmentObject(AppSetting.shared)
}
