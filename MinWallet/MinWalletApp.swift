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
        #if DEBUG
            // Remove this method to stop OneSignal Debugging
            OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        #endif
        // OneSignal initialization
        OneSignal.initialize(MinWalletConstant.minOneSignalAppID, withLaunchOptions: launchOptions)

        // requestPermission will show the native iOS notification permission prompt.
        // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
        OneSignal.Notifications.requestPermission(
            { accepted in
                print("User accepted notifications: \(accepted)")
            }, fallbackToSettings: true)

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
        completionHandler()
    }

    #if DEBUG
        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async -> UIBackgroundFetchResult {
            print("iOS Native didReceiveRemoteNotification: ", userInfo.debugDescription)

            var notificationID: String = ""
            var launchURL: String = ""

            if let customOSPayload = userInfo["custom"] as? NSDictionary {
                if let notificationId = customOSPayload["i"] {
                    notificationID = (notificationId as? String) ?? ""
                }
                if let url = customOSPayload["u"] as? String {
                    launchURL = url
                }
            }
            if let aps = userInfo["aps"] as? NSDictionary {
                if let alert = aps["alert"] as? NSDictionary {
                    if let messageBody = alert["body"] {
                        print("messageBody: ", messageBody)
                    }
                    if let messageTitle = alert["title"] {
                        print("messageTitle: ", messageTitle)
                    }
                }
            }

            print("Notification id: ", notificationID)
            print("launchURL: ", launchURL)
            return .newData
        }
    #endif
}
