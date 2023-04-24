//
//  MyProfileView.swift
//  app
//
//  Created by Colton Lathrop on 1/10/23.
//

import Foundation
import SwiftUI

struct MyProfileView: View {
    @Binding var path: NavigationPath
    
    var user: User
    
    @State var logoutConfirmationShowing = false
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var friendsCache: FriendsCache
    
    func getIncomingCount() -> Int {
        self.friendsCache.fullFriends.incomingRequests.count
    }
    
    func getOutgoingCount() -> Int {
        self.friendsCache.fullFriends.outgoingRequests.count
    }
    
    func getFriendsCount() -> Int {
        self.friendsCache.fullFriends.friends.count
    }
    
    var body: some View {
        VStack {
            if user.recovery == false {
                SetupRecoveryEmail()
            }
            List {
                Section {
                    Button(action:{
                        self.path.append(LikedReviewsDestination())
                    }){
                        HStack {
                            Text("View Favorites")
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.secondary)
                        }
                    }
                }
                Section {
                    Button(action:{
                        self.path.append(FriendsListDestination(view: .Incoming))
                    }){
                        HStack {
                            Text("Incoming Friend Requests").badge(self.getIncomingCount())
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.secondary)
                        }
                    }
                    Button(action:{
                        self.path.append(FriendsListDestination(view: .Outgoing))
                    }){
                        HStack {
                            Text("Outgoing Friend Requests").badge(self.getOutgoingCount())
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.secondary)
                        }
                    }
                    Button(action:{
                        self.path.append(FriendsListDestination(view: .Ignored))
                    }){
                        HStack {
                            Text("Ignored Friend Requests")
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.secondary)
                        }
                    }
                }
                Section {
                    Button(action:{
                        self.path.append(FriendsListDestination(view: .Search))
                    }){
                        HStack {
                            Text("Search for Friends")
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.secondary)
                        }
                    }
                    Button(action:{
                        self.path.append(DiscoverFriendsDestination())
                    }){
                        HStack {
                            Text("Discover Friends")
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.secondary)
                        }
                    }
                    Button(action:{
                        self.path.append(FriendsListDestination(view: .Friends))
                    }){
                        HStack {
                            Text("Friends").badge(self.getFriendsCount())
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.secondary)
                        }
                    }
                }
                Section {
                    Button(action:{
                        auth.resetCachedOnboarding()
                    }){
                        HStack {
                            Text("Change Profile")
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.secondary)
                        }
                    }
                    Button("Logout", role: .cancel){
                        logoutConfirmationShowing = true
                    }
                    Button("Delete Account", role: .destructive){
                        path.append(DeleteAccountDestination())
                    }
                }
            }
        }.accentColor(.primary).onAppear {
            Task {
                await self.friendsCache.refreshFriendsCache(token: self.auth.token)
            }
        }.navigationTitle("Settings").confirmationDialog("Are you sure you want to logout?", isPresented: $logoutConfirmationShowing){
            Button("Yes", role: .destructive) {
                self.auth.logout()
            }
        } message: {
            Text("Are you sure you want to logout?")
        }
    }
}

struct MyProfileView_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            MyProfileView(path: .constant(NavigationPath()), user: generateUserPreviewData())
                .preferredColorScheme(.dark)
                .environmentObject(Authentication.initPreview())
                .environmentObject(UserCache())
                .environmentObject(FriendsCache.generateDummyData())
        }
    }
}
