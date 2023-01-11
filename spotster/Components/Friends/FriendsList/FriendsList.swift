//
//  FriendsList.swift
//  spotster
//
//  Created by Colton Lathrop on 1/10/23.
//

import Foundation
import SwiftUI

struct FriendsList: View {
    @EnvironmentObject var friendsCache: FriendsCache
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(self.friendsCache.fullFriends.friends) { friend in
                    FriendsListItemLoader(userId: friend.friendId, itemType: .FriendItem)
                }
            }.padding(.horizontal)
        }
    }
}
