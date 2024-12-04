import SwiftUI

struct TimeZoneView: View {
    @Binding var isShowTimeZone: Bool

    @EnvironmentObject
    var appSetting: AppSetting

    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            VStack(spacing: 0) {
                Color.colorBorderPrimaryDefault.frame(width: 36, height: 4)
                    .padding(.vertical, .md)
                Text("Timezone")
                    .font(.titleH5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 60)
                HStack(spacing: 16) {
                    Text("Local")
                        .font(.paragraphSmall)
                        .foregroundStyle(appSetting.timeZone == TimeZone.local.rawValue ? .colorInteractiveToneHighlight : .colorBaseTent)
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
                        .foregroundStyle(appSetting.timeZone == TimeZone.utc.rawValue ? .colorInteractiveToneHighlight : .colorBaseTent)
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
                RoundedRectangle(cornerRadius: 24).fill(Color.colorBaseBackground)
            })
            Button(
                action: {
                    isShowTimeZone = false
                },
                label: {
                    Text("Close")
                        .font(.labelMediumSecondary)
                        .foregroundStyle(.colorInteractiveTentSecondaryDefault)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 24).fill(Color.colorBaseBackground)
                        })
                }
            )
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
