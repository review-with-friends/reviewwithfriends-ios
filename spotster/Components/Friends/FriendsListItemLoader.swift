//
//  FriendsListItemLoader.swift
//  spotster
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
}

struct FriendsListItemLoader: View {
    let userId: String
    let itemType: FriendsListItemType
    
    @State var user: User?
    @State var loading: Bool = false
    
    @EnvironmentObject var auth: Authentication
    
    func loadUser() async {
        self.loading = true
        
        let result = await spotster.getUserById(token: auth.token, userId: userId)
        print("loading \(self.userId)")
        
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
                        FriendsListItem(user: user)
                    case .IgnoredItem:
                        FriendsListItem(user: user)
                    case .OutgoingItem:
                        FriendsListItem(user: user)
                    case .IncomingItem:
                        IncomingFriendsListItem(user: user)
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
