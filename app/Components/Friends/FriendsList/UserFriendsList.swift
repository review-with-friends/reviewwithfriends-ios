//
//  UserFriendsList.swift
//  app
//
//  Created by Colton Lathrop on 4/17/23.
//

import Foundation
import SwiftUI

struct UserFriendsList: View {
    @Binding var path: NavigationPath
    var userId: String
    
    @State var loading = false
    @State var error = false
    @State var errorMessage = ""
    @State var friends: [Friend] = []
    
    @EnvironmentObject var auth: Authentication
    
    func loadFriends() async {
        self.loading = true
        
        self.error = false
        self.errorMessage = ""
        
        let friendsResult = await app.getUserFriends(token: self.auth.token, userId: self.userId)
        
        switch friendsResult {
        case .success(let friends):
            self.friends = friends
        case .failure(let error):
            self.error = true
            self.errorMessage = error.description
        }
        
        self.loading = false
    }
    
    var body: some View {
        VStack {
            if self.loading {
                Spacer()
                ProgressView()
                Spacer()
            } else if self.error {
                Text(self.errorMessage)
            }
            else {
                ScrollView {
                    VStack {
                        ForEach(self.friends) { friend in
                            FriendsListItemLoader(path: self.$path, userId: friend.friendId, requestId: friend.id, itemType: .SearchItem)
                        }
                    }.padding(.horizontal)
                }.padding(.top)
            }
        }.navigationTitle("Friends")
            .onAppear {
                Task {
                    await loadFriends()
                }
            }
    }
}
