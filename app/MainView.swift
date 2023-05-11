//
//  ActiveView.swift
//  app
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
    
    @StateObject var feedRefreshManager = FeedRefreshManager()
    
    func processDeepLinkQueue() {
        if self.appDelegate.deeplinkQueue.count > 0 {
            if let target = self.appDelegate.deeplinkQueue.first {
                switch target.type {
                case .Review:
                    self.path.append(ReviewDestination(id: target.id, userId: nil))
                case .User:
                    self.path.append(UniqueUser(userId: target.id))
                }
                self.appDelegate.deeplinkQueue = []
            }
        }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack{
                TabView (selection: $tab){
                    LatestReviewsView(path: self.$path ).tag(0).toolbarBackground(.hidden, for: .tabBar)
                    MapScreenView(path: self.$path, mapView: MapView()).tag(1).toolbarBackground(.hidden, for: .tabBar)
                    if let user = auth.user {
                        UserProfileView(path: self.$path, user: user)
                            .tag(2).toolbarBackground(.hidden, for: .tabBar)
                    }
                    NotificationList(path: self.$path).tag(3).toolbarBackground(.hidden, for: .tabBar)
                }
                VStack {
                    Spacer()
                    NavigationTabBar(path: self.$path, tab: self.$tab)
                }
            }
            .navigationDestination(for: UniqueLocation.self) { uniqueLocation in
                LocationReviewsView(path: self.$path, uniqueLocation: uniqueLocation)
            }
            .navigationDestination(for: UniqueLocationCreateReview.self) { uniqueLocationReview in
                CreateReviewView(path: self.$path, reviewLocation: uniqueLocationReview)
            }
            .navigationDestination(for: CreateReviewFromImageDestination.self) { _ in
                CreateReviewFromImagesView(path: self.$path)
            }
            .navigationDestination(for: UniqueUser.self) { uniqueUser in
                UserProfileLoader(path: self.$path, userId: uniqueUser.userId)
            }
            .navigationDestination(for: LikedReviewsDestination.self) { dest in
                LikedReviewsList(path: self.$path)
            }
            .navigationDestination(for: SettingsDestination.self) { _ in
                if let user = auth.user {
                    MyProfileView(path: self.$path, user: user)
                        .tag(2).toolbarBackground(.hidden, for: .tabBar)
                }
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
            .navigationDestination(for: UserFriendsListDestination.self) { dest in
                UserFriendsList(path: self.$path, userId: dest.userId)
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
            .environmentObject(self.feedRefreshManager)
            .accentColor(.primary)
            .onFirstAppear {
                await self.notificatonManager.updateDeviceToken(authToken: self.auth.token, deviceToken: self.appDelegate.deviceToken)
            }
            .onChange(of: self.appDelegate.deeplinkQueue) { _ in
                self.processDeepLinkQueue()
            }
            .onChange(of: self.tab){ _ in
                let generator = UISelectionFeedbackGenerator()
                generator.selectionChanged()
            }
            .onAppear {
                if UIApplication.shared.alternateIconName != "AppIcon-New1" {
                    UIApplication.shared.setAlternateIconName("AppIcon-New1")
                }
                print(auth.token)
                
                app.requestNotifications()
                
                self.processDeepLinkQueue()
                
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
                    guard let uniqueLocation = app.getUniqueLocationFromURL(url: url)
                    else { return }
                    
                    self.path.append(uniqueLocation)
                case "review":
                    guard let reviewDestination = app.getReviewDestinationFromUrl(url: url)
                    else { return }
                    
                    self.path.append(reviewDestination)
                default:
                    return
                }
            }
    }
}
