import SwiftUI
import FlowStacks
import ScalingHeaderScrollView


struct OrderHistoryView: View {
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>

    @StateObject
    var viewModel: OrderHistoryViewModel = .init()
    @FocusState
    var isFocus: Bool
    @State var scrollOffset: CGPoint = .zero

    var body: some View {
        ZStack {
            Color.colorBaseBackground.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                headerView
                    .padding(.top, .md)
                OffsetObservingScrollView(offset: $scrollOffset) {
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
                let input = viewModel.input
                OrderHistoryFilterView(
                    isShowFilterView: $viewModel.showFilterView,
                    contractTypeSelected: input.ammType.unwrapped?.value,
                    statusSelected: input.status.unwrapped?.value,
                    actionSelected: input.action.unwrapped?.value,
                    fromDate: input.fromDateTimeInterval,
                    toDate: input.toDateTimeInterval,
                    onFilterSelected: { contractType, status, action, fromDate, toDate in
                        viewModel.contractTypeSelected = contractType
                        viewModel.statusSelected = status
                        viewModel.actionSelected = action
                        viewModel.fromDate = fromDate
                        viewModel.toDate = toDate
                        viewModel.fetchData()
                    }
                ).padding(.top, .xl)
            }
        )
    }
}

#Preview {
    OrderHistoryView()
}
