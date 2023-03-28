//
//  IncomingFriendsList.swift
//  app
//
//  Created by Colton Lathrop on 1/10/23.
//

import Foundation
import SwiftUI

struct IncomingFriendsList: View {
    @Binding var path: NavigationPath
    
    @EnvironmentObject var friendsCache: FriendsCache
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(self.friendsCache.fullFriends.incomingRequests) { friend in
                    FriendsListItemLoader(path: self.$path, userId: friend.userId, requestId: friend.id, itemType: .IncomingItem)
                }
            }.padding(.horizontal)
        }.navigationTitle("Incoming Requests").padding(.top)
    }
}
