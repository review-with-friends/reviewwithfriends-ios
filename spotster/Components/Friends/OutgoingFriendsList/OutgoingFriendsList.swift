//
//  OutgoingFriendsList.swift
//  spotster
//
//  Created by Colton Lathrop on 1/11/23.
//

import Foundation
import SwiftUI

struct OutgoingFriendsList: View {
    @EnvironmentObject var friendsCache: FriendsCache
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(self.friendsCache.fullFriends.outgoingRequests) { friend in
                    FriendsListItemLoader(userId: friend.friendId, requestId: friend.id, itemType: .OutgoingItem)
                }
            }.padding(.horizontal)
        }.navigationTitle("Outgoing Requests").padding(.top)
    }
}
