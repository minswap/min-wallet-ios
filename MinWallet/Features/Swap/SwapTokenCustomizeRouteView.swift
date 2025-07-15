import SwiftUI
import FlowStacks


struct SwapTokenCustomizedRouteView: View {
    @EnvironmentObject
    private var viewModel: SwapTokenViewModel

    @Environment(\.partialSheetDismiss)
    private var onDismiss

    private let columns = [
        GridItem(.flexible(), spacing: .xl),
        GridItem(.flexible(), spacing: .xl),
    ]
    
    private let items: [AggregatorSource] = AggregatorSource.allCases
    
    @State
    var excludedSource: [String: AggregatorSource] = [:]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Customized Routing")
                .font(.titleH5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 60)
                .padding(.top, .md)
                .padding(.horizontal, .xl)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: .xl) {
                    ForEach(0..<items.count, id: \.self) { index in
                        SwapTokenCustomizedRouteItemView(source: items[index], excludedSource: $excludedSource)
                    }
                }
                .padding(.horizontal, 16)
            }
             
            Spacer(minLength: 0)
            HStack {
                CustomButton(title: "Close", variant: .secondary) {
                    onDismiss?()
                }
                .frame(height: 44)
                CustomButton(title: "Save") {
                    onDismiss?()
                    viewModel.swapSetting.excludedPools = Array(excludedSource.values)
                }
                .frame(height: 56)
                .padding(.top, 40)
                .padding(.horizontal, .xl)
            }
        }
        .frame(height: (UIScreen.current?.bounds.height ?? 0) * 0.83)
        .presentSheetModifier()
    }
}


private struct SwapTokenCustomizedRouteItemView: View {
    @State var source: AggregatorSource
    @Binding var excludedSource: [String: AggregatorSource]
    
    var body: some View {
        VStack(spacing: .xl) {
            HStack(spacing: 4) {
                Spacer()
                if excludedSource[source.id] == nil || source.isLocked {
                    Image(.icChecked)
                }
            }
            Text(source.name)
                .font(.paragraphXSmall)
                .foregroundStyle(.colorBaseTent)
                .padding(.horizontal, .md)
                .frame(height: 20)
                .background(
                    RoundedRectangle(cornerRadius: BorderRadius.full).fill(.colorBaseTent)
                )
        }
        .padding(.xl)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(excludedSource[source.id] == nil ? .colorInteractiveToneHighlight : .colorBorderPrimaryTer, lineWidth: 2))
        .contentShape(.rect)
        .onTapGesture {
            guard !source.isLocked else { return }
            if excludedSource[source.id] == nil {
                excludedSource[source.id] = source
            } else {
                excludedSource.removeValue(forKey: source.id)
            }
        }
    }
}

#Preview {
    SwapTokenCustomizedRouteView()
        .environmentObject(SwapTokenViewModel(tokenReceive: nil))
}
