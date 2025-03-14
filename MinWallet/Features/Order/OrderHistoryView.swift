import SwiftUI
import FlowStacks
import MinWalletAPI


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
    @StateObject
    var filterViewModel: OrderHistoryFilterViewModel = .init()

    var body: some View {
        ZStack {
            Color.colorBaseBackground.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                headerView
                    .padding(.top, .md)
                OffsetObservingScrollView(
                    offset: $scrollOffset,
                    onRefreshable: {
                        await viewModel.fetchData(fromPullToRefresh: true)
                    },
                    content: {
                        contentView
                    })
                if !viewModel.showSearch && viewModel.orders.isEmpty && !viewModel.showSkeleton {
                    CustomButton(title: "Swap") {
                        navigator.push(.swapToken(.swapToken(token: nil)))
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
            OrderHistoryFilterView(
                viewModel: filterViewModel,
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
                        bannerState.showBannerError(error.localizedDescription)
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
                bannerState.showBannerError(error.localizedDescription)
            }
        }
    }
}

#Preview {
    OrderHistoryView()
}
