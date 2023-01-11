//
//  MyProfileView.swift
//  spotster
//
//  Created by Colton Lathrop on 1/10/23.
//

import Foundation
import SwiftUI

struct MyProfileView: View {
    var user: User
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var navigatonManager: NavigationManager
    @EnvironmentObject var friendsCache: FriendsCache
    
    var body: some View {
        ScrollView {
            VStack {
                    VStack {
                        ProfilePicLoader(userId: user.id, profilePicSize: .large, navigatable: false, ignoreCache: true).padding()
                        Text(user.displayName).font(.title)
                        Text("@" + user.name).font(.caption)
                    }
                
                List {
                    Section {
                        Button(action:{
                            self.navigatonManager.path.append(FriendsListDestination(view: .Incoming))
                        }){
                            HStack {
                                Text("Incoming Friend Requests")
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.secondary)
                            }
                        }
                        Button(action:{
                            self.navigatonManager.path.append(FriendsListDestination(view: .Outgoing))
                        }){
                            HStack {
                                Text("Outgoing Friend Requests")
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.secondary)
                            }
                        }
                        Button(action:{
                            self.navigatonManager.path.append(FriendsListDestination(view: .Ignored))
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
                            self.navigatonManager.path.append(FriendsListDestination(view: .Friends))
                        }){
                            HStack {
                                Text("Friends")
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.secondary)
                            }
                        }
                        ChangeProfileButton()
                        LogoutButton()
                    }
                    Section {
                        DeleteAccountButton()
                    }
                }.accentColor(.primary).scaledToFill().scrollDisabled(true)
            }
        }.onAppear {
            Task {
                await self.friendsCache.refreshFriendsCache(token: self.auth.token)
            }
        }
    }
}

struct MyProfileView_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            MyProfileView(user: generateUserPreviewData())
                .preferredColorScheme(.dark)
                .environmentObject(Authentication.initPreview())
                .environmentObject(UserCache())
                .environmentObject(NavigationManager())
                .environmentObject(FriendsCache())
        }
    }
}
