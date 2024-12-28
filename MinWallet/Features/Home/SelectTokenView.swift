import SwiftUI
import MinWalletAPI


struct SelectTokenView: View {
    @State
    private var keyword: String = ""
    @State
    var tokens: [TopAssetQuery.Data.TopAssets.TopAsset] = []
    @FocusState
    private var isFocus: Bool

    var body: some View {
        VStack(spacing: .md) {
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
            .padding(.horizontal, .xl)
            .padding(.top, 30)
            ScrollView {
                LazyVStack(
                    spacing: 0,
                    content: {
                        ForEach(0..<tokens.count, id: \.self) { index in
                            TokenListItemView(token: tokens[index])
                        }
                    })
            }
            Spacer()
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
    SelectTokenView()
}
