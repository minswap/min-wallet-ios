import SwiftUI
import FlowStacks
import ScalingHeaderScrollView


struct OrderHistoryView: View {
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    var appSetting: AppSetting
    
    @StateObject
    var viewModel: OrderHistoryViewModel = .init()
    @FocusState
    var isFocus: Bool
    
    var body: some View {
        ZStack {
            Color.colorBaseBackground.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                headerView
                ScrollView {
                    contentView
                }
                .refreshable {
                    viewModel.fetchData()
                }
                if !viewModel.showSearch && viewModel.orders.isEmpty && !viewModel.showSkeleton {
                    CustomButton(title: "Swap") {
                        navigator.push(.swapToken(.swapToken))
                    }
                    .frame(height: 44)
                    .padding(.horizontal, .xl)
                    .transition(.opacity)
                }
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 0)
            }
        }
        .popupSheet(
            isPresented: $viewModel.showFilterView,
            content: {
                OrderHistoryFilterView(isShowFilterView: $viewModel.showFilterView).padding(.top, .xl)
            }
        )
    }
}

#Preview {
    OrderHistoryView()
        .environmentObject(AppSetting.shared)
}
