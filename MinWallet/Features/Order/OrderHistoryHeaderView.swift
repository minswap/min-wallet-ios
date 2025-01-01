import SwiftUI


struct OrderHistoryHeaderView: View {
    static let heightLargeHeader: CGFloat = 60
    static let smallLargeHeader: CGFloat = 48

    @Binding
    var progress: CGFloat
    @State
    var showSearch: Bool = false
    @State
    var showFilterView: Bool = false
    @State
    var keyword: String = ""
    @FocusState
    var isFocus: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
            ZStack(alignment: .leading) {
                smallHeader
//                    .opacity(max(0, min(1, (progress - 0.75) * 4.0)))
                    .frame(height: Self.smallLargeHeader)
                largeHeader
                    .frame(height: Self.heightLargeHeader)
                    .opacity(1 - max(0, min(1, (progress - 0.75) * 4.0)))
            }
        }
    }
    
    private var smallHeader: some View {
        HStack(alignment: .center, spacing: .md) {
            if showSearch {
                HStack(alignment: .center, spacing: 0) {
                    HStack(spacing: .md) {
                        Image(.icSearch)
                            .resizable()
                            .frame(width: 20, height: 20)
                        TextField("", text: $keyword)
                            .placeholder("Search", when: keyword.isEmpty)
                            .focused($isFocus)
                            .lineLimit(1)
                        if !keyword.isEmpty {
                            Image(.icCloseFill)
                                .resizable()
                                .frame(width: 20, height: 20)
                                .onTapGesture {
                                    keyword = ""
                                }
                        }
                    }
                    .padding(.md)
                    .overlay(
                        RoundedRectangle(cornerRadius: BorderRadius.full)
                            .stroke(isFocus ? .colorBorderPrimaryPressed : .colorBorderPrimaryDefault, lineWidth: isFocus ? 2 : 1)
                    )
                    Text("Cancel")
                        .padding(.horizontal, .xl)
                        .padding(.vertical, 6)
                        .contentShape(.rect)
                        .onTapGesture {
                            withAnimation {
                                showSearch = false
                            }
                        }
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            } else {
                Text("Orders")
                    .foregroundStyle(.colorBaseTent)
                    .font(.labelMediumSecondary)
                    .padding(.leading, 68)
                    .transition(.scale.combined(with: .opacity))
                Spacer()
                HStack(spacing: .md) {
                    Image(.icSearchOrder)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .onTapGesture {
                            withAnimation {
                                showSearch = true
                            }
                        }
                    Image(.icFilter)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            withAnimation {
                                showSearch = true
                            }
                        }
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, .xl)
        .background(.colorBaseBackground)
    }
    
    private var largeHeader: some View {
        VStack(alignment: .leading, spacing: 0) {
            Color.clear.frame(height: 12)
            Text("Orders")
                .foregroundStyle(.colorBaseTent)
                .font(.titleH4)
                .padding(.top, .lg)
                .padding(.bottom, .lg)
           
        }
        .padding(.horizontal, .xl)
    }
}

#Preview {
    VStack(
        alignment: .leading, spacing: 0,
        content: {
            OrderHistoryHeaderView(progress: .constant(100))
//                .background(.gray)
            Spacer()
        })
}
