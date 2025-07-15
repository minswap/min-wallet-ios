import SwiftUI


struct SwapTokenSettingView: View {
    enum Slippage: Double, CaseIterable, Identifiable {
        var id: String { UUID().uuidString }

        case _01 = 0.1
        case _05 = 0.5
        case _1 = 1
        case _2 = 2
    }

    @State
    private var slippages: [Slippage] = Slippage.allCases
    @FocusState
    private var isFocus: Bool

    var onShowToolTip: ((_ title: LocalizedStringKey, _ content: LocalizedStringKey) -> Void)?

    let maxValue: Double = 100.0  // Define the maximum value

    @Environment(\.partialSheetDismiss)
    var onDismiss
    @ObservedObject
    var viewModel: SwapTokenViewModel

    @State
    var showCustomizedRoute: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text("Slippage Tolerance")
                    .font(.labelSmallSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                HStack(spacing: 0) {
                    ForEach(0..<slippages.count, id: \.self) { index in
                        if let splippage = slippages[gk_safeIndex: index] {
                            Text("\(splippage.rawValue.formatSNumber())%")
                                .font(.labelSmallSecondary)
                                .foregroundStyle(splippage == viewModel.swapSetting.slippageSelected ? .colorBaseBackground : .colorBaseTent)
                                .fixedSize(horizontal: true, vertical: false)
                                .frame(height: 36)
                                .padding(.horizontal, .lg)
                                .background(content: {
                                    RoundedRectangle(cornerRadius: BorderRadius.full).fill(splippage == viewModel.swapSetting.slippageSelected ? .colorInteractiveTentSecondaryDefault : .colorSurfacePrimaryDefault)
                                })
                                .contentShape(.rect)
                                .onTapGesture {
                                    viewModel.swapSetting.slippageSelected = splippage
                                    viewModel.action.send(.recheckUnSafeSlippage)
                                }
                            Spacer()
                        }
                    }
                    HStack(spacing: .md) {
                        TextField("", text: $viewModel.swapSetting.slippageTolerance)
                            .keyboardType(.decimalPad)
                            .placeholder("Custom", when: viewModel.swapSetting.slippageTolerance.isEmpty)
                            .focused($isFocus)
                            .lineLimit(1)
                            .onChange(of: viewModel.swapSetting.slippageTolerance) { newValue in
                                viewModel.swapSetting.slippageTolerance = AmountTextField.formatCurrency(newValue, minValue: 0, maxValue: maxValue, minimumFractionDigits: 4)
                                viewModel.swapSetting.slippageSelected = nil
                                viewModel.action.send(.recheckUnSafeSlippage)
                            }
                        Text("%")
                            .font(.labelMediumSecondary)
                            .foregroundStyle(.colorInteractiveTentPrimarySub)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    .frame(height: 36)
                    .padding(.horizontal, .lg)
                    .overlay(RoundedRectangle(cornerRadius: BorderRadius.full).stroke(.colorBorderPrimaryDefault, lineWidth: 1))
                }
                .padding(.top, .md)
                if (Double(viewModel.swapSetting.slippageTolerance) ?? 0) >= 50 && viewModel.swapSetting.slippageSelected == nil && viewModel.swapSetting.safeMode {
                    HStack(spacing: Spacing.md) {
                        Image(.icWarning)
                            .resizable()
                            .frame(width: 16, height: 16)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Unsafe slippage tolerance.")
                                .lineLimit(0)
                                .font(.paragraphSemi)
                                .foregroundStyle(.colorInteractiveToneDanger)
                            Text("Beware that using over 50% slippage is risky. It means that you are willing to accept a price movement of over 50% once your order is executed.")
                                .font(.paragraphXSmall)
                                .foregroundStyle(.colorInteractiveToneDanger)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(.md)
                    .background(
                        RoundedRectangle(cornerRadius: 8).fill(.colorInteractiveToneDanger8)
                    )
                    .padding(.top, .xl)
                }
                HStack {
                    Text("Liquidity Source")
                        .font(.labelSmallSecondary)
                    
                    Spacer()
                    
                    HStack(spacing: .md) {
                        Text("9/9")
                            .font(.paragraphSmall)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: BorderRadius.full)
                                    .stroke(.colorBorderPrimaryDefault, lineWidth: 1)
                            )
                        Image(.icArrowRight)
                    }
                }
                .padding(.top, .md)
                .onTapGesture {
                    hideKeyboard()
                    $showCustomizedRoute.showSheet()
                }
                Divider()
                    .frame(height: 1)
                    .background(Color.colorBorderPrimarySub)
                    .padding(.top, .xl)
                VStack(spacing: 4) {
                    HStack {
                        HStack(spacing: .md) {
                            Image(.icShieldCheck)
                                .resizable()
                                .frame(width: 16, height: 16)
                            Text("Safe Mode")
                                .font(.labelSmallSecondary)
                                .foregroundColor(.colorBaseTent)
                        }
                        Text("Recommended")
                            .font(.labelSmallSecondary)
                            .foregroundColor(.colorInteractiveToneSuccess)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: BorderRadius.full)
                                    .fill(.colorSurfaceSuccess)
                            )
                        Spacer()
                        Toggle("", isOn: $viewModel.swapSetting.safeMode)
                            .toggleStyle(SwitchToggleStyle())
                            .onChange(of: viewModel.swapSetting.safeMode) { safeMode in
                                viewModel.action.send(.safeMode)
                            }
                    }
                    
                    Text("Prevent high price impact trades. Disable at your own risk.")
                        .font(.paragraphSmall)
                        .foregroundColor(.colorInteractiveTentPrimarySub)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top, .xl)
                Spacer()
                Button(
                    action: {
                        onDismiss?()
                    },
                    label: {
                        Text("Close")
                            .font(.labelMediumSecondary)
                            .foregroundStyle(.colorInteractiveTentSecondaryDefault)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(content: {
                                RoundedRectangle(cornerRadius: 24).fill(Color.colorBaseBackground)
                            })
                    }
                )
                .frame(height: 56)
                .buttonStyle(.plain)
            }
            .padding(.horizontal, .xl)
            .background(.colorBaseBackground)
            .frame(minHeight: (UIScreen.current?.bounds.height ?? 0) * 0.83, maxHeight: (UIScreen.current?.bounds.height ?? 0) * 0.83)
            .presentSheetModifier()
                //        .presentSheet(
                //            isPresented: $showCustomizedRoute,
                //            content: {
                //                let excludedPools = viewModel.swapSetting.excludedPools.reduce([:]) { result, source in
                //                    result.appending([source.id: source])
                //                }
                //                SwapTokenCustomizedRouteView(excludedSource: excludedPools)
                //                    .environmentObject(viewModel)
                //            }
                //        )
        }
    }
}

#Preview {
    VStack {
        SwapTokenSettingView(viewModel: SwapTokenViewModel(tokenReceive: nil))
            .padding(16)
        Spacer()
    }
    .background(Color.black)
}
