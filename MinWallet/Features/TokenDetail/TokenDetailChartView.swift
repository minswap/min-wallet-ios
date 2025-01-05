import SwiftUI
import Charts

///https://blog.stackademic.com/line-chart-using-swift-charts-swiftui-cd1abeac9e44
enum LineChartType: String, CaseIterable, Plottable {
    case optimal = "Optimal"
    case outside = "Outside range"

    var color: Color {
        switch self {
        case .optimal: return .green
        case .outside: return .red
        }
    }

}

struct LineChartData: Hashable {
    var id = UUID()
    var date: Date
    var value: Double

    var type: LineChartType
}

extension TokenDetailView {
    var tokenDetailChartView: some View {
        VStack(alignment: .leading, spacing: 0) {
            let maxY: Double = (viewModel.chartDatas.map { $0.value }.max() ?? 0) * 1.5
            let minDate: Date = viewModel.chartDatas.map { $0.date }.min() ?? Date()
            let maxDate: Date = viewModel.chartDatas.map { $0.date }.max() ?? Date()
            //            let strideValue = maxY / 6
            Chart {
                ForEach(Array(zip(viewModel.chartDatas, viewModel.chartDatas.indices)), id: \.0) { item, index in
                    if let selectedIndex = viewModel.selectedIndex, selectedIndex == index {
                        RectangleMark(
                            x: .value("Index", index),
                            yStart: .value("Value", 0),
                            yEnd: .value("Value", item.value),
                            width: 2
                        )
                        .opacity(0.4)
                    }
                    LineMark(
                        x: .value("Date", index),
                        y: .value("Value", item.value)
                    )
                    .foregroundStyle(.colorInteractiveToneHighlight)
                    //.interpolationMethod(.catmullRom)
                    .lineStyle(.init(lineWidth: 1))
                }
            }
            //            .chartXAxis {
            //                AxisMarks(preset: .extended, values: .stride(by: .day)) { value in
            //                    AxisValueLabel(format: .dateTime.day())
            //                }
            //            }
            .chartYAxis {
                AxisMarks(preset: .extended, position: .leading)
            }
            .chartYScale(domain: 0...maxY)
            .chartXAxis(.hidden)
            .chartLegend(.hidden)
            .chartOverlay { chart in
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                        .onTapGesture { location in
                            let currentX = location.x - geometry[chart.plotAreaFrame].origin.x
                            guard currentX >= 0, currentX < chart.plotAreaSize.width else {
                                return
                            }

                            guard let index = chart.value(atX: currentX, as: Int.self) else { return }
                            viewModel.selectedIndex = index
                        }
                }
            }
            .frame(height: 200)
            HStack {
                Text(viewModel.formatDate(value: minDate))
                    .font(.paragraphXMediumSmall)
                    .foregroundStyle(.colorInteractiveTentPrimaryDisable)
                Spacer()
                Text(viewModel.formatDate(value: maxDate))
                    .font(.paragraphXMediumSmall)
                    .foregroundStyle(.colorInteractiveTentPrimaryDisable)
            }
            .padding(.top, .md)
            HStack(spacing: 0) {
                ForEach(viewModel.chartPeriods, id: \.self) { period in
                    if viewModel.chartPeriod == period {
                        Text(period.title)
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorInteractiveTentSecondaryDefault)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .shadow(radius: 50).cornerRadius(BorderRadius.full)
                            .background(RoundedRectangle(cornerRadius: BorderRadius.full).fill(.colorBaseBackground))
                            .padding(.vertical, .xs)
                            .contentShape(.rect)
                            .onTapGesture {
                                viewModel.chartPeriod = period
                            }
                    } else {
                        Text(period.title)
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorInteractiveTentSecondaryDefault)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .contentShape(.rect)
                            .onTapGesture {
                                viewModel.chartPeriod = period
                            }
                    }
                }
            }
            .frame(height: 36)
            .background(RoundedRectangle(cornerRadius: BorderRadius.full).fill(.colorSurfacePrimarySub))
            .padding(.top, .xl)
        }
    }
}

extension Date {
    func adding(_ component: Calendar.Component, value: Int, using calendar: Calendar = .current) -> Date? {
        return calendar.date(byAdding: component, value: value, to: self)
    }

    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}


#Preview {
    TokenDetailView(viewModel: TokenDetailViewModel(token: TokenProtocolDefault()))
        .environmentObject(AppSetting.shared)
}
