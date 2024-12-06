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
                            .fill(.colorBaseBackground)
                            .frame(width: 16, height: 16)
                            .overlay(
                                Image(.icVerifiedBadge)
                                    .resizable()
                                    .frame(width: 12, height: 12)
                            )
                            .overlay(
                                Circle()
                                    .stroke(.colorSurfacePrimarySub, lineWidth: 1)
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
                        .foregroundStyle(.colorInteractiveToneHighlight)

                    Text("W01...")
                        .font(.paragraphXMediumSmall)
                        .foregroundStyle(.colorInteractiveToneHighlight)
                        .padding(.horizontal, .lg)
                        .padding(.vertical, .xs)
                        .background(
                            RoundedRectangle(cornerRadius: BorderRadius.full).fill(.colorSurfaceHighlightDefault)
                        )
                        .frame(height: 20)
                }
                Text("Addrasdlfkjasdf12231123".shortenAddress)
                    .font(.paragraphXSmall)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
            }
            .padding(.horizontal, .xl)

            Color.colorBorderPrimarySub.frame(height: 1)
                .padding(.horizontal, .xl)
            Text("Basic")
                .font(.paragraphXMediumSmall)
                .foregroundStyle(.colorInteractiveTentPrimarySub)
                .padding(.horizontal, .xl)
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Text("Language")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                    Spacer()
                    Text((Language(rawValue: appSetting.language) ?? .english).title)
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
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
                        .foregroundStyle(.colorBaseTent)
                    Spacer()
                    Text("ADA")
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
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
                        .foregroundStyle(.colorBaseTent)
                    Spacer()
                    Text(appSetting.timeZone)
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
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
                        .foregroundStyle(.colorBaseTent)
                    Spacer()
                    Toggle("", isOn: $appSetting.enableAudio)
                        .toggleStyle(SwitchToggleStyle())
                }
                .frame(height: 52)
                HStack(spacing: 12) {
                    Text("Nofification")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                    Spacer()
                    Toggle("", isOn: $appSetting.enableNotification)
                        .toggleStyle(SwitchToggleStyle())
                        .onChange(of: appSetting.enableNotification) { newValue in
                            Task {
                                if newValue {
                                    let center = UNUserNotificationCenter.current()
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
                                    } catch {
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
                        .foregroundStyle(.colorBaseTent)
                    Spacer()
                    Toggle("", isOn: $appSetting.enableBiometric)
                        .toggleStyle(SwitchToggleStyle())
                        .onChange(of: appSetting.enableBiometric) { newValue in
                            if newValue {
                                Task {
                                    do {
                                        try await appSetting.biometricAuthentication.authenticateUser()
                                    } catch {
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
            Color.colorBorderPrimarySub.frame(height: 1)
                .padding(.horizontal, .xl)
            HStack(spacing: 12) {
                Image(.icSplash)
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("About Minwallet")
                    .font(.labelSmallSecondary)
                    .foregroundStyle(.colorBaseTent)
                Spacer()
                Text("v\(appVersion ?? "")")
                    .font(.paragraphSmall)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
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
        .background(Color.colorBaseBackground)
    }
}

#Preview {
    VStack {
        SettingView(isShowAppearance: .constant(false), isShowTimeZone: .constant(false), isShowCurrency: .constant(false))
            .environmentObject(AppSetting())
    }
}
