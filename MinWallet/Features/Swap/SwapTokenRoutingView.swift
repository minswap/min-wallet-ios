import SwiftUI
import FlowStacks


struct SwapTokenRoutingView: View {
    @EnvironmentObject
    private var viewModel: SwapTokenViewModel
    
    @Environment(\.partialSheetDismiss)
    private var onDismiss
    
    @State
    private var popoverTarget: UUID?
    @State
    private var idWithProtocolName: [UUID?: String] = [:]
    @Namespace
    private var nsPopover
    
    @ViewBuilder
    private var customPopover: some View {
        if let popoverTarget {
            Text("Via \(idWithProtocolName[popoverTarget] ?? "")")
                .font(.paragraphXSmall)
                .foregroundStyle(.colorTextTooltip)
                .padding(.vertical, .md)
                .padding(.horizontal, 14)
                .background(
                    RoundedRectangle(cornerRadius: .md)
                        .fill(Color(.colorBackgroundTooltip))
                )
                .foregroundColor(.colorBackgroundTooltip)
                .offset(y: 4)
                .matchedGeometryEffect(
                    id: popoverTarget,
                    in: nsPopover,
                    properties: .position,
                    anchor: .top,
                    isSource: false
                )
                .transition(.opacity.combined(with: .scale))
                .zIndex(1)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Your trade route")
                .font(.titleH5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 60)
                .padding(.top, .md)
                .padding(.horizontal, .xl)
                .padding(.bottom, .md)
            ZStack {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        tokenInOutView
                        let estimationResponse: EstimationResponse = viewModel.iosTradeEstimate ?? .init()
                        ForEach(0..<estimationResponse.paths.count, id: \.self) { index in
                            let splits = estimationResponse.paths[index]
                            let estimationResponse = estimationResponse
                            let percent = estimationResponse.percents[gk_safeIndex: index] ?? 100
                            HStack(spacing: 0) {
                                VStack(alignment: .center, spacing: 0) {
                                    Rectangle()
                                        .fill(.colorInteractiveTentPrimarySub)
                                        .frame(width: 1)
                                        .frame(maxHeight: .infinity)
                                }
                                .frame(width: 28)
                                
                                HStack(spacing: 0) {
                                    Text("\(abs(percent).formatSNumber(maximumFractionDigits: 2))%")
                                        .foregroundStyle(.colorBaseTent)
                                        .font(.paragraphXMediumSmall)
                                        .padding(.horizontal, 12)
                                        .frame(height: 24)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: BorderRadius.full)
                                                .stroke(.colorBaseTent, lineWidth: 1)
                                        )
                                    
                                    DashedLine(lineWidth: 0.7, dash: [2.5, 2.5], color: .colorInteractiveTentPrimarySub)
                                        .frame(height: 0.7)
                                    Image(.icSplitArrow)
                                        .resizable()
                                        .frame(width: 5, height: 6)
                                        .padding(.trailing, 1)
                                    ForEach(0..<splits.count, id: \.self) { index in
                                        HStack(spacing: 0) {
                                            let split = splits[index]
                                            let tokenDefault = split.tokenOut.tokenDefault
                                            Circle()
                                                .fill(.colorBaseBackground)
                                                .frame(width: 24, height: 24)
                                                .overlay(
                                                    TokenLogoView(
                                                        currencySymbol: tokenDefault.currencySymbol,
                                                        tokenName: tokenDefault.tokenName,
                                                        isVerified: false,
                                                        forceVerified: true,
                                                        size: .init(width: 20, height: 20)
                                                    )
                                                )
                                                .overlay(
                                                    Circle()
                                                        .stroke(.colorBorderPrimaryDefault, lineWidth: 1)
                                                )
                                                .containerShape(.rect)
                                                .onTapGesture { showPopover(target: split.id, protocolName: split.protocolName) }
                                                .matchedGeometryEffect(id: split.id, in: nsPopover, anchor: .bottom)
                                            
                                            DashedLine(lineWidth: 0.7, dash: [2.5, 2.5], color: .colorInteractiveTentPrimarySub)
                                                .frame(height: 0.7)
                                            Image(.icSplitArrow)
                                                .resizable()
                                                .frame(width: 5, height: 6)
                                                .padding(.trailing, 1)
                                        }
                                    }
                                }
                                .padding(.vertical, 32)
                                VStack(alignment: .center, spacing: 0) {
                                    Rectangle()
                                        .fill(.colorInteractiveTentPrimarySub)
                                        .frame(width: 1)
                                        .frame(maxHeight: .infinity)
                                }
                                .frame(width: 28)
                            }
                        }
                        bottomView
                            .padding(.top, 2)
                    }
                    .padding(.top, 2)
                    .padding(.horizontal, .xl)
                    .padding(.bottom, .xl)
                }
                customPopover
            }
            .contentShape(Rectangle())
            .onTapGesture {
                popoverTarget = nil
            }
            Spacer(minLength: 0)
            CustomButton(title: "OK") {
                onDismiss?()
            }
            .frame(height: 56)
            .padding(.top, 40)
            .padding(.horizontal, .xl)
            .padding(.bottom, .md)
        }
        .frame(height: (UIScreen.current?.bounds.height ?? 0) * 0.83)
        .presentSheetModifier()
    }
    
    private var tokenInOutView: some View {
        HStack(spacing: 8) {
            let estimationResponse: EstimationResponse = viewModel.iosTradeEstimate ?? .init()
            let decimalIn = viewModel.isSwapExactIn ? viewModel.tokenPay.token.decimals : viewModel.tokenReceive.token.decimals
            let decimalOut = viewModel.isSwapExactIn ? viewModel.tokenReceive.token.decimals : viewModel.tokenPay.token.decimals
            let tokenIn: Binding<String> = .constant(estimationResponse.tokenIn)
            let tokenOut: Binding<String> = .constant(estimationResponse.tokenOut)
            let amountIn: Binding<Double> = .constant(estimationResponse.amountIn.toExact(decimal: decimalIn))
            let amountOut: Binding<Double> = .constant(estimationResponse.amountOut.toExact(decimal: decimalOut))
            TokenInOutView(token: tokenIn, amount: amountIn)
            Spacer(minLength: 0)
            TokenInOutView(token: tokenOut, amount: amountOut, isLeading: false)
        }
    }
    
    private var bottomView: some View {
        HStack {
            VStack(alignment: .center, spacing: 0) {
                Circle()
                    .fill(.colorInteractiveTentPrimarySub)
                    .frame(width: 6, height: 6)
            }
            .frame(width: 28)
            Spacer()
            VStack(alignment: .center, spacing: 0) {
                Circle()
                    .fill(.colorInteractiveTentPrimarySub)
                    .frame(width: 6, height: 6)
            }
            .frame(width: 28)
        }
    }
    
    private func showPopover(target: UUID, protocolName: String) {
        if popoverTarget != nil {
            popoverTarget = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                popoverTarget = target
            }
        } else {
            popoverTarget = target
        }
        idWithProtocolName[target] = protocolName
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            popoverTarget = nil
        }
    }
}

private struct TokenInOutView: View {
    @Binding
    var token: String
    @Binding
    var amount: Double
    @State
    var isLeading: Bool = true
    
    var body: some View {
        HStack(spacing: 8) {
            let tokenDefault = token.tokenDefault
            if isLeading {
                Circle()
                    .fill(.colorBaseBackground)
                    .frame(width: 28, height: 28)
                    .overlay(
                        TokenLogoView(
                            currencySymbol: tokenDefault.currencySymbol,
                            tokenName: tokenDefault.tokenName,
                            isVerified: false,
                            size: .init(width: 24, height: 24)
                        )
                    )
                    .overlay(
                        Circle()
                            .stroke(.colorInteractiveTentPrimarySub, lineWidth: 1)
                    )
                Text(amount.formatNumber(suffix: tokenDefault.adaName))
                    .font(.paragraphXMediumSmall)
                    .foregroundStyle(.colorBaseTent)
            } else {
                Text(amount.formatNumber(suffix: tokenDefault.adaName))
                    .font(.paragraphXMediumSmall)
                    .foregroundStyle(.colorBaseTent)
                Circle()
                    .fill(.colorBaseBackground)
                    .frame(width: 28, height: 28)
                    .overlay(
                        TokenLogoView(
                            currencySymbol: tokenDefault.currencySymbol,
                            tokenName: tokenDefault.tokenName,
                            isVerified: false,
                            forceVerified: true,
                            size: .init(width: 24, height: 24)
                        )
                    )
                    .overlay(
                        Circle()
                            .stroke(.colorInteractiveTentPrimarySub, lineWidth: 1)
                    )
            }
        }
    }
}

#Preview {
    SwapTokenRoutingView()
        .environmentObject(SwapTokenViewModel(tokenReceive: nil))
}
