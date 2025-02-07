import SwiftUI
import MinWalletAPI
import FlowStacks


struct SelectTokenView: View {
    enum ScreenType {
        case initSelectedToken
        case sendToken
        case swapToken
    }

    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @FocusState
    private var isFocus: Bool
    @Environment(\.partialSheetDismiss)
    var onDismiss

    init(
        viewModel: SelectTokenViewModel,
        onSelectToken: (([TokenProtocol]) -> Void)?
    ) {
        self._viewModel = .init(wrappedValue: viewModel)
        self.onSelectToken = onSelectToken
    }

    @ObservedObject
    private var viewModel: SelectTokenViewModel

    var onSelectToken: (([TokenProtocol]) -> Void)?

    var body: some View {
        ZStack {
            Color.colorBaseBackground.ignoresSafeArea()
            VStack(
                spacing: 0,
                content: {
                    if viewModel.screenType == .initSelectedToken {
                        headerView
                    }
                    contentView
                    if viewModel.screenType == .initSelectedToken || viewModel.screenType == .sendToken {
                        CustomButton(title: viewModel.screenType == .initSelectedToken ? "Next" : "Confirm") {
                            let tokenSelected = viewModel.tokenCallBack
                            switch viewModel.screenType {
                            case .initSelectedToken:
                                guard !tokenSelected.isEmpty else { return }
                                onSelectToken?(tokenSelected)
                                navigator.push(.sendToken(.sendToken(tokensSelected: tokenSelected, screenType: viewModel.sourceScreenType)))
                            case .sendToken:
                                onSelectToken?(tokenSelected)
                                onDismiss?()
                            case .swapToken:
                                break
                            }
                        }
                        .frame(height: 56)
                        .padding(.horizontal, .xl)
                        .safeAreaInset(edge: .bottom) {
                            Color.clear.frame(height: 0)
                        }
                    }
                })
        }
        .background(.colorBaseBackground)
    }

    @ViewBuilder
    private var headerView: some View {
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
        Text("You want to send")
            .font(.titleH5)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 60)
            .padding(.horizontal, .xl)
    }

    private var contentView: some View {
        VStack(spacing: .md) {
            HStack(spacing: .md) {
                Image(.icSearch)
                    .resizable()
                    .frame(width: 20, height: 20)
                TextField("", text: $viewModel.keyword)
                    .placeholder("Search", when: viewModel.keyword.isEmpty)
                    .focused($isFocus)
                    .lineLimit(1)
            }
            .padding(.md)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(.colorBorderPrimaryDefault, lineWidth: 1))
            .padding(.horizontal, .xl)
            .padding(.top, .lg)
            ScrollView {
                if viewModel.showSkeleton {
                    ForEach(0..<20, id: \.self) { index in
                        TokenListItemSkeletonView()
                    }
                    .padding(.top, .xl)
                } else if viewModel.tokens.isEmpty {
                    VStack(alignment: .center, spacing: 16) {
                        Image(.icEmptyResult)
                            .fixSize(120)
                        Text("No results")
                            .font(.labelMediumSecondary)
                            .foregroundStyle(.colorBaseTent)
                    }
                    .padding(.top, 50)
                } else {
                    LazyVStack(
                        spacing: 0,
                        content: {
                            ForEach($viewModel.tokens) { $item in
                                let item = $item.wrappedValue.token
                                if viewModel.screenType == .initSelectedToken || viewModel.screenType == .sendToken {
                                    let combinedBinding = Binding<Bool>(
                                        get: { viewModel.tokensSelected[item.uniqueID] != nil || item.uniqueID == MinWalletConstant.adaToken },
                                        set: { _ in }
                                    )
                                    SelectTokenListItemView(token: item, isSelected: combinedBinding, isShowSelected: true)
                                        .contentShape(.rect)
                                        .onTapGesture {
                                            viewModel.toggleSelected(token: item)
                                        }
                                } else {
                                    let combinedBinding = Binding<Bool>(
                                        get: { viewModel.tokensSelected[item.uniqueID] != nil },
                                        set: { _ in }
                                    )
                                    SelectTokenListItemView(token: item, isSelected: combinedBinding, isShowSelected: false)
                                        .contentShape(.rect)
                                        .onTapGesture {
                                            viewModel.toggleSelected(token: item)
                                            onDismiss?()
                                            let tokenSelected = viewModel.tokenCallBack
                                            onSelectToken?(tokenSelected)
                                        }
                                }
                            }
                        })
                }
            }
            .refreshable {
                viewModel.getTokens()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SelectTokenView(viewModel: SelectTokenViewModel(tokensSelected: [TokenProtocolDefault()], screenType: .swapToken, sourceScreenType: .normal), onSelectToken: { _ in })
        .environmentObject(AppSetting.shared)
}
