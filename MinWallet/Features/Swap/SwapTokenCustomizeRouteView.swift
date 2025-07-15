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
            VStack(alignment: .leading, spacing: 4) {
                let count = AggregatorSource.allCases.count - excludedSource.count
                Text("Select All (\(count))")
                    .font(.labelMediumSecondary)
                    .foregroundStyle(.colorBaseTent)
                    .frame(height: 24)
                Text("For the best possible rates, this setting should be turned off if you are not familiar with it")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
            }
            .padding(.xl)
            .frame(width: .infinity)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(.colorBorderPrimaryTer, lineWidth: 2))
            .padding(.horizontal, .xl)
            .padding(.bottom, .xl)
            .contentShape(.rect)
            .onTapGesture {
                excludedSource = [:]
            }
            ScrollView {
                LazyVGrid(columns: columns, spacing: .lg) {
                    ForEach(0..<items.count, id: \.self) { index in
                        SwapTokenCustomizedRouteItemView(source: items[index], excludedSource: $excludedSource)
                    }
                }
                .padding(.horizontal, .xl)
            }
             
            Spacer(minLength: 0)
            HStack(spacing: 16) {
                CustomButton(title: "Cancel", variant: .secondary) {
                    onDismiss?()
                }
                .frame(height: 56)
                CustomButton(title: "Save") {
                    onDismiss?()
                    viewModel.swapSetting.excludedPools = Array(excludedSource.values)
                }
                .frame(height: 56)
            }
            .padding(.horizontal, .xl)
            .padding(.top, ._3xl)
        }
        .frame(height: (UIScreen.current?.bounds.height ?? 0) * 0.83)
        .presentSheetModifier()
    }
}


private struct SwapTokenCustomizedRouteItemView: View {
    @State var source: AggregatorSource
    @Binding var excludedSource: [String: AggregatorSource]
    
    var body: some View {
        VStack(alignment: .leading, spacing: .xl) {
            HStack(spacing: 4) {
                Image(.icChecked)
                Spacer()
                if excludedSource[source.rawId] == nil || source.isLocked {
                    Image(.icChecked)
                }
            }
            Text(source.name)
                .font(.paragraphXSmall)
                .foregroundStyle(.colorBaseTent)
                .padding(.horizontal, .md)
                .frame(height: 20)
        }
        .padding(.xl)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(excludedSource[source.rawId] == nil ? .colorInteractiveToneHighlight : .colorBorderPrimaryTer, lineWidth: 2))
        .contentShape(.rect)
        .onTapGesture {
            guard !source.isLocked else { return }
            if excludedSource[source.rawId] == nil {
                excludedSource[source.rawId] = source
            } else {
                excludedSource.removeValue(forKey: source.rawId)
            }
        }
    }
}

#Preview {
    SwapTokenCustomizedRouteView()
        .environmentObject(SwapTokenViewModel(tokenReceive: nil))
}
