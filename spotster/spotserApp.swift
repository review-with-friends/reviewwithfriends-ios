//
//  spotserApp.swift
//  spotster
//
//  Created by Colton Lathrop on 11/28/22.
//

import SwiftUI

@main
struct spotserApp: App {
    @StateObject var authentication = Authentication()
    @StateObject var userCache = UserCache()
    
    var body: some Scene {
        WindowGroup {
            IntializerView().environmentObject(authentication).environmentObject(userCache).environmentObject(FriendsCache()).preferredColorScheme(.dark)
        }
    }
}
