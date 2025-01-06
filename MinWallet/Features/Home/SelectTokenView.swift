import SwiftUI
import MinWalletAPI
import FlowStacks


struct SelectTokenView: View {
    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @FocusState
    private var isFocus: Bool

    init(viewModel: SelectTokenViewModel, onSelectToken: ((TokenProtocol) -> Void)?) {
        self._viewModel = .init(wrappedValue: viewModel)
        self.onSelectToken = onSelectToken
    }
    
    @StateObject
    private var viewModel: SelectTokenViewModel
    
    var onSelectToken: ((TokenProtocol) -> Void)?
    
    var body: some View {
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
            .padding(.top, 30)
            ScrollView {
                if viewModel.showSkeleton {
                    ForEach(0..<20, id: \.self) { index in
                        TokenListItemSkeletonView()
                    }
                    .padding(.top, .xl)
                } else if viewModel.tokens.isEmpty {
                    HStack {
                        Spacer()
                        Text("No data")
                            .padding(.horizontal, .xl)
                            .font(.paragraphSmall)
                            .foregroundStyle(.colorBaseTent)
                        Spacer()
                    }
                    .padding(.top, .xl)
                } else {
                    LazyVStack(
                        spacing: 0,
                        content: {
                            ForEach(0..<viewModel.tokens.count, id: \.self) { index in
                                let item = viewModel.tokens[index]
                                TokenListItemView(token: item)
                                    .onTapGesture {
                                        navigator.dismiss()
                                        onSelectToken?(item)
                                    }
                                    .onAppear() {
                                        viewModel.loadMoreData(item: item)
                                    }
                            }
                        })
                }
            }
            .refreshable {
                viewModel.getTokens()
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()

                Button("Done") {
                    self.isFocus = false
                }
                .foregroundStyle(.colorLabelToolbarDone)
            }
        }
        .background(.colorBaseBackground)
    }
}

#Preview {
    SelectTokenView(viewModel: SelectTokenViewModel(ignoreToken: TokenProtocolDefault()), onSelectToken: { _ in })
}
