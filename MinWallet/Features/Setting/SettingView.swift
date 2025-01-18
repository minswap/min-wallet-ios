import SwiftUI
import FlowStacks


struct SettingView: View {
    @State var isVerified: Bool = true
    @StateObject private var viewModel = SettingViewModel()

    @EnvironmentObject
    var navigator: FlowNavigator<MainCoordinatorViewModel.Screen>
    @EnvironmentObject
    var appSetting: AppSetting
    @EnvironmentObject
    var userInfo: UserInfo

    @Binding
    var isShowAppearance: Bool
    @Binding
    var isShowTimeZone: Bool
    @Binding
    var isShowCurrency: Bool

    private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
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
                                Image(.icSubAvatar)
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
                .contentShape(.rect)
                .onTapGesture {
                    navigator.push(.walletSetting(.walletAccount))
                }
                Spacer()
                Image(.icSettingDarkMode)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .onTapGesture {
                        $isShowAppearance.showSheet()
                    }
            }
            .frame(height: 64)
            .padding(.top, .md)
            .padding(.horizontal, .xl)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    if !userInfo.adaHandleName.isBlank {
                        Image(.icAdahandle)
                            .resizable()
                            .frame(width: 16, height: 16)
                        Text(userInfo.adaHandleName)
                            .font(.labelSemiSecondary)
                            .foregroundStyle(.colorInteractiveToneHighlight)
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                            .padding(.trailing, 4)
                        Text(userInfo.walletName)
                            .font(.paragraphXMediumSmall)
                            .foregroundStyle(.colorInteractiveToneHighlight)
                            .padding(.horizontal, .lg)
                            .padding(.vertical, .xs)
                            .background(
                                RoundedRectangle(cornerRadius: BorderRadius.full).fill(.colorSurfaceHighlightDefault)
                            )
                            .frame(height: 20)
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                    } else {
                        Text(userInfo.walletName)
                            .font(.labelSemiSecondary)
                            .foregroundStyle(.colorBaseTent)
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                    }
                }
                Text(userInfo.minWallet?.address.shortenAddress)
                    .font(.paragraphXSmall)
                    .foregroundStyle(.colorInteractiveTentPrimarySub)
            }
            .padding(.horizontal, .xl)
            .padding(.vertical, .xl)

            Color.colorBorderPrimarySub.frame(height: 1)
                .padding(.horizontal, .xl)
                .padding(.bottom, .xl)
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
                    Text(appSetting.currency)
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Image(.icNext)
                        .frame(width: 20, height: 20)
                }
                .frame(height: 52)
                .contentShape(.rect)
                .onTapGesture {
                    $isShowCurrency.showSheet()
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
                    $isShowTimeZone.showSheet()
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
            }
            .padding(.horizontal, .xl)
            Color.colorBorderPrimarySub.frame(height: 1)
                .padding(.xl)
            Text("Security")
                .font(.paragraphXMediumSmall)
                .foregroundStyle(.colorInteractiveTentPrimarySub)
                .padding(.horizontal, .xl)
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Text("Authentication")
                        .font(.labelSmallSecondary)
                        .foregroundStyle(.colorBaseTent)
                    Spacer()
                    Text(appSetting.authenticationType == .password ? "Password" : appSetting.biometricAuthentication.displayName)
                        .font(.paragraphSmall)
                        .foregroundStyle(.colorInteractiveTentPrimarySub)
                    Image(.icNext)
                        .frame(width: 20, height: 20)
                }
                .frame(height: 52)
                .contentShape(.rect)
                .onTapGesture {
                    navigator.push(.securitySetting(.authentication))
                }
                if appSetting.authenticationType == .password {
                    HStack(spacing: 12) {
                        Text("Change password")
                            .font(.labelSmallSecondary)
                            .foregroundStyle(.colorBaseTent)
                        Spacer()
                        Image(.icNext)
                            .frame(width: 20, height: 20)
                    }
                    .frame(height: 52)
                    .contentShape(.rect)
                    .onTapGesture {
                        navigator.push(.changePassword)
                    }
                }
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
        .background(.colorBaseBackground)
        .compositingGroup()
    }
}

#Preview {
    VStack {
        SettingView(isShowAppearance: .constant(false), isShowTimeZone: .constant(false), isShowCurrency: .constant(false))
            .environmentObject(AppSetting.shared)
            .environmentObject(UserInfo.shared)
    }
}
