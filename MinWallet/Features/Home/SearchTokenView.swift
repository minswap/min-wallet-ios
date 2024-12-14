import SwiftUI
import FlowStacks


struct SearchTokenView: View {
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>

    @State
    private var keyword: String = ""

    @FocusState
    private var isFocus: Bool

    @State
    private var tokenSample: [String] = ["ADA - MIN", "ADA - MINZ", "MIN", "ADA"]
    @State
    private var hasRecentDelete: Bool = true

    @StateObject
    private var viewModel: SearchTokenViewModel = .init()

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                HStack(spacing: .md) {
                    Image(.icSearch)
                        .resizable()
                        .frame(width: 20, height: 20)
                    TextField("", text: $keyword)
                        .placeholder("Search", when: keyword.isEmpty)
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
            if hasRecentDelete {
                VStack(alignment: .leading, spacing: .md) {
                    HStack {
                        Text("Recent searches")
                            .font(.paragraphXSmall)
                            .foregroundStyle(.colorInteractiveTentPrimarySub)
                        Spacer()
                        Image(.icDelete)
                            .resizable()
                            .frame(width: .xl, height: .xl)
                    }
                    .frame(height: 32)
                    .padding(.top, .lg)
                    .padding(.horizontal, .xl)

                    HStack {
                        ForEach(tokenSample, id: \.self) { token in
                            Text(token)
                                .font(.paragraphXMediumSmall)
                                .foregroundStyle(.colorBaseTent)
                                .padding(.horizontal, .md)
                                .frame(height: 40)
                                .background(RoundedRectangle(cornerRadius: 12).fill(.colorSurfacePrimaryDefault))
                        }
                    }
                    .padding(.horizontal, .xl)
                    .padding(.bottom, .md)
                }
            }
            ScrollView {
                LazyVStack(
                    spacing: 0,
                    content: {
                        ForEach(0..<viewModel.tokens.count, id: \.self) { index in
                            TokenListItemView(tokenWithPrice: viewModel.tokens[index])
                                .swipeToDelete(
                                    offset: $viewModel.offsets[index], isDeleted: $viewModel.isDeleted[index], height: 68,
                                    onDelete: {
                                        viewModel.offsets.remove(at: index)
                                        viewModel.isDeleted.remove(at: index)
                                        viewModel.tokens.remove(at: index)
                                    })
                        }
                    })
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
    SearchTokenView()
}
