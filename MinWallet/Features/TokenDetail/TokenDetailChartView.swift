import SwiftUI
import Charts

///https://blog.stackademic.com/line-chart-using-swift-charts-swiftui-cd1abeac9e44
enum LineChartType: String, CaseIterable, Plottable {
    case optimal = "Optimal"
    case outside = "Outside range"
    
    var color: Color {
        switch self {
        case .optimal: return .green
        case .outside: return .blue
        }
    }
    
}

struct LineChartData {
    var id = UUID()
    var date: Date
    var value: Double
    
    var type: LineChartType
}


struct TokenDetailChartView: View {
    
    let data: [LineChartData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Chart {
                ForEach(data, id: \.id) { item in
                    LineMark(
                        x: .value("Weekday", item.date),
                        y: .value("Value", item.value)
                    )
                    .foregroundStyle(by: .value("Plot", item.type))
                    .interpolationMethod(.catmullRom)
                    .lineStyle(.init(lineWidth: 2))
                }
            }
            .chartXAxis {
                AxisMarks(preset: .extended, values: .stride (by: .month)) { value in
                    AxisValueLabel(format: .dateTime.month())
                }
            }
            .chartYAxis {
                AxisMarks(preset: .extended, position: .leading, values: .stride(by: 5))
            }
            .chartLegend(.hidden)
            .frame(height: 240)
            
            HStack(spacing: 0) {
                Text("1D")
                    .font(.labelSmallSecondary)
                    .foregroundStyle(.color001947FFFFFF78)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Text("1W")
                    .font(.labelSmallSecondary)
                    .foregroundStyle(.color001947FFFFFF78)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .shadow(radius: 50).cornerRadius(BorderRadius.full)
                    .background(RoundedRectangle(cornerRadius: BorderRadius.full).fill(.colorFFFFFF111218))
                    .padding(.vertical, .xs)
                Text("1M")
                    .font(.labelSmallSecondary)
                    .foregroundStyle(.color001947FFFFFF78)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Text("1Y")
                    .font(.labelSmallSecondary)
                    .foregroundStyle(.color001947FFFFFF78)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            .frame(height: 36)
            .background(RoundedRectangle(cornerRadius: BorderRadius.full).fill(.color0019474FFFFFF4))
            .padding(.top, 20)
        }
    }
}

var chartData: [LineChartData] = {
    let sampleDate = Date().startOfDay.adding(.month, value: -10)!
    var temp = [LineChartData]()
    
    // Line 1
    for i in 0..<8 {
        let value = Double.random(in: 5...20)
        temp.append(
            LineChartData(
                date: sampleDate.adding(.month, value: i)!,
                value: value,
                type: .outside
            )
        )
    }
    return temp
}()


#Preview {
    VStack {
        TokenDetailChartView(data: chartData)
            .padding(.xl)
        Spacer()
    }
}

extension Date {
    func adding (_ component: Calendar.Component, value: Int, using calendar: Calendar = .current) -> Date? {
        return calendar.date(byAdding: component, value: value, to: self)
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}
