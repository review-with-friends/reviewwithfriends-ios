//
//  FriendsList.swift
//  belocal
//
//  Created by Colton Lathrop on 1/10/23.
//

import Foundation
import SwiftUI

struct FriendsList: View {
    @Binding var path: NavigationPath
    
    @EnvironmentObject var friendsCache: FriendsCache
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(self.friendsCache.fullFriends.friends) { friend in
                    FriendsListItemLoader(path: self.$path, userId: friend.friendId, requestId: friend.id, itemType: .FriendItem)
                }
            }.padding(.horizontal)
        }.navigationTitle("Friends").padding(.top)
    }
}
