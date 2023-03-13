//
//  NotificationNavButton.swift
//  belocal
//
//  Created by Colton Lathrop on 1/31/23.
//

import Foundation
import SwiftUI

struct NotificationNavButton: View {
    @Binding var path: NavigationPath
    
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
                    self.path.append(NotificationDestination())
                }) {
                    ZStack {
                        Image(systemName: "heart").font(.title)
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
            NotificationNavButton(path: .constant(NavigationPath()))
        }.preferredColorScheme(.dark)
            .environmentObject(NotificationManager())
    }
}
