//
//  ActiveView.swift
//  belocal
//
//  Created by Colton Lathrop on 11/28/22.
//

import Foundation
import SwiftUI
import MapKit

struct MainView: View {
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var friendsCache: FriendsCache
    @EnvironmentObject var notificatonManager: NotificationManager
    @EnvironmentObject var appDelegate: AppDelegate
    
    @State var tab = 0
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack{
                TabView (selection: $tab){
                    LatestReviewsView(path: self.$path )
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }.tag(0).toolbarBackground(APP_BACKGROUND, for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
                    MapScreenView(path: self.$path, mapView: MapView())
                        .tabItem {
                            Label("Explore", systemImage: "map")
                        }.tag(1).toolbarBackground(APP_BACKGROUND, for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
                    if let user = auth.user {
                        MyProfileView(path: self.$path, user: user)
                            .badge(self.friendsCache.fullFriends.incomingRequests.count > 0 ? "\($friendsCache.fullFriends.incomingRequests.count)" : nil)
                            .tabItem {
                                Label("Profile", systemImage: "person.crop.circle.fill")
                            }.tag(2)
                            .toolbarBackground(APP_BACKGROUND, for: .tabBar)
                            .toolbarBackground(.visible, for: .tabBar)
                    }
                }
            }
            .navigationDestination(for: UniqueLocation.self) { uniqueLocation in
                LocationReviewsView(path: self.$path, uniqueLocation: uniqueLocation)
            }
            .navigationDestination(for: UniqueLocationCreateReview.self) { uniqueLocationReview in
                CreateReviewView(path: self.$path, reviewLocation: uniqueLocationReview)
            }
            .navigationDestination(for: UniqueUser.self) { uniqueUser in
                UserProfileLoader(path: self.$path, userId: uniqueUser.userId)
            }
            .navigationDestination(for: LikedReviewsDestination.self) { dest in
                LikedReviewsList(path: self.$path)
            }
            .navigationDestination(for: ReviewDestination.self) { review in
                ReviewLoader(path: self.$path, review: review, showListItem: false)
            }
            .navigationDestination(for: [Like].self) { likes in
                LikesList(path: self.$path, likes: likes)
            }
            .navigationDestination(for: NotificationDestination.self) { _ in
                NotificationList(path: self.$path)
            }
            .navigationDestination(for: SearchDestination.self) { _ in
                SearchReviewsView(path: self.$path)
            }
            .navigationDestination(for: EditReviewDestination.self) { dest in
                EditReviewView(path: self.$path, fullReview: dest.fullReview)
            }
            .navigationDestination(for: DiscoverFriendsDestination.self) { _ in
                DiscoverFriendsList(path: self.$path, navigatable: true)
            }
            .navigationDestination(for: DeleteAccountDestination.self) { _ in
                DeleteAccountView()
            }
            .navigationDestination(for: FriendsListDestination.self) { friendsList in
                switch friendsList.view {
                case .Friends:
                    FriendsList(path: self.$path)
                case .Ignored:
                    IgnoredFriendsList(path: self.$path)
                case .Incoming:
                    IncomingFriendsList(path: self.$path)
                case .Outgoing:
                    OutgoingFriendsList(path: self.$path)
                case .Search:
                    SearchForFriendsList(path: self.$path)
                }
            }
        }.environmentObject(ChildViewReloadCallback(callback: nil))
            .accentColor(.primary)
            .onFirstAppear {
                await self.notificatonManager.updateDeviceToken(authToken: self.auth.token, deviceToken: self.appDelegate.deviceToken)
            }
            .onAppear {
                UIApplication.shared.setAlternateIconName("AppIcon")
                belocal.requestNotifications()
                Task {
                    let _ = await self.friendsCache.refreshFriendsCache(token: self.auth.token)
                    await self.notificatonManager.getNotifications(token: self.auth.token)
                }
            }.onOpenURL { url in
                guard let url = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
                
                guard let navigationType = url.queryItems?.first(where: { $0.name == "navType" })?.value
                else { return }
                
                switch navigationType {
                case "location":
                    guard let uniqueLocation = belocal.getUniqueLocationFromURL(url: url)
                    else { return }
                    
                    self.path.append(uniqueLocation)
                case "review":
                    guard let reviewDestination = belocal.getReviewDestinationFromUrl(url: url)
                    else { return }
                    
                    self.path.append(reviewDestination)
                default:
                    return
                }
            }
    }
}
