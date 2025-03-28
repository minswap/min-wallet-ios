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

    var body: some View {
        VStack(spacing: 8) {
            VStack(spacing: 0) {
                Color.colorBorderPrimaryDefault.frame(width: 36, height: 4).cornerRadius(2, corners: .allCorners)
                    .padding(.vertical, .md)
                Text("Slippage Tolerance")
                    .font(.paragraphXMediumSmall)
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
                if (Double(viewModel.swapSetting.slippageTolerance) ?? 0) >= 50 && viewModel.swapSetting.slippageSelected == nil {
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
                HStack(spacing: .xl) {
                    DashedUnderlineText(text: "Predict Swap Price", textColor: .colorBaseTent, font: .paragraphXMediumSmall)
                        .contentShape(.rect)
                        .onTapGesture {
                            onShowToolTip?("Predict Swap Price", "Estimate swap price with processing orders.")
                        }
                    Spacer()
                    Toggle("", isOn: $viewModel.swapSetting.predictSwapPrice)
                        .toggleStyle(SwitchToggleStyle())
                        .onChange(of: viewModel.swapSetting.predictSwapPrice) { autoRouter in
                            viewModel.action.send(.predictSwapPrice)
                        }
                }
                .frame(height: 32)
                .padding(.top, .lg)
                .padding(.bottom, 24)
                /*
                DashedUnderlineText(text: "Route Sorting", textColor: .colorBaseTent, font: .paragraphXMediumSmall)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, .md)
                    .contentShape(.rect)
                    .onTapGesture {
                        onShowToolTip?("Route Sorting", "Choose how to sort routes: by most liquidity for stable transactions or by high return for maximum profitability.")
                    }
                HStack(spacing: .xs) {
                    Text("Most liquidity")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(viewModel.swapSetting.routeSorting == .most ? .colorInteractiveToneTent : .colorBaseTent)
                        .frame(height: 36)
                        .padding(.horizontal, .lg)
                        .background(
                            RoundedRectangle(cornerRadius: BorderRadius.full).fill(viewModel.swapSetting.routeSorting == .most ? .colorInteractiveTentSecondaryDefault : .colorSurfacePrimaryDefault)
                        )
                        .contentShape(.rect)
                        .onTapGesture {
                            guard viewModel.swapSetting.routeSorting != .most else { return }
                            viewModel.swapSetting.routeSorting = .most
                            viewModel.action.send(.routeSorting)
                        }
                    Text("High return")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(viewModel.swapSetting.routeSorting == .high ? .colorInteractiveToneTent : .colorBaseTent)
                        .frame(height: 36)
                        .padding(.horizontal, .lg)
                        .background(
                            RoundedRectangle(cornerRadius: BorderRadius.full).fill(viewModel.swapSetting.routeSorting == .high ? .colorInteractiveTentSecondaryDefault : .colorSurfacePrimaryDefault)
                        )
                        .contentShape(.rect)
                        .onTapGesture {
                            guard viewModel.swapSetting.routeSorting != .high else { return }
                            viewModel.swapSetting.routeSorting = .high
                            viewModel.action.send(.routeSorting)
                        }
                    Spacer()
                }
                .padding(.bottom, .xl)
                Color.colorBorderPrimarySub.frame(height: 1)
                    .padding(.bottom, 20)
                HStack(spacing: 4) {
                    Image(.icArrowCircle)
                        .resizable()
                        .frame(width: .xl, height: .xl)
                    Text("Auto Router")
                        .font(.paragraphXMediumSmall)
                        .foregroundStyle(.colorBaseTent)
                    Text("Recommended")
                        .font(.paragraphXMediumSmall)
                        .foregroundStyle(.colorInteractiveToneSuccess)
                        .frame(height: 24)
                        .padding(.horizontal, .lg)
                        .background(
                            RoundedRectangle(cornerRadius: BorderRadius.full).fill(.colorSurfaceSuccess)
                        )
                    Spacer()
                    Toggle("", isOn: $viewModel.swapSetting.autoRouter)
                        .toggleStyle(SwitchToggleStyle())
                        .onChange(of: viewModel.swapSetting.autoRouter) { autoRouter in
                            viewModel.action.send(.autoRouter)
                        }
                }
                .frame(height: 24)
                .padding(.bottom, 4)
                HorizontalGeometryReader { width in
                    TextLearnMoreSendTokenView(text: "When available, uses multiple pools for better liquidity and prices. ", textClickAble: "Learn more", preferredMaxLayoutWidth: width)
                }
                .padding(.bottom, 24)
                 */
            }
            .padding(.horizontal, .xl)
            .background(content: {
                RoundedRectangle(cornerRadius: 24).fill(Color.colorBaseBackground)
            })
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
        .fixedSize(horizontal: false, vertical: true)
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
