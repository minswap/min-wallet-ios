import SwiftUI
import FlowStacks


struct TokenDetailView: View {
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    
    var body: some View {
        VStack {
            ScrollView(.vertical, content: {
                VStack(spacing: 0, content: {
                    TokenDetailHeaderView()
                        .padding(.top, .lg)
                        .padding(.horizontal, .xl)
                    TokenDetailChartView(data: chartData)
                        .padding(.top, .xl)
                        .padding(.horizontal, .xl)
                    TokenDetailStatisticView()
                        .padding(.top, .xl)
                        .padding(.horizontal, .xl)
                    
                })
            })
            TokenDetailBottomView()
                .padding(.horizontal, .xl)
        }
        .modifier(BaseContentView(
            screenTitle: " ",
            iconRight: .icFavourite,
            actionLeft: {
                navigator.pop()
            },
            actionRight: {
                
            }))
    }
}

#Preview {
    TokenDetailView()
}
