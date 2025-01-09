import SwiftUI
import FlowStacks
import MinWalletAPI


struct OrderHistoryDetailView: View {
    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @State
    var order: OrderHistoryQuery.Data.Orders.WrapOrder?
    @State
    private var isExchangeRate: Bool = true

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    tokenView
                        .padding(.horizontal, .xl)
                        .padding(.top, .lg)
                    Text(order?.detail.name)
                        .font(.labelMediumSecondary)
                        .foregroundStyle(.colorBaseTent)
                        .padding(.top, .md)
                        .padding(.horizontal, .xl)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("Order type")
                            .font(.paragraphSmall)
                            .foregroundStyle(.colorInteractiveTentPrimarySub)
                        Spacer()
                        Text(order?.order?.action.value?.title)
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorBaseTent)
                    }
                    .padding(.horizontal, .xl)
                    .frame(height: 36)
                    .padding(.top, .md)
                    if let order = order, let warningContent = order.overSlippageWarning, order.order?.status.value == .created {
                        HStack(spacing: Spacing.md) {
                            Image(.icWarningYellow)
                                .resizable()
                                .frame(width: 16, height: 16)
                            Text(warningContent)
                                .lineLimit(nil)
                        }
                        .padding(.md)
                        .background(
                            RoundedRectangle(cornerRadius: .lg).fill(.colorInteractiveToneDanger8)
                        )
                        .frame(minHeight: 32)
                        .padding(.top, .xl)
                        .padding(.horizontal, .xl)
                    }
                    Color.colorBorderPrimarySub.frame(height: 1)
                        .padding(.xl)
                    inputInfoView.padding(.horizontal, .xl)
                    executeInfoView.padding(.horizontal, .xl)
                    if order?.order?.status.value != .created {
                        outputInfoView.padding(.horizontal, .xl)
                    }
                }
            }
            /*
            Spacer()
            if order?.order?.status.value == .created {
                HStack(spacing: .xl) {
                    CustomButton(title: "Cancel", variant: .secondary) {

                    }
                    .frame(height: 56)
                    CustomButton(title: "Update") {

                    }
                    .frame(height: 56)
                }
                .padding(EdgeInsets(top: 24, leading: .xl, bottom: .xl, trailing: .xl))
            }
             */
        }
        .modifier(
            BaseContentView(
                screenTitle: " ",
                actionLeft: {
                    navigator.pop()
                })
        )
    }

    private var tokenView: some View {
        HStack(spacing: .xs) {
            HStack(spacing: -4) {
                let inputs = order?.detail.inputs ?? []
                ForEach(inputs, id: \.self) { input in
                    TokenLogoView(currencySymbol: input.currencySymbol, tokenName: input.tokenName, isVerified: input.isVerified)
                }
            }
            Image(.icBack)
                .resizable()
                .rotationEffect(.degrees(180))
                .frame(width: 16, height: 16)
                .padding(.horizontal, 2)
            HStack(spacing: -4) {
                let outputs = order?.detail.outputs ?? []
                ForEach(outputs, id: \.self) { output in
                    TokenLogoView(currencySymbol: output.currencySymbol, tokenName: output.tokenName, isVerified: output.isVerified, size: .init(width: 24, height: 24))
                }
            }
            Text(order?.order?.type.value?.title)
                .font(.paragraphXMediumSmall)
                .foregroundStyle(order?.order?.type.value?.foregroundColor ?? .colorInteractiveToneHighlight)
                .padding(.horizontal, .md)
                .padding(.vertical, .xs)
                .background(
                    RoundedRectangle(cornerRadius: BorderRadius.full).fill(order?.order?.type.value?.backgroundColor ?? .colorSurfaceHighlightDefault)
                )
                .frame(height: 20)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .padding(.trailing)
            Spacer()
            HStack(spacing: 4) {
                Circle().frame(width: 4, height: 4)
                    .foregroundStyle(order?.order?.status.value?.foregroundCircleColor ?? .clear)
                Text(order?.order?.status.value?.title)
                    .font(.paragraphXMediumSmall)
                    .foregroundStyle(order?.order?.status.value?.foregroundColor ?? .colorInteractiveToneHighlight)
            }
            .padding(.horizontal, .lg)
            .padding(.vertical, .xs)
            .background(
                RoundedRectangle(cornerRadius: BorderRadius.full).fill(order?.order?.status.value?.backgroundColor ?? .colorSurfaceHighlightDefault)
            )
            .frame(height: 20)
            .lineLimit(1)
        }
    }

    private var inputInfoView: some View {
        HStack(alignment: .timelineAlignment, spacing: .xl) {
            VStack(spacing: 0) {
                Image(.icInputInfo)
                    .resizable()
                    .frame(width: 36, height: 36)
                    .alignmentGuide(
                        .timelineAlignment,
                        computeValue: { dimension in
                            dimension[VerticalAlignment.center]
                        })
                Color.colorBorderPrimaryDefault.frame(width: 1)
            }
            VStack(alignment: .leading, spacing: 0) {
                Text("Input information")
                    .font(.labelSmallSecondary)
                    .foregroundStyle(.colorBaseTent)
                    .alignmentGuide(
                        .timelineAlignment,
                        computeValue: { dimension in
                            dimension[VerticalAlignment.center]
                        })
                HStack(alignment: .top) {
                    Text("You paid")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    let inputs = order?.detail.inputs ?? []
                    VStack(alignment: .trailing, spacing: 4) {
                        ForEach(inputs, id: \.self) { input in
                            Text(input.amount.formatNumber(suffix: input.currency, font: .labelSmallSecondary, fontColor: .colorBaseTent))
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                        }
                    }
                }
                .padding(.vertical, .md)
                .padding(.top, .md)
                HStack {
                    Text("Deposit ADA")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    Text(((order?.detail.depositAda ?? 0) / 1_000_000).formatSNumber(maximumFractionDigits: 15) + " " + Currency.ada.prefix)
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                .padding(.vertical, .md)
                HStack {
                    Text("Estimated batcher fee")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    Text(((order?.detail.estimatedBatcherFee ?? 0) / 1_000_000).formatSNumber(maximumFractionDigits: 15) + " " + Currency.ada.prefix)
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                .padding(.vertical, .md)
                HStack(spacing: 4) {
                    Text("Created at")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    Text(order?.order?.createdAt.formattedDateGMT)
                        .underline()
                        .baselineOffset(4)
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                        .onTapGesture {
                            guard let link = order?.order?.txIn.txId,
                                let url = URL(string: MinWalletConstant.transactionURL + "/" + link)
                            else { return }
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    Image(.icArrowUp)
                        .fixSize(.xl)
                        .onTapGesture {
                            guard let link = order?.order?.txIn.txId,
                                let url = URL(string: MinWalletConstant.transactionURL + "/" + link)
                            else { return }
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                }
                .padding(.top, .md)
                .padding(.bottom, .xl)
            }
        }
    }

    private var executeInfoView: some View {
        HStack(alignment: .timelineAlignment, spacing: .xl) {
            VStack(spacing: 0) {
                Image(.icExecuteInfo)
                    .resizable()
                    .frame(width: 36, height: 36)
                    .alignmentGuide(
                        .timelineAlignment,
                        computeValue: { dimension in
                            dimension[VerticalAlignment.center]
                        })
                if order?.order?.status.value != .created {
                    Color.colorBorderPrimaryDefault.frame(width: 1)
                }
            }

            VStack(alignment: .leading, spacing: 0) {
                Text("Execution information")
                    .font(.labelSmallSecondary)
                    .foregroundStyle(.colorBaseTent)
                    .alignmentGuide(
                        .timelineAlignment,
                        computeValue: { dimension in
                            dimension[VerticalAlignment.center]
                        })
                HStack(alignment: .top) {
                    Text("Minimum receive")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    let outputs = order?.detail.outputs ?? []
                    VStack(alignment: .trailing, spacing: 4) {
                        ForEach(outputs, id: \.self) { output in
                            Text(output.satisfiedAmount.formatNumber(suffix: output.currency, font: .labelSmallSecondary, fontColor: .colorBaseTent))
                                .lineLimit(1)
                        }
                    }
                }
                .padding(.vertical, .md)
                .padding(.top, .md)
                let tradingFees = order?.detail.tradingFee ?? []
                if !tradingFees.isEmpty {
                    HStack(alignment: .top) {
                        Text("Trading fee")
                            .font(.paragraphSmall)
                            .foregroundStyle(.colorInteractiveTentPrimarySub)
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            ForEach(tradingFees, id: \.self) { output in
                                Text(output.amount.formatNumber(suffix: output.currency, font: .labelSmallSecondary, fontColor: .colorBaseTent))
                                    .lineLimit(1)
                            }
                        }
                    }
                    .padding(.vertical, .md)
                }
                HStack {
                    Text("Executed batcher fee")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    Text(((order?.detail.executedBatcherFee ?? 0) / 1_000_000).formatSNumber(maximumFractionDigits: 15) + " " + Currency.ada.prefix)
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                .padding(.vertical, .md)
                if order?.isShowRouter == true {
                    HStack(spacing: 4) {
                        Text("Route")
                            .font(.paragraphSmall)
                            .foregroundStyle(.colorInteractiveTentPrimarySub)
                        Spacer()
                        Text(order?.detail.routes)
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorBaseTent)
                    }
                    .padding(.top, .md)
                }
            }
            .padding(.bottom, .xl)
        }
    }

    private var outputInfoView: some View {
        HStack(alignment: .timelineAlignment, spacing: .xl) {
            VStack(spacing: 0) {
                Image(.icOutputInfo)
                    .resizable()
                    .frame(width: 36, height: 36)
                    .alignmentGuide(
                        .timelineAlignment,
                        computeValue: { dimension in
                            dimension[VerticalAlignment.center]
                        })
            }
            VStack(alignment: .leading, spacing: 0) {
                Text("Output information")
                    .font(.labelSmallSecondary)
                    .foregroundStyle(.colorBaseTent)
                    .alignmentGuide(
                        .timelineAlignment,
                        computeValue: { dimension in
                            dimension[VerticalAlignment.center]
                        })
                HStack(alignment: .top) {
                    Text("You receive")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    let outputs = order?.detail.outputs ?? []
                    VStack(alignment: .trailing, spacing: 4) {
                        ForEach(outputs, id: \.self) { output in
                            Text(output.amount.formatNumber(suffix: output.currency, font: .labelSmallSecondary, fontColor: .colorBaseSuccess))
                                .lineLimit(1)
                        }
                    }
                }
                .padding(.vertical, .md)
                .padding(.top, .md)
                if order?.isShowRouter == true {
                    HStack(spacing: 4) {
                        Text("Executed price")
                            .font(.paragraphSmall)
                            .foregroundStyle(.colorInteractiveTentPrimarySub)
                        Spacer()
                        let inputName = order?.detail.inputs.first?.currency ?? ""
                        let inputAmount: Double = order?.detail.inputs.first?.amount ?? 1
                        let outputName = order?.detail.outputs.first?.currency ?? ""
                        let outputAmount: Double = order?.detail.outputs.first?.amount ?? 1
                        let rate = pow(outputAmount / (inputAmount == 0 ? 1 : inputAmount), isExchangeRate ? 1 : -1)
                        Text("1 \(isExchangeRate ? inputName : outputName) = ")
                            .font(.labelSmallSecondary)
                            .foregroundColor(.colorBaseTent) + Text(rate.formatNumber(font: .labelSmallSecondary, fontColor: .colorBaseTent)) + Text(" \(!isExchangeRate ? inputName : outputName)").font(.labelSmallSecondary).foregroundColor(.colorBaseTent)
                        Image(.icExecutePrice)
                            .fixSize(.xl)
                    }
                    .padding(.vertical, .md)
                    .contentShape(.rect)
                    .onTapGesture {
                        isExchangeRate.toggle()
                    }
                }
                let changeAmount = order?.detail.changeAmount ?? []
                if !changeAmount.isEmpty {
                    HStack(alignment: .top) {
                        Text("Change amount")
                            .font(.paragraphSmall)
                            .foregroundStyle(.colorInteractiveTentPrimarySub)
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            ForEach(changeAmount, id: \.self) { output in
                                Text(output.amount.formatNumber(suffix: output.currency, font: .labelSmallSecondary, fontColor: .colorBaseTent))
                                    .lineLimit(1)
                            }
                        }
                    }
                    .padding(.vertical, .md)
                }
                HStack {
                    Text("Deposit ADA")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    Text(((order?.detail.depositAda ?? 0) / 1_000_000).formatSNumber(maximumFractionDigits: 15) + " " + Currency.ada.prefix)
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                .padding(.vertical, .md)
                HStack(spacing: 4) {
                    Text(order?.order?.status.value == .batched ? "Batched at" : "Cancelled at")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    Text(order?.order?.updatedAt?.formattedDateGMT)
                        .underline()
                        .baselineOffset(4)
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                        .onTapGesture {
                            guard let link = order?.order?.updatedTxId,
                                let url = URL(string: MinWalletConstant.transactionURL + "/" + link)
                            else { return }
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    Image(.icArrowUp)
                        .fixSize(.xl)
                        .onTapGesture {
                            guard let link = order?.order?.updatedTxId,
                                let url = URL(string: MinWalletConstant.transactionURL + "/" + link)
                            else { return }
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                }
                .padding(.top, .md)
            }
        }
    }


}


fileprivate extension VerticalAlignment {
    struct TimelineAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.top]
        }
    }

    static let timelineAlignment = VerticalAlignment(TimelineAlignment.self)
}

#Preview {
    OrderHistoryDetailView()
}
