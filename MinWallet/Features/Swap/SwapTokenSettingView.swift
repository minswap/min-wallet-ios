import SwiftUI


struct SwapTokenSettingView: View {
    enum Slippage: Double, CaseIterable, Identifiable {
        var id: String { UUID().uuidString }

        case _01 = 0.1
        case _05 = 0.5
        case _1 = 1
        case _2 = 2
    }

    @Binding
    var isShowSwapSetting: Bool

    @State
    private var slippages: [Slippage] = Slippage.allCases
    @State
    private var slippageSelected: Slippage? = ._01
    @State
    private var percent: String = ""
    @FocusState
    private var isFocus: Bool
    @State
    private var enablePredictSwapPrice: Bool = true

    let maxValue: Double = 100.0  // Define the maximum value

    @Environment(\.partialSheetDismiss)
    var onDismiss

    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            VStack(spacing: 0) {
                Color.colorBorderPrimaryDefault.frame(width: 36, height: 4)
                    .padding(.vertical, .md)
                Text("Slippage Tolerance")
                    .font(.paragraphXMediumSmall)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                HStack(spacing: 0) {
                    ForEach(slippages) { splippage in
                        Text("\(splippage.rawValue.formatted())%")
                            .font(.labelSmallSecondary)
                            .foregroundStyle(splippage == slippageSelected ? .colorBaseBackground : .colorBaseTent)
                            .fixedSize(horizontal: true, vertical: false)
                            .frame(height: 36)
                            .padding(.horizontal, .lg)
                            .background(content: {
                                RoundedRectangle(cornerRadius: BorderRadius.full).fill(splippage == slippageSelected ? .colorInteractiveTentSecondaryDefault : .colorSurfacePrimaryDefault)
                            })
                            .contentShape(.rect)
                            .onTapGesture {
                                slippageSelected = splippage
                            }
                        Spacer()
                    }
                    HStack(spacing: .md) {
                        TextField("", text: $percent)
                            .keyboardType(.decimalPad)
                            .placeholder("Custom", when: percent.isEmpty)
                            .focused($isFocus)
                            .lineLimit(1)
                            .onChange(of: percent) { newValue in
                                let newValue = newValue.replacingOccurrences(of: ",", with: ".")
                                let filtered: String = {
                                    if let number = Double(newValue), number > maxValue {
                                        return String(maxValue)
                                    }
                                    return newValue
                                }()
                                percent = filtered
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
                HStack(spacing: .xl) {
                    Text("Predict Swap Price")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                    Spacer()
                    Toggle("", isOn: $enablePredictSwapPrice)
                        .toggleStyle(SwitchToggleStyle())
                }
                .frame(height: 32)
                .padding(.top, .lg)
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
                        .foregroundStyle(.colorBaseTent)
                    Spacer()
                    Toggle("", isOn: $enablePredictSwapPrice)
                        .toggleStyle(SwitchToggleStyle())
                }
                .frame(height: 24)
                .padding(.bottom, 4)
                Text("When available, uses multiple pools for better liquidity and prices.")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
                Color.colorBorderPrimarySub.frame(height: 1)
                    .padding(.vertical, .xl)
                Text("To view risky options like Unlimited Slippage you must disable safe mode")
                    .font(.paragraphXSmall)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
                    .padding(.bottom, 24)
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
            .padding(.bottom, .xl)
        }
    }
}

#Preview {
    VStack {
        SwapTokenSettingView(isShowSwapSetting: Binding<Bool>.constant(false))
            .padding(16)
        Spacer()
    }
    .background(Color.black)
}
