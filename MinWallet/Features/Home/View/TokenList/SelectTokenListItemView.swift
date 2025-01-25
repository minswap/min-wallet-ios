import SwiftUI


struct SelectTokenListItemView: View {
    private let token: TokenProtocol?
    @Binding
    private var isSelected: Bool
    
    init(token: TokenProtocol?, isSelected: Binding<Bool>) {
        self.token = token
        self._isSelected = isSelected
    }
    
    var body: some View {
        HStack(spacing: .md) {
            TokenLogoView(currencySymbol: token?.currencySymbol, tokenName: token?.tokenName, isVerified: token?.isVerified)
            let adaName = token?.adaName
            let name = token?.name ?? ""
            let amount = token?.amount ?? 0
            VStack(alignment: .leading, spacing: 4) {
                Text(adaName)
                    .font(.labelMediumSecondary)
                    .foregroundStyle(.colorBaseTent)
                    .layoutPriority(1000)
                Text(name.isBlank ? adaName : name)
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
                    .lineLimit(1)
                    .padding(.trailing, .md)
                    .layoutPriority(998)
            }
            .padding(.vertical, 14)
            Spacer(minLength: 0)
            Text(amount.formatNumber())
                .font(.labelMediumSecondary)
                .foregroundStyle(.colorBaseTent)
                .minimumScaleFactor(0.5)
                .layoutPriority(999)
            Image(isSelected ? .icChecked : .icUnchecked)
                .fixSize(20)
                .padding(.leading, 4)
        }
        .overlay(
            Rectangle().frame(height: 1).foregroundColor(.colorBorderItem), alignment: .bottom
        )
        .padding(.horizontal, 16)
    }
}

#Preview {
    SelectTokenListItemView(token: TokenManager.shared.tokenAda, isSelected: .constant(true))
        .environmentObject(AppSetting.shared)
}
