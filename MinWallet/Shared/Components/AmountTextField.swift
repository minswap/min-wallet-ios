import SwiftUI


struct AmountTextField: View {
    @Binding var value: String
    @State var minValue: Double = 0
    @State var maxValue: Double?
    @State var fontPlaceHolder: Font = .paragraphSmall

    var body: some View {
        TextField("", text: $value)
            .keyboardType(.decimalPad)
            .placeholder("0.0", font: fontPlaceHolder, when: value.isEmpty)
            .lineLimit(1)
            .onChange(of: value) { newValue in
                let filtered = newValue.replacingOccurrences(of: ",", with: ".").filter { "0123456789.".contains($0) }
                if filtered.contains(".") {
                    let splitted = filtered.split(separator: ".", omittingEmptySubsequences: false)
                    if splitted.count >= 2 {
                        let preDecimal = String(splitted[0])
                        let afterDecimal = String(splitted[1])
                        value = "\(preDecimal).\(afterDecimal)"
                    }
                } else {
                    value = filtered
                }

                let currentValue = Decimal(string: value) ?? 0
                if !value.isBlank && currentValue < Decimal(minValue) && currentValue > 0 {
                    value = minValue.formatSNumber(usesGroupingSeparator: false, maximumFractionDigits: 15)
                } else if let maxValue = maxValue, currentValue > Decimal(maxValue) {
                    value = maxValue.formatSNumber(usesGroupingSeparator: false, maximumFractionDigits: 15)
                }
            }
    }
}
