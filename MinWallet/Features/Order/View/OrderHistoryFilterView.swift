import SwiftUI
import FlowStacks
import MinWalletAPI
import UIKit
import Then
import SwiftyAttributes


struct OrderHistoryFilterView: View {
    @EnvironmentObject
    private var appSetting: AppSetting
    @State
    var contractTypeSelected: ContractType?
    @State
    var statusSelected: OrderV2Status?
    @State
    var actionSelected: OrderV2Action?
    @State
    var fromDate: Date?
    @State
    var toDate: Date?
    @State
    private var showSelectFromDate: Bool = false
    @State
    private var showSelectToDate: Bool = false

    @Environment(\.partialSheetDismiss)
    var onDismiss
    @Environment(\.enableDragGesture)
    var enableDragGesture
    
    var onFilterSelected: ((ContractType?, OrderV2Status?, OrderV2Action?, Date?, Date?) -> Void)?

    private func formateDate(_ date: Date?) -> String {
        guard let date = date else { return "Select date"}
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        if AppSetting.shared.timeZone == AppSetting.TimeZone.utc.rawValue {
            formatter.timeZone = .gmt
            formatter.locale = Locale(identifier: "en_US_POSIX")
        }
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Filter")
                .font(.titleH5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 60)
            if !showSelectToDate && !showSelectFromDate {
                VStack(spacing: 0) {
                    Text("Contract")
                        .font(.labelSmallSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, .md)
                    HStack(spacing: 8) {
                        let contractTypes: [ContractType] = [.dex, .dexV2, .stableswap]
                        TextSelectable(content: "All", selected: $contractTypeSelected, value: nil)
                            .onTapGesture {
                                contractTypeSelected = nil
                            }
                        ForEach(0..<contractTypes.count, id: \.self) { index in
                            if let type = contractTypes[gk_safeIndex: index] {
                                TextSelectable(content: type.title, selected: $contractTypeSelected, value: type)
                                    .onTapGesture {
                                        contractTypeSelected = type
                                    }
                            }
                        }
                        Spacer()
                    }
                    Color.colorBorderPrimarySub.frame(height: 1).padding(.vertical, .xl)
                    Text("Action")
                        .font(.labelSmallSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, .md)
                    let rawAction: [OrderV2Action] = [.market, .limit, .zapIn, .zapOut, .deposit, .withdraw, .oco, .stopLoss, .partialSwap]
                    let allKey: LocalizedStringKey = "All"
                    let actions: [String] = ([allKey] + rawAction.map({ $0.titleFilter })).map { $0.toString() }

                    let height = calculateHeightFlowLayout(actions: actions)
                    FlowLayout(
                        mode: .vstack,
                        items: actions,
                        itemSpacing: 0
                    ) { title in
                        let action = OrderV2Action(title: title)
                        let isActionAll = title == allKey.toString()
                        let content: LocalizedStringKey? = isActionAll ? allKey : action?.titleFilter
                        TextSelectable(
                            content: content ?? allKey,
                            selected: $actionSelected,
                            value: isActionAll ? nil : action
                        )
                        .onTapGesture {
                            actionSelected = title == allKey.toString() ? nil : action
                        }
                    }
                    .frame(height: height)
                    .padding(.bottom, .md)
                    Text("Status")
                        .font(.labelSmallSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, .md)
                    HStack(spacing: 8) {
                        TextSelectable(content: "All", selected: $statusSelected, value: nil)
                            .onTapGesture {
                                statusSelected = nil
                            }
                        let orderV2Statuses = OrderV2Status.allCases
                        ForEach(0..<orderV2Statuses.count, id: \.self) { index in
                            if let type = orderV2Statuses[gk_safeIndex: index] {
                                TextSelectable(content: type.title, selected: $statusSelected, value: type)
                                    .onTapGesture {
                                        statusSelected = type
                                    }
                            }
                        }
                        Spacer()
                    }

                    Color.colorBorderPrimarySub.frame(height: 1).padding(.vertical, .xl)
                }
                .padding(.top, .lg)
            }
            HStack(spacing: .xl) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("From")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(formateDate(fromDate))
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorBaseTent)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .overlay(
                            RoundedRectangle(cornerRadius: BorderRadius.full)
                                .stroke(showSelectFromDate ? .colorBorderPrimaryPressed : .colorBorderPrimaryDefault, lineWidth: showSelectFromDate ? 2 : 1)
                        )
                        .onTapGesture {
                            guard !showSelectFromDate else {
                                showSelectToDate = false
                                showSelectFromDate = false
                                return
                            }
                            showSelectToDate = false
                            showSelectFromDate = true
                        }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("To")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(formateDate(toDate))
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorBaseTent)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .overlay(
                            RoundedRectangle(cornerRadius: BorderRadius.full)
                                .stroke(showSelectToDate ? .colorBorderPrimaryPressed : .colorBorderPrimaryDefault, lineWidth: showSelectToDate ? 2 : 1)
                        )
                        .onTapGesture {
                            guard !showSelectToDate else {
                                showSelectToDate = false
                                showSelectFromDate = false
                                return
                            }
                            showSelectToDate = true
                            showSelectFromDate = false
                        }
                }
            }
            .padding(.top, (showSelectToDate || showSelectFromDate) ? .lg : 0)
            if !showSelectToDate && !showSelectFromDate {
                Color.clear.frame(height: 1).padding(.vertical, .xl)
            }
            if showSelectFromDate || showSelectToDate {
                let timeZone: TimeZone = appSetting.timeZone == AppSetting.TimeZone.utc.rawValue ? .gmt : .current
                VStack(alignment: .center) {
                    if showSelectFromDate {
                        let fromDateBinding = Binding<Date>(
                            get: { fromDate ?? Date() },
                            set: { newValue in
                                fromDate = newValue
                            }
                        )
                        DatePicker(
                            " ",
                            selection: fromDateBinding,
                            in: (toDate ?? Date()).adding(.year, value: -20)!...(toDate ?? Date()),
                            displayedComponents: [.date]
                        )
                        .labelsHidden()
                        .datePickerStyle(.wheel)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        .environment(\.timeZone, timeZone)
                        .id(fromDate)
                    }
                    if showSelectToDate {
                        let toDateBinding = Binding<Date>(
                            get: { toDate ?? Date() },
                            set: { newValue in
                                toDate = newValue
                            }
                        )
                        DatePicker(
                            " ",
                            selection: toDateBinding,
                            in: (fromDate ?? Date())...(fromDate ?? Date()).adding(.year, value: 20)!,
                            displayedComponents: [.date]
                        )
                        .labelsHidden()
                        .datePickerStyle(.wheel)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        .environment(\.timeZone, timeZone)
                        .id(toDate)
                    }
                }
            }

            HStack(spacing: .xl) {
                CustomButton(title: "Reset", variant: .secondary) {
                    onDismiss?()
                    onFilterSelected?(nil, nil, nil, nil, nil)

                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1200)) {
                        self.showSelectToDate = false
                        self.showSelectFromDate = false
                        self.contractTypeSelected = nil
                        self.statusSelected = nil
                        self.actionSelected = nil
                        self.fromDate = nil
                        self.toDate = nil
                    }
                }
                .frame(height: 56)
                CustomButton(title: "Apply") {
                    if showSelectToDate || showSelectFromDate {
                        showSelectToDate = false
                        showSelectFromDate = false
                        return
                    }
                    onDismiss?()
                    fromDate = fromDate?.startOfDay
                    toDate = toDate?.endOfDay
                    //print("WTF \(fromDate) \(fromDate?.startOfDay) \(fromDate?.startOfDay.timeIntervalSince1970)")
                    //print("WTF \(toDate?.endOfDay) \(toDate?.endOfDay.timeIntervalSince1970)")
                    onFilterSelected?(contractTypeSelected, statusSelected, actionSelected, fromDate, toDate)
                }
                .frame(height: 56)
            }
            .padding(.vertical, .md)
        }
        .padding(.horizontal, .xl)
        .presentSheetModifier()
        .onAppear {
            enableDragGesture?(false)
        }
    }
}

#Preview {
    VStack {
        OrderHistoryFilterView()
        Spacer()
    }
    .environmentObject(AppSetting.shared)
}

private struct TextSelectable<T: Equatable>: View {
    @State var content: LocalizedStringKey = "All"
    @Binding var selected: T?
    @State var value: T?

    var body: some View {
        Text(content)
            .font(.labelSmallSecondary)
            .foregroundStyle(value == selected ? .colorInteractiveToneTent : .colorInteractiveTentPrimarySub)
            .padding(.horizontal, .lg)
            .padding(.vertical, 6)
            .frame(height: 32)
            .background(value == selected ? .colorInteractiveToneHighlight : .clear)
            .overlay(RoundedRectangle(cornerRadius: BorderRadius.full).stroke(value == selected ? .clear : .colorBorderPrimarySub, lineWidth: 1))
            .cornerRadius(BorderRadius.full)
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .contentShape(.rect)
            .padding(.trailing, .md)
            .padding(.bottom, .md)
    }
}

extension OrderHistoryFilterView {
    private func calculateHeightFlowLayout(actions: [String]) -> CGFloat {
        let actionsWidths = actions.map { action in
            NSMutableAttributedString()
                .then {
                    $0.append(
                        action
                            .withAttributes([
                                .font(.labelSmallSecondary ?? .systemFont(ofSize: 14, weight: .medium))
                            ]))
                }
                .gkWidth(consideringHeight: 32) + .lg * 2 + .md + 1
        }
        let maxWidth: CGFloat = UIScreen.main.bounds.width - .xl * 2 - 1
        var currentWidth: CGFloat = 0
        var row: CGFloat = 1
        for width in actionsWidths {
            if currentWidth + width <= maxWidth {
                currentWidth += width
            } else {
                row += 1
                currentWidth = width
            }
        }
        return row * 32 + row * .md
    }
}
