import SwiftUI
import FlowStacks
import MinWalletAPI


struct OrderHistoryFilterView: View {
    @Binding
    var isShowFilterView: Bool
    @State
    var contractTypeSelected: ContractType?
    @State
    var statusSelected: OrderV2Status?
    @State
    var actionSelected: OrderV2Action?
    @State
    var fromDate: Date = .init()
    @State
    var toDate: Date = .init()
    @State
    private var showSelectFromDate: Bool = false
    @State
    private var showSelectToDate: Bool = false

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        return formatter
    }()

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
                        TextSelectable(content: "All", selected: $contractTypeSelected, value: nil)
                            .onTapGesture {
                                contractTypeSelected = nil
                            }
                        ForEach(ContractType.allCases) { type in
                            TextSelectable(content: type.title, selected: $contractTypeSelected, value: type)
                                .onTapGesture {
                                    contractTypeSelected = type
                                }
                        }
                        Spacer()
                    }
                    Color.colorBorderPrimarySub.frame(height: 1).padding(.vertical, .xl)
                    Text("Action")
                        .font(.labelSmallSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, .md)
                    let actions: [String] = ["All"] + OrderV2Action.allCases.map({ $0.rawValue })
                    FlowLayout(
                        mode: .scrollable,
                        items: actions
                    ) { action in
                        let action = OrderV2Action(rawValue: action)
                        TextSelectable(content: action?.title ?? "All", selected: $actionSelected, value: action ?? nil)
                            .onTapGesture {
                                actionSelected = action
                            }
                    }
                    .padding(.bottom, .xl)
                    Text("Status")
                        .font(.labelSmallSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, .md)
                    HStack(spacing: 8) {
                        TextSelectable(content: "All", selected: $statusSelected, value: nil)
                            .onTapGesture {
                                statusSelected = nil
                            }
                        ForEach(OrderV2Status.allCases) { type in
                            TextSelectable(content: type.title, selected: $statusSelected, value: type)
                                .onTapGesture {
                                    statusSelected = type
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
                    Text(fromDate, formatter: dateFormatter)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .overlay(
                            RoundedRectangle(cornerRadius: BorderRadius.full)
                                .stroke(showSelectFromDate ? .colorBorderPrimaryPressed : .colorBorderPrimaryDefault, lineWidth: showSelectFromDate ? 2 : 1)
                        )
                        .onTapGesture {
                            withAnimation {
                                guard !showSelectFromDate else {
                                    showSelectToDate = false
                                    showSelectFromDate = false
                                    return
                                }
                                showSelectToDate = false
                                showSelectFromDate = true
                            }
                        }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("To")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(toDate, formatter: dateFormatter)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .overlay(
                            RoundedRectangle(cornerRadius: BorderRadius.full)
                                .stroke(showSelectToDate ? .colorBorderPrimaryPressed : .colorBorderPrimaryDefault, lineWidth: showSelectToDate ? 2 : 1)
                        )
                        .onTapGesture {
                            withAnimation {
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
            }
            .padding(.top, (showSelectToDate || showSelectFromDate) ? .lg : 0)
            if !showSelectToDate && !showSelectFromDate {
                Color.colorBorderPrimarySub.frame(height: 1).padding(.vertical, .xl)
            }
            if showSelectFromDate || showSelectToDate {
                ZStack {
                    if showSelectFromDate {
                        DatePicker(
                            " ",
                            selection: $fromDate,
                            in: toDate.adding(.year, value: -20)!...toDate,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.wheel)
                    }
                    if showSelectToDate {
                        DatePicker(
                            " ",
                            selection: $toDate,
                            in: fromDate...fromDate.adding(.year, value: 20)!,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.wheel)
                    }
                }
            }

            HStack(spacing: .xl) {
                CustomButton(title: "Reset", variant: .secondary) {
                    isShowFilterView = false
                }
                .frame(height: 56)
                CustomButton(title: "Apply") {
                    if showSelectToDate || showSelectFromDate {
                        withAnimation {
                            showSelectToDate = false
                            showSelectFromDate = false
                        }
                        return
                    }
                    isShowFilterView = false
                }
                .frame(height: 56)
            }
            .padding(.vertical, .md)
        }
        .padding(.horizontal, .xl)
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    VStack {
        OrderHistoryFilterView(isShowFilterView: .constant(false))
        Spacer()
    }
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
    }
}
