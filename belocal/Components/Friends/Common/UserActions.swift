//
//  UserActions.swift
//  belocal
//
//  Created by Colton Lathrop on 3/2/23.
//

import Foundation
import SwiftUI


struct UserActions: View {
    @Binding var path: NavigationPath
    
    let user: User
    
    @State var pending = false
    
    @State var isShowingErrorMessage = false
    @State var errorMessage = ""
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var friendsCache: FriendsCache
    
    func isUserFriend() -> Bool {
        self.friendsCache.fullFriends.friends.contains{ friend in
            friend.friendId == user.id
        }
    }
    
    func isFriendRequestSent() -> Bool {
        self.friendsCache.fullFriends.outgoingRequests.contains { request in
            request.friendId == user.id
        }
    }
    
    func isFriendRequestIncoming() -> Bool {
        self.friendsCache.fullFriends.incomingRequests.contains { request in
            request.userId == user.id
        }
    }
    
    func isFriendRequestIgnored() -> Bool {
        self.friendsCache.fullFriends.ignoredRequests.contains { request in
            request.userId == user.id
        }
    }
    
    func isMe() -> Bool {
        if let user = self.auth.user {
            if user.id == self.user.id {
                return true
            }
        }
        return false
    }
    
    func addFriend() async {
        if self.pending {
            return
        }
        
        self.pending = true
        
        let result = await belocal.addFriend(token: auth.token, userId: user.id)
        
        switch result {
        case .success():
            let _ = await friendsCache.refreshFriendsCache(token: auth.token)
        case .failure(let error):
            self.errorMessage = error.description
            self.isShowingErrorMessage = true
        }
        
        self.pending = false
    }
    
    var body: some View {
        VStack {
            if self.isMe() {
                Text("You!").foregroundColor(.secondary)
            }
            else if self.isUserFriend() {
                Text("Friends").foregroundColor(.secondary)
            } else if self.isFriendRequestSent() {
                Button(action: {
                    self.path.append(FriendsListDestination(view: .Outgoing))
                }){
                    HStack {
                        Text("Cancel")
                        Image(systemName: "x.circle").font(.system(size: 20))
                    }.foregroundColor(.red)
                }
            } else if self.isFriendRequestIncoming() {
                Button(action: {
                    self.path.append(FriendsListDestination(view: .Incoming))
                }){
                    HStack {
                        Text("Accept")
                        Image(systemName: "checkmark.circle").font(.system(size: 20))
                    }.foregroundColor(.green)
                }
            } else if self.isFriendRequestIgnored() {
                Button(action: {
                    self.path.append(FriendsListDestination(view: .Ignored))
                }){
                    HStack {
                        Text("Unignore and Accept")
                        Image(systemName: "checkmark.circle").font(.system(size: 20))
                    }.foregroundColor(.green)
                }
            } else {
                Button(action: {
                    Task {
                        await self.addFriend()
                    }
                }){
                    HStack {
                        Text("Add Friend")
                        Image(systemName: "checkmark.circle").font(.system(size: 20))
                    }.foregroundColor(.green)
                }
            }
        }.alert("Failed to add friend", isPresented: $isShowingErrorMessage){
        } message: {
            Text(self.errorMessage)
        }
    }
}
