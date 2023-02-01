//
//  NotificationNavButton.swift
//  spotster
//
//  Created by Colton Lathrop on 1/31/23.
//

import Foundation
import SwiftUI

struct NotificationNavButton: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var notificationManager: NotificationManager
    
    func getNotificationCount() -> String {
        if self.notificationManager.newNotifications <= 9 {
            return "\(self.notificationManager.newNotifications)"
        } else {
            return ""
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: {
                    self.navigationManager.path.append(NotificationDestination())
                }) {
                    ZStack {
                        Image(systemName: "heart").font(.title).padding(.horizontal)
                        if self.notificationManager.newNotifications > 0 {
                            VStack {
                                Circle().foregroundColor(.red).frame(width: 16).overlay {
                                    Text(self.getNotificationCount()).font(.caption)
                                }.offset(x: 16, y: -10)
                            }
                        }
                    }
                }.accentColor(.primary)
            }
        }
    }
}

struct NotificationNavButton_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            NotificationNavButton()
        }.preferredColorScheme(.dark)
            .environmentObject(NotificationManager())
            .environmentObject(NavigationManager())
    }
}
