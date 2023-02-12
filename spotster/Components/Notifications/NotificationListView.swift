//
//  NotificationListView.swift
//  spotster
//
//  Created by Colton Lathrop on 1/31/23.
//

import Foundation
import SwiftUI

struct NotificationList: View {
    @Binding var path: NavigationPath
    
    @EnvironmentObject var notificationManager: NotificationManager
    @EnvironmentObject var auth: Authentication
    
    @State var newCount = 0
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(Array(self.notificationManager.notifications.enumerated()), id: \.element) { index, notification in
                    NotificationListItem(path: self.$path, notification: notification, highlighted: (index <= self.newCount - 1)).padding(.bottom, 8)
                }
            }.padding(.horizontal)
        }.refreshable {
            Task {
                await self.notificationManager.getNotifications(token:auth.token)
            }
        }.onAppear {
            self.newCount = self.notificationManager.newNotifications
            self.notificationManager.newNotifications = 0
            self.notificationManager.setCachedNewNotifications()
        }.navigationTitle("Notifications").padding(.top)
    }
}
