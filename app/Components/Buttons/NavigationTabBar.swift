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
    
    func getNotificationCount() -> String {
        if self.notificationManager.newNotifications <= 9 {
            return "\(self.notificationManager.newNotifications)"
        } else {
            return ""
        }
    }
    
    func getIncomingFriendRequestCount() -> String {
        if self.friendsCache.fullFriends.incomingRequests.count <= 9 {
            return "\(self.friendsCache.fullFriends.incomingRequests.count)"
        } else {
            return ""
        }
    }
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                tab = 0
            }){
                VStack {
                    Image(systemName:"house.fill").font(.system(size: 24))
                }
            }.padding(12).frame(minWidth: 72).accentColor(tab == 0 ? .primary : .secondary)
            Button(action: {
                tab = 1
            }){
                VStack {
                    Image(systemName: "map.fill").font(.system(size: 24))
                }
            }.padding(12).frame(minWidth: 72).accentColor(tab == 1 ? .primary : .secondary)
            Spacer()
            CreateReviewNavButton(path: self.$path)
            Spacer()
            Button(action: {
                tab = 3
            }){
                ZStack {
                    Image(systemName: "bell.fill").font(.title)
                    if self.notificationManager.newNotifications > 0 {
                        VStack {
                            Circle().foregroundColor(.red).frame(width: 16).overlay {
                                Text(self.getNotificationCount()).font(.caption)
                            }.offset(x: 16, y: -10)
                        }
                    }
                }
            }.padding(12).frame(minWidth: 72).accentColor(tab == 3 ? .primary : .secondary)
            Button(action: {
                tab = 2
            }){
                ZStack {
                    Circle().frame(width: 30)
                    if let user = self.auth.user {
                        ProfilePicLoader(path: self.$path, userId: user.id, profilePicSize: .small, navigatable: false, ignoreCache: false).disabled(true)
                    }
                    if self.friendsCache.fullFriends.incomingRequests.count > 0 {
                        VStack {
                            Circle().foregroundColor(.red).frame(width: 16).overlay {
                                Text(self.getIncomingFriendRequestCount()).font(.caption)
                            }.offset(x: 16, y: -10)
                        }
                    }
                }
            }.padding().accentColor(tab == 2 ? .primary : .secondary)
            Spacer()
        }.background(APP_BACKGROUND)
    }
}


struct NavigationTabBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NavigationTabBarPreview_View()
        }.preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache()).environmentObject(FriendsCache.generateDummyData()).environmentObject(NotificationManager())
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
