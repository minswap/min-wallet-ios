import SwiftUI
import FlowStacks


struct OrderHistoryView: View {
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    var hud: HUDState
    @EnvironmentObject
    var appSetting: AppSetting
    @EnvironmentObject
    var bannerState: BannerState
    @StateObject
    var viewModel: OrderHistoryViewModel = .init()
    @FocusState
    var isFocus: Bool
    @State
    var scrollOffset: CGPoint = .zero
    @State
    private var isShowSignContract: Bool = false

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
        .presentSheet(isPresented: $isShowSignContract) {
            SignContractView(
                onSignSuccess: {
                    authenticationSuccess()
                }
            )
        }
        .presentSheet(isPresented: $viewModel.showCancelOrder) {
            OrderHistoryCancelView {
                Task {
                    do {
                        switch appSetting.authenticationType {
                        case .biometric:
                            try await appSetting.reAuthenticateUser()
                            authenticationSuccess()
                        case .password:
                            $isShowSignContract.showSheet()
                        }
                    } catch {
                        hud.showMsg(title: "Error", msg: error.localizedDescription)
                    }
                }
            }
        }
    }

    private func authenticationSuccess() {
        Task {
            do {
                hud.showLoading(true)
                let finalID = viewModel.orderToCancel?.order?.txIn.txId
                try await viewModel.cancelOrder()
                hud.showLoading(false)
                bannerState.infoContent = {
                    bannerState.infoContentDefault(onViewTransaction: {
                        finalID?.viewTransaction()
                    })
                }
                bannerState.showBanner(isShow: true)
            } catch {
                hud.showLoading(false)
                hud.showMsg(title: "Error", msg: error.localizedDescription)
            }
        }
    }
}

#Preview {
    OrderHistoryView()
}
