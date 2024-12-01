import SwiftUI
import FlowStacks


struct SettingView: View {
    @State var isVerified: Bool = true
    @StateObject private var viewModel = SettingViewModel()
    
    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    var appSetting: AppSetting
    
    @Binding
    var isShowAppearance: Bool
    @Binding
    var isShowTimeZone: Bool
    @Binding
    var isShowCurrency: Bool
    
    private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                ZStack {
                    Image(.icAvatarDefault)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .clipShape(Circle())
                    
                    if isVerified {
                        Circle()
                            .fill(.colorBackground)
                            .frame(width: 16, height: 16)
                            .overlay(
                                Image(.icVerifiedBadge)
                                    .resizable()
                                    .frame(width: 12, height: 12)
                            )
                            .overlay(
                                Circle()
                                    .stroke(.color0019474FFFFFF4, lineWidth: 1)
                            )
                            .position(x: 54, y: 54)
                    }
                }
                .frame(width: 64, height: 64)
                Spacer()
                Image(.icSettingDarkMode)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .onTapGesture {
                        isShowAppearance = true
                    }
            }
            .frame(height: 64)
            .padding(.top, .md)
            .padding(.horizontal, .xl)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("long.nguyen")
                        .font(.labelSemiSecondary)
                        .foregroundStyle(.color3C68CB89AAFF)
                    
                    Text("W01...")
                        .font(.paragraphXMediumSmall)
                        .foregroundStyle(.color3C68CB89AAFF)
                        .padding(.horizontal, .lg)
                        .padding(.vertical, .xs)
                        .background(
                            RoundedRectangle(cornerRadius: BorderRadius.full).fill(.color89AAFF16)
                        )
                        .frame(height: 20)
                }
                Text("Addrasdlfkjasdf12231123".shortenAddress)
                    .font(.paragraphXSmall)
                    .foregroundStyle(.color050B1856FFFFFF48)
            }
            .padding(.horizontal, .xl)
            
            Color.color050B1810FFFFFF10.frame(height: 1)
                .padding(.horizontal, .xl)
            Text("Basic")
                .font(.paragraphXMediumSmall)
                .foregroundStyle(.color050B1856FFFFFF48)
                .padding(.horizontal, .xl)
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Text("Language")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.color050B18FFFFFF78)
                    Spacer()
                    Text((Language(rawValue: appSetting.language) ?? .english).title)
                        .font(.paragraphSmall)
                        .foregroundStyle(.color050B1856FFFFFF48)
                    Image(.icNext)
                        .frame(width: 20, height: 20)
                }
                .frame(height: 52)
                .contentShape(.rect)
                .onTapGesture {
                    navigator.presentSheet(.language)
                }
                HStack(spacing: 12) {
                    Text("Currency")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.color050B18FFFFFF78)
                    Spacer()
                    Text("ADA")
                        .font(.paragraphSmall)
                        .foregroundStyle(.color050B1856FFFFFF48)
                    Image(.icNext)
                        .frame(width: 20, height: 20)
                }
                .frame(height: 52)
                .contentShape(.rect)
                .onTapGesture {
                    isShowCurrency = true
                }
                HStack(spacing: 12) {
                    Text("Timezone")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.color050B18FFFFFF78)
                    Spacer()
                    Text(appSetting.timeZone)
                        .font(.paragraphSmall)
                        .foregroundStyle(.color050B1856FFFFFF48)
                    Image(.icNext)
                        .frame(width: 20, height: 20)
                }
                .frame(height: 52)
                .contentShape(.rect)
                .onTapGesture {
                    isShowTimeZone = true
                }
                HStack(spacing: 12) {
                    Text("Audio")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.color050B18FFFFFF78)
                    Spacer()
                    Toggle("", isOn: $appSetting.enableAudio)
                        .toggleStyle(SwitchToggleStyle())
                }
                .frame(height: 52)
                HStack(spacing: 12) {
                    Text("Nofification")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.color050B18FFFFFF78)
                    Spacer()
                    Toggle("", isOn: $appSetting.enableNotification)
                        .toggleStyle(SwitchToggleStyle())
                        .onChange(of: appSetting.enableNotification) { newValue in
                            Task {
                                if newValue {
                                    let center  = UNUserNotificationCenter.current()
                                    do {
                                        let granted = try await center.requestAuthorization(options: [.sound, .alert, .badge])
                                        if !granted {
                                            //TODO: cuongnv show dialog go to setting permission
                                            guard let settingsURL = URL(string: UIApplication.openNotificationSettingsURLString) else {
                                                return
                                            }
                                            if UIApplication.shared.canOpenURL(settingsURL) {
                                                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                                            }
                                        }
                                        appSetting.enableNotification = granted
                                    } catch { error
                                        appSetting.enableNotification = false
                                    }
                                }
                            }
                        }
                }
                .frame(height: 52)
                HStack(spacing: 12) {
                    Text("Face ID/Finger Print")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.color050B18FFFFFF78)
                    Spacer()
                    Toggle("", isOn: $appSetting.enableBiometric)
                        .toggleStyle(SwitchToggleStyle())
                        .onChange(of: appSetting.enableBiometric) { newValue in
                            if newValue {
                                Task {
                                    do {
                                        try await appSetting.biometricAuthentication.authenticateUser()
                                    } catch { error
                                        //TODO: cuongnv show error
                                        appSetting.enableBiometric = false
                                    }
                                }
                            }
                        }
                }
                .frame(height: 52)
            }
            .padding(.horizontal, .xl)
            Spacer()
            Color.color050B1810FFFFFF10.frame(height: 1)
                .padding(.horizontal, .xl)
            HStack(spacing: 12) {
                Image(.icSplash)
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("About Minwallet")
                    .font(.labelSmallSecondary)
                    .foregroundStyle(.color050B18FFFFFF78)
                Spacer()
                Text("v\(appVersion ?? "")")
                    .font(.paragraphSmall)
                    .foregroundStyle(.color050B1856FFFFFF48)
                Image(.icNext)
                    .frame(width: 20, height: 20)
            }
            .frame(height: 36)
            .padding(.horizontal, .xl)
            .padding(.bottom, .md)
            .contentShape(.rect)
            .onTapGesture {
                navigator.push(.about)
            }
        }
        .background(Color.colorBackground)
    }
}

#Preview {
    VStack {
        SettingView(isShowAppearance: .constant(false), isShowTimeZone: .constant(false), isShowCurrency: .constant(false))
            .environmentObject(AppSetting())
    }
}
