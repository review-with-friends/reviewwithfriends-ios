//
//  IncomingFriendsList.swift
//  spotster
//
//  Created by Colton Lathrop on 1/10/23.
//

import Foundation
import SwiftUI

struct IncomingFriendsList: View {
    @EnvironmentObject var friendsCache: FriendsCache
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(self.friendsCache.fullFriends.incomingRequests) { friend in
                    FriendsListItemLoader(userId: friend.friendId, itemType: .IncomingItem)
                }
            }.padding(.horizontal)
        }
    }
}

struct IncomingFriendsList_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            IncomingFriendsList()
        }.preferredColorScheme(.dark)
    }
}
