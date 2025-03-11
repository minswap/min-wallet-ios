import SwiftUI
import FlowStacks


struct ConfirmSendTokenView: View {
    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    private var appSetting: AppSetting
    @EnvironmentObject
    private var hudState: HUDState
    @EnvironmentObject
    private var bannerState: BannerState
    @State
    private var isShowSignContract: Bool = false
    @State
    private var isCopyAddress: Bool = false
    @StateObject
    private var viewModel: ConfirmSendTokenViewModel

    init(viewModel: ConfirmSendTokenViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    Text("Confirmation")
                        .font(.titleH5)
                        .foregroundStyle(.colorBaseTent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, .lg)
                        .padding(.bottom, .xl)
                        .padding(.horizontal, .xl)
                    ForEach(viewModel.tokens) { item in
                        HStack(spacing: 8) {
                            let amount = item.amount.doubleValue
                            Text(amount.formatSNumber(maximumFractionDigits: 15))
                                .font(.labelSmallSecondary)
                                .foregroundStyle(.colorBaseTent)
                            Spacer(minLength: 0)
                            TokenLogoView(currencySymbol: item.token.currencySymbol, tokenName: item.token.tokenName, isVerified: false, size: .init(width: 24, height: 24))
                            Text(item.token.adaName)
                                .font(.labelSemiSecondary)
                                .foregroundStyle(.colorBaseTent)
                        }
                        .padding(.horizontal, .xl)
                        .padding(.top, .lg)
                    }

                    Color.colorBorderPrimarySub
                        .frame(height: 1)
                        .padding(.horizontal, .xl)
                        .padding(.vertical, .xl)
                    HStack(spacing: 4) {
                        Text("To")
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorBaseTent)
                        if isCopyAddress {
                            Image(.icCheckMark)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(.colorBaseSuccess)
                                .frame(width: 16, height: 16)
                        } else {
                            Image(.icCopy)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 16, height: 16)
                                .onTapGesture {
                                    UIPasteboard.general.string = viewModel.address
                                    withAnimation {
                                        isCopyAddress = true
                                    }
                                    DispatchQueue.main.asyncAfter(
                                        deadline: .now() + .seconds(2),
                                        execute: {
                                            withAnimation {
                                                self.isCopyAddress = false
                                            }
                                        })
                                }
                        }
                        Image(.icShareAddress)
                            .resizable()
                            .frame(width: 16, height: 16)
                            .onTapGesture {
                                guard let url = URL(string: MinWalletConstant.transactionURL + "/address/\(viewModel.address)")
                                else { return }
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        Spacer()
                    }
                    .padding(.horizontal, .xl)
                    Text(viewModel.address)
                        .lineSpacing(3)
                        .font(.labelMediumSecondary)
                        .foregroundStyle(isCopyAddress ? .colorBaseSuccess : .colorInteractiveTentPrimarySub)
                        .padding(.horizontal, .xl)
                        .padding(.top, .lg)
                    /*
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Select your route")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorInteractiveTentPrimarySub)
                            Spacer()
                        }
                        .padding(.horizontal, .xl)
                        .padding(.top, .xl)
                        HStack {
                            Text("Best router")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorBaseTent)
                            Spacer()
                        }
                        .padding(.horizontal, .xl)
                        .padding(.top, .lg)
                        Color.colorBorderPrimarySub
                            .frame(height: 1)
                            .padding(.vertical, .xl)
                        HStack(spacing: 4) {
                            Text("Transaction Id")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorInteractiveTentPrimarySub)
                            Spacer()
                            Text("178b...ac17")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorBaseTent)
                            Image(.icCopy)
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                        .padding(.horizontal, .xl)
                        .padding(.bottom, .lg)
                        HStack(spacing: 4) {
                            Text("Tx Size")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorInteractiveTentPrimarySub)
                            Spacer()
                            Text("11817")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorBaseTent)
                        }
                        .padding(.horizontal, .xl)
                        .padding(.bottom, .lg)
                        HStack(spacing: 4) {
                            Text("Fee")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorInteractiveTentPrimarySub)
                            Spacer()
                            Text("0.3 \(Currency.ada.prefix)")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorBaseTent)
                        }
                        .padding(.horizontal, .xl)
                        .padding(.bottom, .xl)

                        Text("A small fee (max 0.3\(Currency.ada.prefix) may be deducted from your batcher fee for automatically cancellation.")
                            .font(.paragraphXMediumSmall)
                            .foregroundStyle(.colorInteractiveToneWarning)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.md)
                            .background(RoundedRectangle(cornerRadius: 8).fill(.colorSurfaceWarningDefault))
                            .padding(.horizontal, .xl)
                            .padding(.bottom, .xl)
                    }
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(.colorBorderPrimaryDefault, lineWidth: 1))
                    .padding(.xl)
                     */
                }
            }
            Spacer()
            CustomButton(title: "Next") {
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
            .frame(height: 56)
            .padding(.horizontal, .xl)
        }
        .modifier(
            BaseContentView(
                screenTitle: " ",
                actionLeft: {
                    navigator.pop()
                })
        )
        .presentSheet(isPresented: $isShowSignContract) {
            SignContractView(
                onSignSuccess: {
                    authenticationSuccess()
                }
            )
        }
    }

    private func authenticationSuccess() {
        Task {
            do {
                hudState.showLoading(true)
                let txRaw = try await viewModel.sendTokens()
                let finalID = try await TokenManager.finalizeAndSubmit(txRaw: txRaw)
                hudState.showLoading(false)
                bannerState.infoContent = {
                    bannerState.infoContentDefault(onViewTransaction: {
                        finalID?.viewTransaction()
                    })
                }
                bannerState.showBanner(isShow: true)
                //TokenManager.shared.reloadBalance.send(())
                if appSetting.rootScreen != .home {
                    appSetting.rootScreen = .home
                }
                navigator.popToRoot()
            } catch {
                hudState.showLoading(false)
                bannerState.showBannerError(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ConfirmSendTokenView(viewModel: ConfirmSendTokenViewModel(tokens: [.init(token: TokenManager.shared.tokenAda)], address: "addr_test1qrckpdddp4weyhv72de83y72sth4pwfu6xmy3ugcurtqe76kp8zluvc7mydvp9snyrfsnexfkw89uukajky80js83rzqufn9cj"))
        .environmentObject(AppSetting.shared)
        .environmentObject(HUDState())
}
