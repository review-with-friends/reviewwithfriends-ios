//
//  NotificationListView.swift
//  spotster
//
//  Created by Colton Lathrop on 1/31/23.
//

import Foundation
import SwiftUI

struct NotificationList: View {
    @EnvironmentObject var notificationManager: NotificationManager
    @EnvironmentObject var auth: Authentication
    
    @State var newCount = 0
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(Array(self.notificationManager.notifications.enumerated()), id: \.element) { index, notification in
                    NotificationListItem(notification: notification, highlighted: (index <= self.newCount - 1))
                }
            }.padding(.horizontal)
        }.refreshable {
            Task {
                await self.notificationManager.getNotifications(token:auth.token)
            }
        }.onAppear {
            self.newCount = self.notificationManager.newNotifications
            self.notificationManager.newNotifications = 0
        }.navigationTitle("Notifications").padding(.top)
    }
}
