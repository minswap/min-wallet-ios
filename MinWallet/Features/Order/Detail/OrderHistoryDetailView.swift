import SwiftUI
import FlowStacks
import MinWalletAPI


struct OrderHistoryDetailView: View {
    @EnvironmentObject
    private var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    let colors: [Color] = [.red, .blue, .purple]

    @State
    var order: OrderHistoryQuery.Data.Orders.WrapOrder?
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    tokenView
                        .padding(.horizontal, .xl)
                        .padding(.top, .lg)
                    Text("ADA - MIN")
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
                    if order?.order?.status.value == .created {
                        HStack(spacing: Spacing.md) {
                            Image(.icWarningYellow)
                                .resizable()
                                .frame(width: 16, height: 16)
                            Text("Although this order has been labeled as \"Expired,\" in order to completely cancel the order, you should click on \"Cancel.\" You have the option to update the order as well by clicking “Update.”")
                                .font(.paragraphXSmall)
                                .foregroundStyle(.colorInteractiveToneWarning)
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
                ForEach(0..<colors.count) { i in
                    TokenLogoView()
                        .frame(width: 24, height: 24)
                }
            }
            Image(.icBack)
                .resizable()
                .rotationEffect(.degrees(180))
                .frame(width: 16, height: 16)
                .padding(.horizontal, 2)
            HStack(spacing: -4) {
                ForEach(0..<colors.count) { i in
                    TokenLogoView()
                        .frame(width: 24, height: 24)
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
                HStack {
                    Text("You paid")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    Text("20 MINv2LP")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                .padding(.vertical, .md)
                .padding(.top, .md)
                HStack {
                    Text("Deposit ADA")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    Text("2")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                .padding(.vertical, .md)
                HStack {
                    Text("Estimated batcher fee")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    Text("2")
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
                            //let link = order?.txIn.txId
                        }
                    Image(.icArrowUp)
                        .fixSize(.xl)
                        .onTapGesture {
                            //let link = order?.txIn.txId
                            
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
                HStack {
                    Text("Minimum receive")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    Text("318.362341 MIN")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                .padding(.vertical, .md)
                .padding(.top, .md)
                HStack {
                    Text("Trading fee")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    Text("0.042448 ADA")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                .padding(.vertical, .md)
                HStack {
                    Text("Executed batcher fee")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    Text("2 ₳")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                .padding(.vertical, .md)
                HStack(spacing: 4) {
                    Text("Route")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    Text("ADA > MIN")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                }
                .padding(.top, .md)
                .padding(.bottom, .xl)
            }
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
                HStack {
                    Text("You receive")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    Text("318.362341 MIN")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseSuccess)
                }
                .padding(.vertical, .md)
                .padding(.top, .md)
                HStack(spacing: 4) {
                    Text("Executed price")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    Text("1 ADA = 22.612 MIN")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                    Image(.icExecutePrice)
                        .fixSize(.xl)
                }
                .padding(.vertical, .md)
                HStack {
                    Text("Deposit ADA")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Spacer()
                    Text("2 ₳")
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
                            let link = order?.order?.updatedTxId
                        }
                    Image(.icArrowUp)
                        .fixSize(.xl)
                        .onTapGesture {
                            let link = order?.order?.updatedTxId
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
