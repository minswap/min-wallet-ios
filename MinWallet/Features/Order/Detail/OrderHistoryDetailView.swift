import SwiftUI
import FlowStacks
import MinWalletAPI


struct OrderHistoryDetailView: View {
    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    private var hud: HUDState
    @EnvironmentObject
    private var bannerState: BannerState
    @EnvironmentObject
    private var userInfo: UserInfo
    @EnvironmentObject
    private var appSetting: AppSetting
    @State
    var order: OrderHistory = .init()
    @State
    private var isExchangeRate: Bool = true
    @State
    private var showCancelOrder: Bool = false
    @State
    private var isShowSignContract: Bool = false
    var onReloadOrder: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    tokenView
                        .padding(.horizontal, .xl)
                        .padding(.top, .lg)
                    Text(order.name)
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
                        Text(order.detail.orderType.title)
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorBaseTent)
                    }
                    .padding(.horizontal, .xl)
                    .frame(height: 36)
                    .padding(.top, .md)
                    if let source = order.aggregatorSource {
                        HStack(alignment: .top, spacing: .xs) {
                            Text("Interacted with")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorInteractiveTentPrimarySub)
                            Spacer()
                            Image(source.image)
                                .fixSize(20)
                            Text(source.name)
                                .font(.labelSmallSecondary)
                                .foregroundStyle(.colorBaseTent)
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                        }
                        .padding(.horizontal, .xl)
                        .frame(height: 36)
                    }
                    Color.colorBorderPrimarySub.frame(height: 1)
                        .padding(.xl)
                    inputInfoView.padding(.horizontal, .xl)
                    executeInfoView.padding(.horizontal, .xl)
                    if order.status != .created {
                        outputInfoView.padding(.horizontal, .xl)
                    }
                }
            }
            if order.status == .created {
                Spacer()
                HStack(spacing: .xl) {
                    CustomButton(title: "Cancel", variant: .secondary) {
                        $showCancelOrder.showSheet()
                    }
                    .frame(height: 56)
                    /*
                    CustomButton(title: "Update") {
                    
                    }
                    .frame(height: 56)
                     */
                }
                .padding(EdgeInsets(top: 24, leading: .xl, bottom: .xl, trailing: .xl))
            }
        }
        .modifier(
            BaseContentView(
                screenTitle: " ",
                actionLeft: {
                    navigator.pop()
                })
        )
        .presentSheet(isPresented: $showCancelOrder) {
            OrderHistoryCancelView {
                Task {
                    do {
                        switch appSetting.authenticationType {
                        case .biometric:
                            try await appSetting.reAuthenticateUser()
                            authenticationSuccess()
                        case .password:
                            $isShowSignContract.showSheet()
                        }
                    } catch {
                        bannerState.showBannerError(error.localizedDescription)
                    }
                }
            }
        }
        .presentSheet(isPresented: $isShowSignContract) {
            SignContractView(
                onSignSuccess: {
                    authenticationSuccess()
                }
            )
        }
    }
    
    private var tokenView: some View {
        HStack(spacing: .xs) {
            HStack(spacing: -4) {
                let inputs = order.inputAsset
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
                let outputs = order.outputAsset
                ForEach(outputs, id: \.self) { output in
                    TokenLogoView(currencySymbol: output.currencySymbol, tokenName: output.tokenName, isVerified: output.isVerified, size: .init(width: 24, height: 24))
                }
            }
            if let nameVersion = order.aggregatorSource?.nameVersion, !nameVersion.isBlank {
                Text(nameVersion)
                    .font(.paragraphXMediumSmall)
                    .foregroundStyle(nameVersion.foregroundColor ?? .colorInteractiveToneHighlight)
                    .padding(.horizontal, .md)
                    .padding(.vertical, .xs)
                    .background(
                        RoundedRectangle(cornerRadius: BorderRadius.full).fill(nameVersion.backgroundColor ?? .colorSurfaceHighlightDefault)
                    )
                    .frame(height: 20)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .padding(.trailing)
            }
            Spacer()
            HStack(spacing: 4) {
                Circle().frame(width: 4, height: 4)
                    .foregroundStyle(order.status?.foregroundCircleColor ?? .clear)
                Text(order.status?.title)
                    .font(.paragraphXMediumSmall)
                    .foregroundStyle(order.status?.foregroundColor ?? .colorInteractiveToneHighlight)
            }
            .padding(.horizontal, .lg)
            .padding(.vertical, .xs)
            .background(
                RoundedRectangle(cornerRadius: BorderRadius.full).fill(order.status?.backgroundColor ?? .colorSurfaceHighlightDefault)
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
                    let inputs = order.inputAsset
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
                    Text("Refundable deposit")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    Text((order.depositAda.toExact(decimal: 6).formatSNumber(maximumFractionDigits: 15)) + " " + Currency.ada.prefix)
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                .padding(.vertical, .md)
                HStack {
                    Text("Estimated execution fee")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    Text(((order.batcherFee) / 1_000_000).formatSNumber(maximumFractionDigits: 15) + " " + Currency.ada.prefix)
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                .padding(.vertical, .md)
                HStack(spacing: 4) {
                    Text("Created at")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    Text(order.createdAt?.formattedDateGMT)
                        .underline()
                        .baselineOffset(4)
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                        .onTapGesture {
                            order.createdTxId.viewTransaction()
                        }
                    Image(.icArrowUp)
                        .fixSize(.xl)
                        .onTapGesture {
                            order.createdTxId.viewTransaction()
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
                if order.status != .created {
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
                    .padding(.bottom, .md)
                if order.detail.orderType == .partialSwap {
                    if order.detail.limitAmount > 0 {
                        HStack(alignment: .top) {
                            Text("Limit amount")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorInteractiveTentPrimarySub)
                            Spacer()
                            Text(order.detail.limitAmount.toExact(decimal: order.output?.decimals).formatNumber(suffix: order.output?.currency ?? "", font: .labelSmallSecondary, fontColor: .colorBaseTent))
                                .lineLimit(1)
                        }
                        .padding(.vertical, .md)
                    }
                    if order.detail.maxSwapTime > 0 {
                        HStack(alignment: .top) {
                            Text("Max swap times")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorInteractiveTentPrimarySub)
                            Spacer()
                            Text(Double(order.detail.maxSwapTime).formatNumber(font: .labelSmallSecondary, fontColor: .colorBaseTent))
                                .lineLimit(1)
                        }
                        .padding(.vertical, .md)
                    }
                    if order.detail.minSwapAmount > 0 {
                        HStack(alignment: .top) {
                            Text("Minimum swap amount")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorInteractiveTentPrimarySub)
                            Spacer()
                            Text(order.detail.minSwapAmount.toExact(decimal: order.input?.decimals).formatNumber(suffix: order.input?.currency ?? "", font: .labelSmallSecondary, fontColor: .colorBaseTent))
                                .lineLimit(1)
                        }
                        .padding(.vertical, .md)
                    }
                } else {
                    if order.detail.orderType == .zapIn || order.detail.orderType == .zapOut {
                        HStack(alignment: .top) {
                            Text("Swap amount")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorInteractiveTentPrimarySub)
                            Spacer()
                            Text(order.detail.swapAmount.toExact(decimal: order.input?.decimals).formatNumber(suffix: order.input?.currency ?? "", font: .labelSmallSecondary, fontColor: .colorBaseTent))
                                .lineLimit(1)
                        }
                        .padding(.vertical, .md)
                    }
                    
                    HStack(alignment: .top) {
                        Text(order.detail.orderType == .limit ? "Limit amount" : "Minimum receive")
                            .font(.paragraphSmall)
                            .foregroundStyle(.colorInteractiveTentPrimarySub)
                        Spacer()
                        let outputs = order.outputAsset
                        VStack(alignment: .trailing, spacing: 4) {
                            ForEach(outputs, id: \.self) { output in
                                Text(output.minimumAmount.formatNumber(suffix: output.currency, font: .labelSmallSecondary, fontColor: .colorBaseTent))
                                    .lineLimit(1)
                            }
                        }
                    }
                    .padding(.vertical, .md)
                }
                if let tradingFeeAsset = order.tradingFeeAsset, !tradingFeeAsset.amount.isZero {
                    HStack(alignment: .top) {
                        Text("Trading fee")
                            .font(.paragraphSmall)
                            .foregroundStyle(.colorInteractiveTentPrimarySub)
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(tradingFeeAsset.amount.formatNumber(suffix: tradingFeeAsset.currency, font: .labelSmallSecondary, fontColor: .colorBaseTent))
                                .lineLimit(1)
                        }
                    }
                    .padding(.vertical, .md)
                }
                if  order.status == .batched {
                    HStack {
                        Text("Executed fee")
                            .font(.paragraphSmall)
                            .foregroundStyle(.colorInteractiveTentPrimarySub)
                        Spacer()
                        Text(((order.batcherFee) / 1_000_000).formatSNumber(maximumFractionDigits: 15) + " " + Currency.ada.prefix)
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorBaseTent)
                    }
                    .padding(.vertical, .md)
                }
                if order.isShowRouter, !order.routing.isEmpty {
                    HStack(spacing: 4) {
                        Text("Route")
                            .font(.paragraphSmall)
                            .foregroundStyle(.colorInteractiveTentPrimarySub)
                        Spacer()
                        Text(order.routing)
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorBaseTent)
                    }
                    .padding(.top, .md)
                }
                if let expiredAt = order.detail.expireAt, !expiredAt.isEmpty, order.status == .created {
                    HStack(spacing: 4) {
                        Text("Expires at")
                            .font(.paragraphSmall)
                            .foregroundStyle(.colorInteractiveTentPrimarySub)
                        Spacer()
                        Text(expiredAt.formattedDateGMT)
                            .underline()
                            .baselineOffset(4)
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorBaseTent)
                            .onTapGesture {
                                order.createdTxId.viewTransaction()
                            }
                        Image(.icArrowUp)
                            .fixSize(.xl)
                            .onTapGesture {
                                order.createdTxId.viewTransaction()
                            }
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
                    .padding(.bottom, .md)
                if order.status == .batched {
                    HStack(alignment: .top) {
                        Text("You receive")
                            .font(.paragraphSmall)
                            .foregroundStyle(.colorInteractiveTentPrimarySub)
                        Spacer()
                        let outputs = order.outputAsset
                        VStack(alignment: .trailing, spacing: 4) {
                            ForEach(outputs, id: \.self) { output in
                                Text(output.amount.formatNumber(suffix: output.currency, font: .labelSmallSecondary, fontColor: .colorBaseSuccess))
                                    .lineLimit(1)
                            }
                        }
                    }
                    .padding(.vertical, .md)
                    if order.isShowExecutedPrice, let input = order.input, let output = order.output {
                        HStack(spacing: 4) {
                            Text("Executed price")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorInteractiveTentPrimarySub)
                            Spacer()
                            let rate = pow(output.amount / (input.amount == 0 ? 1 : input.amount), isExchangeRate ? 1 : -1)
                            Text("1 \(isExchangeRate ? input.asset.adaName : output.asset.adaName) = ")
                                .font(.labelSmallSecondary)
                                .foregroundColor(.colorBaseTent) + Text(rate.formatNumber(font: .labelSmallSecondary, fontColor: .colorBaseTent)) + Text(" \(!isExchangeRate ? input.asset.adaName : output.asset.adaName)").font(.labelSmallSecondary).foregroundColor(.colorBaseTent)
                            Image(.icExecutePrice)
                                .fixSize(.xl)
                        }
                        .padding(.vertical, .md)
                        .contentShape(.rect)
                        .onTapGesture {
                            isExchangeRate.toggle()
                        }
                    }
                    if let changeAmount = order.changeAmountAsset {
                        HStack(alignment: .top) {
                            Text("Change amount")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorInteractiveTentPrimarySub)
                            Spacer()
                            VStack(alignment: .trailing, spacing: 4) {
                                Text(changeAmount.amount.formatNumber(suffix: changeAmount.currency, font: .labelSmallSecondary, fontColor: .colorBaseTent))
                                    .lineLimit(1)
                            }
                        }
                        .padding(.vertical, .md)
                    }
                    HStack {
                        Text("Refundable deposit")
                            .font(.paragraphSmall)
                            .foregroundStyle(.colorInteractiveTentPrimarySub)
                        Spacer()
                        Text(((order.depositAda) / 1_000_000).formatSNumber(maximumFractionDigits: 15) + " " + Currency.ada.prefix)
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorBaseTent)
                    }
                    .padding(.vertical, .md)
                }
                HStack(spacing: 4) {
                    Text(order.status == .batched ? "Batched at" : "Cancelled at")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    Text(order.updatedAt?.formattedDateGMT)
                        .underline()
                        .baselineOffset(4)
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                        .onTapGesture {
                            order.updatedTxId?.viewTransaction()
                        }
                    Image(.icArrowUp)
                        .fixSize(.xl)
                        .onTapGesture {
                            order.updatedTxId?.viewTransaction()
                        }
                }
                .padding(.top, .md)
                let fillHistories = order.detail.fillHistory
                if !fillHistories.isEmpty && order.status == .batched {
                    Color.colorBorderPrimarySub.frame(height: 1)
                        .padding(.vertical, .xl)
                    HStack(spacing: 4) {
                        Text(fillHistories.count == 1 ? "Fill History" : "Fill Histories")
                            .font(.paragraphSmall)
                            .foregroundStyle(.colorInteractiveTentPrimarySub)
                        Spacer()
                    }
                    .padding(.bottom, .md)
                    ForEach(fillHistories, id: \.self) { history in
                        HStack(spacing: 4) {
                            Text(history.input.amount.formatNumber(suffix: history.input.currency, roundingOffset: history.input.decimals, font: .labelSmallSecondary, fontColor: .colorBaseTent))
                            Image(.icBack)
                                .fixSize(.xl)
                                .rotationEffect(.degrees(180))
                            Text(history.output.amount.formatNumber(suffix: history.output.currency, roundingOffset: history.output.decimals, font: .labelSmallSecondary, fontColor: .colorBaseTent))
                            Text("\(abs(history.percent).formatSNumber(maximumFractionDigits: 2))%")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorInteractiveToneHighlight)
                                .layoutPriority(9)
                            Spacer(minLength: 0)
                            Image(.icArrowUp)
                                .fixSize(.xl)
                                .onTapGesture {
                                    history.batchedTxId.viewTransaction()
                                }
                        }
                        .frame(height: 36)
                    }
                }
            }
        }
    }
    
    //TODO: cuongnv cancel sau
    private func cancelOrder() async throws {
        /*
        guard let order = order else { return }
        let txId = order.order?.txIn.txId ?? ""
        let txIndex = order.order?.txIn.txIndex ?? 0
        let info = try await MinWalletService.shared.fetch(query: GetScriptUtxosQuery(txIns: [txId + "#\(txIndex)"]))
        let input: InputCancelBulkOrders = InputCancelBulkOrders(
            changeAddress: userInfo.minWallet?.address ?? "",
            orders: [InputCancelOrder(rawDatum: info?.getScriptUtxos?.first?.rawDatum ?? "", utxo: info?.getScriptUtxos?.first?.rawUtxo ?? "")],
            publicKey: UserInfo.shared.minWallet?.publicKey ?? "",
            type: order.order?.type.value == .dex ? .case(.orderV1) : .case(.orderV2AndStableswap))
        let _ = try await MinWalletService.shared.mutation(mutation: CancelBulkOrdersMutation(input: input))
        
        let orderV2Input = OrderV2Input(address: userInfo.minWallet?.address ?? "", txId: .some(order.order?.txIn.txId ?? ""))
        let orderData = try? await MinWalletService.shared.fetch(query: OrderHistoryQuery(ordersInput2: orderV2Input))
        guard let order = (orderData?.orders.orders.map({ OrderHistoryQuery.Data.Orders.WrapOrder(order: $0) }) ?? []).first else { return }
        self.order = order
         */
    }
    
    private func authenticationSuccess() {
        Task {
            do {
                hud.showLoading(true)
                try await cancelOrder()
                onReloadOrder?()
                hud.showLoading(false)
            } catch {
                hud.showLoading(false)
                bannerState.showBannerError(error.localizedDescription)
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
