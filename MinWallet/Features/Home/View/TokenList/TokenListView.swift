import SwiftUI
import FlowStacks
import SkeletonUI


struct TokenListView: View {
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>

    let label: LocalizedStringKey
    @Binding
    var tokens: [TokenWithPrice]
    @Binding
    var showSkeleton: Bool

    @Binding var tabType: TokenListView.TabType

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .padding(.horizontal, .xl)
                .font(.titleH6)
                .foregroundStyle(.colorBaseTent)
                .padding(.bottom, .xl)
            /*
            HStack(spacing: 0) {
                ForEach(TabType.allCases) { type in
                    Text(type.title)
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorInteractiveTentSecondaryDefault)
                        .frame(maxHeight: .infinity)
                }
                Color.colorBorderPrimarySub.frame(width: 1, height: 20)
            }
            .frame(height: 36)
            .padding(.horizontal, .xl)
            .padding(.bottom, .lg)
             */
            ScrollView {
                if showSkeleton {
                    ForEach(0..<20, id: \.self) { index in
                        TokenListItemSkeletonView()
                    }
                } else {
                    LazyVStack(
                        spacing: 0,
                        content: {
                            ForEach(0..<tokens.count, id: \.self) { index in
                                TokenListItemView(tokenWithPrice: tokens[index])
                                    .contentShape(.rect)
                                    .onTapGesture {
                                        navigator.push(.tokenDetail(token: tokens[index].token))
                                    }
                            }
                        })
                }
            }
        }
    }
}

#Preview {
    TokenListView(
        label: "Crypto prices",
        tokens: .constant(HomeView.tokens),
        showSkeleton: .constant(true),
        tabType: State(initialValue: .market).projectedValue)
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
