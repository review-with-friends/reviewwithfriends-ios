//
//  FriendsListItemLoader.swift
//  app
//
//  Created by Colton Lathrop on 1/11/23.
//

import Foundation
import SwiftUI

enum FriendsListItemType {
    case FriendItem
    case IgnoredItem
    case OutgoingItem
    case IncomingItem
    case SearchItem
}

struct FriendsListItemLoader: View {
    @Binding var path: NavigationPath
    
    let userId: String
    let requestId: String
    let itemType: FriendsListItemType
    let atFilter: String?
    
    @State var user: User?
    @State var loading: Bool = false
    @State var error: Bool = false
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var userCache: UserCache
    
    func loadUser() async {
        self.loading = true
        self.error = false
        
        let result = await userCache.getUserById(token: auth.token, userId: userId)

        switch result {
        case .success(let user):
            self.user = user
        case .failure(_):
            self.error = true
            break
        }
        
        self.loading = false
    }
    
    func shouldShowUser(targetUser: User) -> Bool {
        if let filter = self.atFilter {
            if targetUser.name.starts(with: filter.lowercased()) {
                return true;
            } else {
                return false;
            }
        } else {
            return true;
        }
    }
    
    var body: some View  {
        VStack {
            if self.loading {
                //ProgressView()
            } else {
                if let user = self.user {
                    if self.shouldShowUser(targetUser: user) {
                        switch self.itemType {
                        case .FriendItem:
                            FriendsListItem(path: self.$path, user: user)
                        case .IgnoredItem:
                            IgnoredFriendsListItem(path: self.$path, user: user, requestId: self.requestId)
                        case .OutgoingItem:
                            OutgoingFriendsListItem(path: self.$path, user: user, requestId: self.requestId)
                        case .IncomingItem:
                            IncomingFriendsListItem(path: self.$path, user: user, requestId: self.requestId)
                        case .SearchItem:
                            SearchForFriendsListItem(path: self.$path, user: user)
                        }
                    }
                } else if self.error {
                    Button(action: {
                        Task {
                            await loadUser()
                        }
                    }){
                        VStack {
                            Text("Failed to load")
                            Text("Tap to retry").font(.caption)
                        }
                    }.foregroundColor(.red)
                }
            }
        }.onFirstAppear {
            Task {
                await loadUser()
            }
        }
    }
}
