import SwiftUI

struct CurrencyView: View {
    @Binding var isShowCurrency: Bool
    
    @EnvironmentObject
    var appSetting: AppSetting
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            VStack(spacing: 0) {
                Color.colorBorderPrimaryDefault.frame(width: 36, height: 4)
                    .padding(.vertical, .md)
                Text("Currency")
                    .font(.titleH5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 60)
                HStack(spacing: 16) {
                    Text("USD")
                        .font(.paragraphSmall)
                        .foregroundStyle(appSetting.currency == Currency.usd.rawValue ? .colorInteractiveToneHighlight : .colorBaseTent)
                    Spacer()
                    Image(.icChecked)
                        .opacity(appSetting.currency == Currency.usd.rawValue ? 1 : 0)
                }
                .frame(height: 52)
                .onTapGesture {
                    appSetting.currency = Currency.usd.rawValue
                }
                HStack(spacing: 16) {
                    Text("ADA")
                        .font(.paragraphSmall)
                        .foregroundStyle(appSetting.currency == Currency.ada.rawValue ? .colorInteractiveToneHighlight : .colorBaseTent)
                    Spacer()
                    Image(.icChecked)
                        .opacity(appSetting.currency == Currency.ada.rawValue ? 1 : 0)
                }
                .frame(height: 52)
                .padding(.bottom, .xl)
                .onTapGesture {
                    appSetting.currency = Currency.ada.rawValue
                }
            }
            .padding(.horizontal, .xl)
            .background(content: {
                RoundedRectangle(cornerRadius: 24).fill(Color.colorBaseBackground)
            })
            Button(action: {
                isShowCurrency = false
            }, label: {
                Text("Close")
                    .font(.labelMediumSecondary)
                    .foregroundStyle(.colorInteractiveTentSecondaryDefault)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 24).fill(Color.colorBaseBackground)
                    })
            })
            .frame(height: 56)
            .buttonStyle(.plain)
            .padding(.bottom, .xl)
        }
    }
}

#Preview {
    VStack {
        CurrencyView(isShowCurrency: Binding<Bool>.constant(false))
        Spacer()
    }
    .background(Color.black)
}
