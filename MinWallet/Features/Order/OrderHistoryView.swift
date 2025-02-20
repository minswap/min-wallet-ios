import SwiftUI
import FlowStacks


struct OrderHistoryView: View {
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    var hud: HUDState
    @StateObject
    var viewModel: OrderHistoryViewModel = .init()
    @FocusState
    var isFocus: Bool
    @State var scrollOffset: CGPoint = .zero
    @State
    var isShowLoading: Bool = false

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
                    Task {
                        await viewModel.fetchData()
                    }
                }
                if !viewModel.showSearch && viewModel.orders.isEmpty && !viewModel.showSkeleton {
                    CustomButton(title: "Swap") {
                        navigator.push(.swapToken(.swapToken))
                    }
                    .frame(height: 56)
                    .padding(.horizontal, .xl)
                    .transition(.opacity)
                }
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 0)
            }
        }
        .presentSheet(isPresented: $viewModel.showFilterView) {
            let input = viewModel.input
            OrderHistoryFilterView(
                contractTypeSelected: input.ammType.unwrapped?.value,
                statusSelected: input.status.unwrapped?.value,
                actionSelected: input.action.unwrapped?.value,
                fromDate: input.fromDateTimeInterval,
                toDate: input.toDateTimeInterval,
                onFilterSelected: { contractType, status, action, fromDate, toDate in
                    Task {
                        viewModel.contractTypeSelected = contractType
                        viewModel.statusSelected = status
                        viewModel.actionSelected = action
                        viewModel.fromDate = fromDate
                        viewModel.toDate = toDate
                        await viewModel.fetchData()
                    }
                }
            )
        }
        .presentSheet(isPresented: $viewModel.showCancelOrder) {
            OrderHistoryCancelView {
                Task {
                    do {
                        withAnimation {
                            isShowLoading = true
                        }
                        try await viewModel.cancelOrder()
                        withAnimation {
                            isShowLoading = false
                        }
                    } catch {
                        withAnimation {
                            isShowLoading = false
                        }
                        hud.showMsg(title: "Error", msg: error.localizedDescription)
                    }
                }
            }
        }
        .progressView(isShowing: $isShowLoading)
    }
}

#Preview {
    OrderHistoryView()
}
