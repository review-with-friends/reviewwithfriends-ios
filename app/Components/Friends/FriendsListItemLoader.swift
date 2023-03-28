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
    
    @State var user: User?
    @State var loading: Bool = false
    
    @EnvironmentObject var auth: Authentication
    
    func loadUser() async {
        self.loading = true
        
        let result = await app.getUserById(token: auth.token, userId: userId)

        switch result {
        case .success(let user):
            self.user = user
        case .failure(_):
            break
        }
        
        self.loading = false
    }
    
    var body: some View  {
        VStack {
            if self.loading {
                ProgressView()
            } else {
                if let user = self.user {
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
                } else {
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
