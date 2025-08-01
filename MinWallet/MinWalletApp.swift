//
//  MinWalletApp.swift
//  MinWallet
//
//  Created by Klaus Le on 8/8/24.
//

import SwiftUI
import OneSignalFramework
import SDWebImage

#if canImport(FLEX) && DEBUG
    import FLEX
    
    extension UIWindow {
        /// Presents the FLEX debugging explorer when a shake gesture is detected.
        /// - Parameters:
        ///   - motion: The type of motion event that ended.
        ///   - event: The event associated with the motion, if any.
        open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            if motion == .motionShake {
                FLEXManager.shared.showExplorer()
            }
        }
    }
#endif

@main
struct MinWalletApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var appSetting: AppSetting = AppSetting.shared
    @StateObject var userInfo: UserInfo = UserInfo.shared
    @StateObject var hudState: HUDState = .init()
    @StateObject var bannerState: BannerState = .init()
    @StateObject var policyVM: PreloadWebViewModel = .init()
    
    var body: some Scene {
        WindowGroup {
            MainCoordinator()
                .environmentObject(appSetting)
                .environmentObject(userInfo)
                .environmentObject(hudState)
                .environmentObject(bannerState)
                .environmentObject(policyVM)
                .environment(\.locale, .init(identifier: appSetting.language))
                .onAppear {
                    policyVM.preloadContent(urlString: MinWalletConstant.minPolicyURL + "/headless/privacy-policy")
                    appSetting.initAppearanceStyle()
                }
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    /// Handles app launch initialization, including OneSignal setup and notification delegate assignment.
    /// - Returns: `true` to indicate successful launch.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        #if DEBUG
            // Remove this method to stop OneSignal Debugging
            OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        #endif
        // OneSignal initialization
        OneSignal.initialize(MinWalletConstant.minOneSignalAppID, withLaunchOptions: launchOptions)
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    /// Handles successful registration for remote notifications by converting the device token to a hexadecimal string and storing it in the shared user data manager.
    /// - Parameters:
    ///   - application: The singleton app object.
    ///   - deviceToken: The device token received from APNs.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.hexString
        UserDataManager.shared.deviceToken = deviceTokenString
    }
    
    /// Restricts the app's supported interface orientations to portrait mode only.
    /// - Returns: A mask specifying that only portrait orientation is supported.
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}


//MARK: Notification
extension AppDelegate: UNUserNotificationCenterDelegate {
    /// Handles the presentation of notifications when the app is in the foreground.
    /// - Parameters:
    ///   - center: The notification center managing the notification.
    ///   - notification: The notification being delivered.
    ///   - completionHandler: The closure to execute with the desired presentation options. This implementation presents the notification as a banner.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler(.banner)
    }
    /*
    
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
     */
}
