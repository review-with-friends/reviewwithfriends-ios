//
//  NavigationTabBar.swift
//  app
//
//  Created by Colton Lathrop on 3/15/23.
//

import Foundation
import SwiftUI

struct NavigationTabBar: View {
    @Binding var path: NavigationPath
    @Binding var tab: Int
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var friendsCache: FriendsCache
    @EnvironmentObject var notificationManager: NotificationManager
    @EnvironmentObject var feedReloadCallbackManager: FeedReloadCallbackManager
    
    func getNotificationCount() -> String {
        if self.notificationManager.newNotifications <= 9 {
            return "\(self.notificationManager.newNotifications)"
        } else {
            return ""
        }
    }
    
    var body: some View {
        HStack {
            Spacer()
            TabBarButton(callback: { withAnimation {
                if self.tab == 0 {
                    Task {
                        await self.feedReloadCallbackManager.callIfExists()
                        let generator = UIImpactFeedbackGenerator()
                        generator.impactOccurred()
                    }
                }
                self.tab = 0
            } } , imageName: self.tab == 0 ? "house.fill" : "house", isActive: self.tab == 0)
            TabBarButton(callback: { withAnimation { self.tab = 1 }} , imageName: self.tab == 1 ? "map.fill" : "map", isActive: self.tab == 1)
            Spacer()
            CreateReviewNavButton(path: self.$path)
            Spacer()
            TabBarButton(callback: { withAnimation {self.tab = 3} } , imageName: self.tab == 3 ? "bell.fill" : "bell", isActive: self.tab == 3).overlay {
                if self.notificationManager.newNotifications > 0 {
                    VStack {
                        Circle().foregroundColor(.red).frame(width: 16).overlay {
                            Text(self.getNotificationCount()).font(.caption)
                        }.offset(x: 16, y: -10)
                    }
                }
            }
            ZStack {
                Circle().frame(width: 30).foregroundColor(tab == 2 ? .primary : .secondary)
                if let user = self.auth.user {
                    ProfilePicLoader(path: self.$path, userId: user.id, profilePicSize: .small, navigatable: false, ignoreCache: false).disabled(true)
                }
                if self.friendsCache.fullFriends.incomingRequests.count > 0 {
                    VStack {
                        Circle().foregroundColor(.red).frame(width: 16).overlay {
                            Text(self.friendsCache.getIncomingFriendRequestCountString()).font(.caption)
                        }.offset(x: 16, y: -10)
                    }
                }
            }.padding().onTapGesture {
                withAnimation {
                    tab = 2
                }
            }
            Spacer()
        }.background(APP_BACKGROUND)
    }
}


struct NavigationTabBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NavigationTabBarPreview_View()
        }.preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache()).environmentObject(FriendsCache.generateDummyData()).environmentObject(NotificationManager()).environmentObject(FeedReloadCallbackManager(callback: nil))
    }
}

struct NavigationTabBarPreview_View: View {
    @State var tab = 0
    var body: some View {
        VStack {
            NavigationTabBar(path:.constant(NavigationPath()), tab: self.$tab)
        }
    }
}
