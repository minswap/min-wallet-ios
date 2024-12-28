import SwiftUI
import FlowStacks
import SkeletonUI
import MinWalletAPI


struct TokenListView: View {
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    
    @ObservedObject
    var viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            /*
            Text(label)
                .padding(.horizontal, .xl)
                .font(.titleH6)
                .foregroundStyle(.colorBaseTent)
                .padding(.bottom, .xl)
            */
            HStack(spacing: 0) {
                ForEach(TabType.allCases) { type in
                    Text(type.title)
                        .font(.labelSmallSecondary)
                        .foregroundStyle(viewModel.tabType == type ? .colorInteractiveTentSecondaryDefault : .colorInteractiveTentPrimarySub)
                        .frame(height: 28)
                        .padding(.horizontal, .lg)
                        .background(viewModel.tabType == type ? .colorSurfacePrimaryDefault : .clear)
                        .cornerRadius(BorderRadius.full)
                        .padding(.trailing, .lg)
                        .onTapGesture {
                            viewModel.tabType = type
                        }
                }
                if viewModel.tabType == .yourToken, !viewModel.tokens.isEmpty {
                    Spacer()
                    Color.colorBorderPrimarySub.frame(width: 1, height: 20)
                    Text("\(viewModel.tokens) tokens")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                        .padding(.leading, .md)
                }
            }
            .frame(height: 36)
            .padding(.horizontal, .xl)
            .padding(.bottom, .lg)
            
            ScrollView {
                if viewModel.showSkeleton {
                    ForEach(0..<20, id: \.self) { index in
                        TokenListItemSkeletonView()
                    }
                } else if viewModel.tokens.isEmpty {
                    Text("No data")
                        .padding(.horizontal, .xl)
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                } else {
                    LazyVStack(
                        spacing: 0,
                        content: {
                            ForEach(0..<viewModel.tokens.count, id: \.self) { index in
                                let item = viewModel.tokens[index]
                                TokenListItemView(token: item)
                                    .contentShape(.rect)
                                    .onAppear() {
                                        viewModel.loadMoreData(item: item)
                                    }
                                    .onTapGesture {
                                        //TODO: Cuongnv
                                        //navigator.push(.tokenDetail(token: tokens[index].token))
                                    }
                            }
                        })
                }
            }
            .refreshable {
                viewModel.getTokens()
            }
        }
    }
}

#Preview {
    TokenListView(viewModel: HomeViewModel())
}


extension TokenListView {
    static let marketUUID = UUID()
    static let yourTokenUUID = UUID()
    static let nftUUID = UUID()

    enum TabType: CaseIterable, Identifiable {
        var id: UUID {
            switch self {
            case .market:
                return marketUUID
            case .yourToken:
                return yourTokenUUID
            case .nft:
                return nftUUID
            }
        }

        case market
        case yourToken
        case nft

        var title: LocalizedStringKey {
            switch self {
            case .market:
                "Market"
            case .yourToken:
                "Your tokens"
            case .nft:
                "Your NFTs"
            }
        }
    }
}
