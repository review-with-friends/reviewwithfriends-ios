//
//  appMain.swift
//  app
//
//  Created by Colton Lathrop on 11/28/22.
//

import SwiftUI

@main
struct appMain: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var authentication = Authentication()
    @StateObject var userCache = UserCache()
    @StateObject var friendsCache = FriendsCache()
    @StateObject var notificationManager = NotificationManager()
    
    var body: some Scene {
        WindowGroup {
            IntializerView()
                .environmentObject(authentication)
                .environmentObject(userCache)
                .environmentObject(friendsCache)
                .environmentObject(notificationManager)
                .preferredColorScheme(.dark)
        }
    }
}
