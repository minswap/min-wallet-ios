import SwiftUI

struct LanguageView: View {
    @EnvironmentObject
    var appSetting: AppSetting

    var body: some View {
        VStack(spacing: 8) {
            VStack(spacing: 0) {
                Color.colorBorderPrimaryDefault.frame(width: 36, height: 4)
                    .padding(.vertical, .md)
                Text("Language")
                    .font(.titleH5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 60)
                    .padding(.horizontal, .xl)
                ScrollView {
                    VStack {
                        ForEach(Language.allCases) { language in
                            HStack(spacing: 16) {
                                Text(language.title)
                                    .font(.labelSmallSecondary)
                                    .foregroundStyle(language.rawValue == appSetting.language ? .colorInteractiveToneHighlight : .colorBaseTent)
                                Spacer()
                                Image(.icChecked)
                                    .opacity(language.rawValue == appSetting.language ? 1 : 0)
                            }
                            .frame(height: 52)
                            .padding(.horizontal, .xl)
                            .contentShape(.rect)
                            .onTapGesture {
                                appSetting.language = language.rawValue
                            }
                        }
                    }
                }
            }
            .background(Color.colorBaseBackground)
        }
    }
}

#Preview {
    VStack {
        LanguageView()
            .environmentObject(AppSetting.shared)
    }
}
