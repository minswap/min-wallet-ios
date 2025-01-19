//
//  MinWalletApp.swift
//  MinWallet
//
//  Created by Klaus Le on 8/8/24.
//

import SwiftUI

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
        /*
        if appSetting.enableNotification {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }

            /*
            if
                let launchDict = launchOptions as NSDictionary?,
                let urlSchema = launchDict[UIApplication.LaunchOptionsKey.url] as? URL {
                UIApplication.shared.open(urlSchema, options: [:], completionHandler: nil)
            }
             */
        }
        */
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
