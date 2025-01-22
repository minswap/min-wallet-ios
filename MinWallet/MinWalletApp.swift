//
//  MinWalletApp.swift
//  MinWallet
//
//  Created by Klaus Le on 8/8/24.
//

import SwiftUI
import OneSignalFramework

@main
struct MinWalletApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @StateObject var appSetting: AppSetting = AppSetting.shared
    @StateObject var userInfo: UserInfo = UserInfo.shared
    @StateObject var hudState: HUDState = .init()
    @StateObject var bannerState: BannerState = .init()

    var body: some Scene {
        WindowGroup {
            MainCoordinator()
                .environmentObject(appSetting)
                .environmentObject(userInfo)
                .environmentObject(hudState)
                .environmentObject(bannerState)
                .environment(\.locale, .init(identifier: appSetting.language))
                .alert(isPresented: $hudState.isPresented) {
                    Alert(
                        title: Text("Notice"), message: Text(hudState.msg),
                        dismissButton: .default(
                            Text("Got it!"),
                            action: {
                                hudState.onAction?()
                            }))
                }
                .banner(
                    isShowing: $bannerState.isShowingBanner,
                    infoContent: {
                        if let infoContent = bannerState.infoContent {
                            infoContent()
                        } else {
                            EmptyView()
                        }
                    }
                )
                .onAppear {
                    appSetting.initAppearanceStyle()
                }
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Remove this method to stop OneSignal Debugging
       OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        
       // OneSignal initialization
       OneSignal.initialize("e7da5418-cbc0-4725-80d3-6400e3d09123", withLaunchOptions: launchOptions)

       // requestPermission will show the native iOS notification permission prompt.
       // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
       OneSignal.Notifications.requestPermission({ accepted in
         print("User accepted notifications: \(accepted)")
       }, fallbackToSettings: true)

       // Login your customer with externalId
       // OneSignal.login("EXTERNAL_ID")
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.hexString
        UserDataManager.shared.deviceToken = deviceTokenString
    }
}


//MARK: Notification
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.alert, .badge, .sound])
        guard let userInfo = notification.request.content.userInfo as? [String: AnyObject] else { return }
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        guard let userInfo = response.notification.request.content.userInfo as? [String: AnyObject] else { return }
        //TODO: Handle notification
        completionHandler()
    }
}

extension AppDelegate {

}
