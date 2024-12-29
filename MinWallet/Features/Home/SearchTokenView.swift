import SwiftUI
import FlowStacks


struct SearchTokenView: View {
    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @FocusState
    private var isFocus: Bool
    @StateObject
    private var viewModel: SearchTokenViewModel = .init()

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
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
                Text("Cancel")
                    .padding(.horizontal, .xl)
                    .padding(.vertical, 6)
                    .contentShape(.rect)
                    .onTapGesture {
                        navigator.pop()
                    }
            }
            .padding(.leading, .xl)
            .padding(.top, .lg)
            if !viewModel.recentSearch.isEmpty {
                VStack(alignment: .leading, spacing: .md) {
                    HStack {
                        Text("Recent searches")
                            .font(.paragraphXSmall)
                            .foregroundStyle(.colorInteractiveTentPrimarySub)
                        Spacer()
                        Image(.icDelete)
                            .resizable()
                            .frame(width: .xl, height: .xl)
                            .onTapGesture {
                                viewModel.clearRecentSearch()
                            }
                    }
                    .frame(height: 32)
                    .padding(.top, .lg)
                    .padding(.horizontal, .xl)
                    HStack {
                        ForEach(viewModel.recentSearch, id: \.self) { token in
                            Text(token)
                                .font(.paragraphXMediumSmall)
                                .foregroundStyle(.colorBaseTent)
                                .padding(.horizontal, .md)
                                .frame(height: 40)
                                .background(RoundedRectangle(cornerRadius: 12).fill(.colorSurfacePrimaryDefault))
                                .onTapGesture {
                                    viewModel.keyword = token
                                }
                        }
                    }
                    .padding(.horizontal, .xl)
                    .padding(.bottom, .md)
                }
            }
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
                                    .swipeToDelete(
                                        offset: $viewModel.offsets[index], isDeleted: $viewModel.isDeleted[index], height: 68,
                                        onDelete: {
                                            viewModel.offsets.remove(at: index)
                                            viewModel.isDeleted.remove(at: index)
                                            viewModel.tokens.remove(at: index)
                                        }
                                    )
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
                    viewModel.addRecentSearch()
                }
                .foregroundStyle(.colorLabelToolbarDone)
            }
        }
        .background(.colorBaseBackground)
    }
}

#Preview {
    SearchTokenView()
}
