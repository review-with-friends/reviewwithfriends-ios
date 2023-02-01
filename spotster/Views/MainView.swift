//
//  ActiveView.swift
//  spotster
//
//  Created by Colton Lathrop on 11/28/22.
//

import Foundation
import SwiftUI
import MapKit

struct MainView: View {
    @StateObject var navigationManager = NavigationManager()
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var friendsCache: FriendsCache
    @EnvironmentObject var notificatonManager: NotificationManager
    
    @State var tab = 0
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            ZStack{
                TabView (selection: $tab){
                    RecentActivityView()
                        .tabItem {
                            Label("Feed", systemImage: "house.fill")
                        }.tag(0).toolbarBackground(.ultraThinMaterial, for: .tabBar).toolbarBackground(.visible, for: .tabBar)
                    MapScreenView(mapView: MapView(navigationManager: navigationManager))
                        .tabItem {
                            Label("Map", systemImage: "map")
                        }.tag(1).toolbarBackground(.ultraThinMaterial, for: .tabBar).toolbarBackground(.visible, for: .tabBar)
                    if let user = auth.user {
                        MyProfileView(user: user)
                            .badge(self.friendsCache.fullFriends.incomingRequests.count > 0 ? "\($friendsCache.fullFriends.incomingRequests.count)" : nil)
                            .tabItem {
                                Label("Profile", systemImage: "person.crop.circle.fill")
                            }.tag(2).toolbarBackground(.ultraThinMaterial, for: .tabBar).toolbarBackground(.visible, for: .tabBar)
                    }
                }
            }
                .navigationDestination(for: UniqueLocation.self) { uniqueLocation in
                    LocationReviewsView(uniqueLocation: uniqueLocation)
                }
                .navigationDestination(for: UniqueLocationCreateReview.self) { uniqueLocationReview in
                    CreateReviewView(reviewLocation: uniqueLocationReview)
                }
                .navigationDestination(for: UniqueUser.self) { uniqueUser in
                    UserProfileLoader(userId: uniqueUser.userId)
                }
                .navigationDestination(for: ReviewDestination.self) { review in
                    ReviewLoader(review: review, showListItem: false)
                }
                .navigationDestination(for: [Like].self) { likes in
                    LikesList(likes: likes)
                }
                .navigationDestination(for: NotificationDestination.self) { _ in
                    NotificationList()
                }
                .navigationDestination(for: FriendsListDestination.self) { friendsList in
                    switch friendsList.view {
                    case .Friends:
                        FriendsList()
                    case .Ignored:
                        IgnoredFriendsList()
                    case .Incoming:
                        IncomingFriendsList()
                    case .Outgoing:
                        OutgoingFriendsList()
                    case .Search:
                        SearchForFriendsList()
                    }
                }
        }.environmentObject(self.navigationManager)
            .environmentObject(ChildViewReloadCallback(callback: nil))
            .accentColor(.primary)
            .onAppear {
                Task {
                    do {
                        try await Task.sleep(for: Duration.milliseconds(4000))
                        let _ = await self.friendsCache.refreshFriendsCache(token: self.auth.token)
                        await self.notificatonManager.getNotifications(token: self.auth.token)
                    } catch {}
                }
            }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(FriendsCache()).environmentObject(NotificationManager())
    }
}
