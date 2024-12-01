import SwiftUI
import FlowStacks


struct TokenListView: View {
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    
    let label: LocalizedStringKey
    @State
    var tokens: [TokenWithPrice] = []
    
    @Binding var tabType: TokenListView.TabType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .padding(.horizontal, .xl)
                .font(.titleH6)
                .foregroundStyle(.color050B18FFFFFF)
                .padding(.bottom, .xl)
            /*
            HStack(spacing: 0) {
                ForEach(TabType.allCases) { type in
                    Text(type.title)
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.color001947FFFFFF78)
                        .frame(maxHeight: .infinity)
                }
                Color.color050B1810FFFFFF10.frame(width: 1, height: 20)
            }
            .frame(height: 36)
            .padding(.horizontal, .xl)
            .padding(.bottom, .lg)
             */
            ScrollView {
                VStack(spacing: 0, content: {
                    ForEach(tokens, id: \.self) { token in
                        TokenListItemView(tokenWithPrice: token)
                            .contentShape(.rect)
                            .onTapGesture {
                                navigator.push(.tokenDetail(token: token.token))
                            }
                    }
                })
            }
//            .hidden()
        }
    }
}

#Preview {
    TokenListView(label: "Crypto prices", tokens: HomeView.tokens, tabType: State(initialValue: .market).projectedValue)
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
