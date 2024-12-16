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

    @State var appSetting: AppSetting = .init()
    @State var userInfo: UserInfo = .init()

    var body: some Scene {
        WindowGroup {
            MainCoordinator()
                .environmentObject(appSetting)
                .environmentObject(userInfo)
                .environment(\.locale, .init(identifier: appSetting.language))
                .onAppear {
                    appSetting.initAppearanceStyle()
                }
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    private let appSetting: AppSetting = .init()

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
