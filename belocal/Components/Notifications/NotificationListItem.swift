//
//  NotificationListItem.swift
//  belocal
//
//  Created by Colton Lathrop on 1/31/23.
//

import Foundation
import SwiftUI

struct NotificationListItem: View {
    @Binding var path: NavigationPath
    
    var notification: UserNotification
    var highlighted: Bool
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var userCache: UserCache
    
    var body: some View  {
        HStack {
            VStack {
                ProfilePicLoader(path: self.$path, userId: notification.userId, profilePicSize: .medium, navigatable: true, ignoreCache: false)
            }
            Button(action: {
                self.path.append(ReviewDestination(id: notification.reviewId, userId: notification.reviewUserId))
            }) {
                VStack {
                    HStack {
                        if notification.actionType == 1 {
                            Text("liked your review at \(notification.reviewLocation)").font(.caption).lineLimit(2)
                        } else if notification.actionType == 2 {
                            Text("replied to your review at \(notification.reviewLocation)").font(.caption).lineLimit(2)
                        } else {
                            Text("mentioned your review at \(notification.reviewLocation)").font(.caption).lineLimit(2)
                        }
                        Text("\(belocal.getDateString(date: notification.created))").foregroundColor(.secondary).font(.caption)
                        if self.highlighted {
                            Circle().foregroundColor(.red).frame(width: 10)
                        }
                    }
                }
                Spacer()
            }.accentColor(.primary)
        }
    }
}

struct NotificationListItem_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            NotificationListItem(path: .constant(NavigationPath()), notification: UserNotification(id: "123", created: Date(), reviewUserId: "123", userId: "123", reviewId: "123", actionType: 1, reviewLocation: "test location"), highlighted: false)
            NotificationListItem(path: .constant(NavigationPath()), notification: UserNotification(id: "123", created: Date(), reviewUserId: "123", userId: "123", reviewId: "123", actionType: 1, reviewLocation: "test location"), highlighted: true)
        }.preferredColorScheme(.dark)
            .environmentObject(UserCache())
            .environmentObject(Authentication.initPreview())
    }
}
