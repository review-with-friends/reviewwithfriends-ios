//
//  AppDelegate.swift
//  belocal
//
//  Created by Colton Lathrop on 2/6/23.
//

import Foundation
import UIKit
import SwiftUI

@MainActor
class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    public var deviceToken: String = ""
    public var updatePathCallback: ((AnyHashable) -> Void)?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UIApplication.shared.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        self.deviceToken = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ){
        let userInfo = response.notification.request.content.userInfo

        guard let arrAPS = userInfo["aps"] as? [String: Any] else { return }
        guard let notification_type = arrAPS["notification_type"] as? String else { return }
        guard let notification_value = arrAPS["notification_value"] as? String else { return }
        
        print(notification_type)
        print(notification_value)
        
        if let pathCallback = self.updatePathCallback {
            pathCallback([] as [Like])
        }
        
        completionHandler()
    }
}
