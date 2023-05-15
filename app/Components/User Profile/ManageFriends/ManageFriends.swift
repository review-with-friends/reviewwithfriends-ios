//
//  ManageFriends.swift
//  app
//
//  Created by Colton Lathrop on 5/12/23.
//

import Foundation
import SwiftUI

struct ManageFriends: View {
    @Binding var path: NavigationPath

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
            List {
                Section {
                    Button(action:{
                        self.path.append(FriendsListDestination(view: .Incoming))
                    }){
                        HStack {
                            Text("Incoming").badge(self.getIncomingCount())
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.secondary)
                        }
                    }
                    Button(action:{
                        self.path.append(FriendsListDestination(view: .Outgoing))
                    }){
                        HStack {
                            Text("Outgoing").badge(self.getOutgoingCount())
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.secondary)
                        }
                    }
                    Button(action:{
                        self.path.append(FriendsListDestination(view: .Ignored))
                    }){
                        HStack {
                            Text("Ignored")
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
            }
        }.accentColor(.primary).onAppear {
            Task {
                await self.friendsCache.refreshFriendsCache(token: self.auth.token)
            }
        }.navigationBarTitle("Manage Friends", displayMode: .large)
    }
}

struct ManageFriends_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            ManageFriends(path: .constant(NavigationPath()))
                .preferredColorScheme(.dark)
                .environmentObject(UserCache())
                .environmentObject(FriendsCache.generateDummyData())
        }
    }
}
