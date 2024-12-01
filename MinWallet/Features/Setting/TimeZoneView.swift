import SwiftUI

struct TimeZoneView: View {
    @Binding var isShowTimeZone: Bool
    
    @EnvironmentObject
    var appSetting: AppSetting
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            VStack(spacing: 0) {
                Color.color050B1816FFFFFF16.frame(width: 36, height: 4)
                    .padding(.vertical, .md)
                Text("Timezone")
                    .font(.titleH5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 60)
                HStack(spacing: 16) {
                    Text("Local")
                        .font(.paragraphSmall)
                        .foregroundStyle(appSetting.timeZone == TimeZone.local.rawValue ? .color3C68CB89AAFF : .color050B18FFFFFF)
                    Spacer()
                    Image(.icChecked)
                        .opacity(appSetting.timeZone == TimeZone.local.rawValue ? 1 : 0)
                }
                .frame(height: 52)
                .contentShape(.rect)
                .onTapGesture {
                    appSetting.timeZone = TimeZone.local.rawValue
                }
                HStack(spacing: 16) {
                    Text("UTC")
                        .font(.paragraphSmall)
                        .foregroundStyle(appSetting.timeZone == TimeZone.utc.rawValue ? .color3C68CB89AAFF : .color050B18FFFFFF)
                    Spacer()
                    Image(.icChecked)
                        .opacity(appSetting.timeZone == TimeZone.utc.rawValue ? 1 : 0)
                }
                .frame(height: 52)
                .padding(.bottom, .xl)
                .contentShape(.rect)
                .onTapGesture {
                    appSetting.timeZone = TimeZone.utc.rawValue
                }
            }
            .padding(.horizontal, .xl)
            .background(content: {
                RoundedRectangle(cornerRadius: 24).fill(Color.colorBackground)
            })
            Button(action: {
                isShowTimeZone = false
            }, label: {
                Text("Close")
                    .font(.labelMediumSecondary)
                    .foregroundStyle(.color001947FFFFFF78)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 24).fill(Color.colorBackground)
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
        TimeZoneView(isShowTimeZone: Binding<Bool>.constant(false))
            .environmentObject(AppSetting())
        Spacer()
    }
    .background(Color.black)
}
