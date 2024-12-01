import SwiftUI

struct LanguageView: View {
    @EnvironmentObject
    var appSetting: AppSetting
    
    var body: some View {
        VStack(spacing: 8) {
            VStack(spacing: 0) {
                Color.color050B1816FFFFFF16.frame(width: 36, height: 4)
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
                                    .foregroundStyle(language.rawValue == appSetting.language ? .color3C68CB89AAFF : .color050B18FFFFFF)
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
            .background(Color.colorBackground)
        }
    }
}

#Preview {
    VStack {
        LanguageView()
            .environmentObject(AppSetting())
    }
}
