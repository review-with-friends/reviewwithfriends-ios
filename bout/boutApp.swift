//
//  boutApp.swift
//  bout
//
//  Created by Colton Lathrop on 11/28/22.
//

import SwiftUI

@main
struct boutApp: App {
    @StateObject var authentication = Authentication()
    var body: some Scene {
        WindowGroup {
            IntializerView().environmentObject(authentication).preferredColorScheme(.dark)
        }
    }
}
