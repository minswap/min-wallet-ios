import SwiftUI

struct AppearanceView: View {
    @EnvironmentObject
    var appSetting: AppSetting
    @Environment(\.partialSheetDismiss)
    var onDismiss

    var body: some View {
        VStack(spacing: 8) {
            VStack(spacing: 0) {
                Color.colorBorderPrimaryDefault.frame(width: 36, height: 4)
                    .padding(.vertical, .md)
                Text("Appearance")
                    .font(.titleH5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 60)
                    .padding(.horizontal, .xl)
                HStack(spacing: 0) {
                    VStack(spacing: 10) {
                        Image(.icAppearanceDefault)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.colorInteractiveToneHighlight, lineWidth: appSetting.appearance == .system ? 2 : 0))
                        HStack(spacing: 4) {
                            Image(appSetting.appearance == .system ? .icRadioCheck : .icRadioUncheck)
                            Text("Default")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorBaseTent)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(.rect)
                    .onTapGesture {
                        appSetting.applyAppearanceStyle(.system)
                    }
                    Spacer()
                    VStack(spacing: 10) {
                        Image(.icAppearanceDark)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.colorInteractiveToneHighlight, lineWidth: appSetting.appearance == .dark ? 2 : 0))
                        HStack(spacing: 4) {
                            Image(appSetting.appearance == .dark ? .icRadioCheck : .icRadioUncheck)
                            Text("Dark")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorBaseTent)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(.rect)
                    .onTapGesture {
                        appSetting.applyAppearanceStyle(.dark)
                    }
                    Spacer()
                    VStack(spacing: 10) {
                        Image(.icAppearanceLight)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.colorInteractiveToneHighlight, lineWidth: appSetting.appearance == .light ? 2 : 0))
                        HStack(spacing: 4) {
                            Image(appSetting.appearance == .light ? .icRadioCheck : .icRadioUncheck)
                            Text("Light")
                                .font(.paragraphSmall)
                                .foregroundStyle(.colorBaseTent)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(.rect)
                    .onTapGesture {
                        appSetting.applyAppearanceStyle(.light)
                    }
                }
                .padding(.horizontal, .xl)
                Text("When you set the appearance to default, theme app will be depended on device settings.")
                    .font(.paragraphXSmall)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, .xl)
                    .padding(.horizontal, .xl)
            }
            .background(content: {
                RoundedRectangle(cornerRadius: 24).fill(Color.colorBaseBackground)
            })
            Button(
                action: {
                    onDismiss?()
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
        }
        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/ true /*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    VStack {
        AppearanceView()
            .environmentObject(AppSetting.shared)
        Spacer()
    }
    .background(Color.black)
}
