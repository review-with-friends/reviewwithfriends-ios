//
//  OutgoingFriendsList.swift
//  app
//
//  Created by Colton Lathrop on 1/11/23.
//

import Foundation
import SwiftUI

struct OutgoingFriendsList: View {
    @Binding var path: NavigationPath
    
    @EnvironmentObject var friendsCache: FriendsCache
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(self.friendsCache.fullFriends.outgoingRequests) { friend in
                    FriendsListItemLoader(path: self.$path, userId: friend.friendId, requestId: friend.id, itemType: .OutgoingItem, atFilter: nil)
                }
            }.padding(.horizontal)
        }.navigationTitle("Outgoing Requests").padding(.top)
    }
}
