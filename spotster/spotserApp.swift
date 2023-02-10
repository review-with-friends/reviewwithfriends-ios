//
//  spotserApp.swift
//  spotster
//
//  Created by Colton Lathrop on 11/28/22.
//

import SwiftUI

@main
struct spotserApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var authentication = Authentication()
    @StateObject var userCache = UserCache()
    
    var body: some Scene {
        WindowGroup {
            IntializerView()
                .environmentObject(authentication)
                .environmentObject(userCache)
                .environmentObject(FriendsCache())
                .environmentObject(NotificationManager())
                .preferredColorScheme(.dark)
        }
    }
}
