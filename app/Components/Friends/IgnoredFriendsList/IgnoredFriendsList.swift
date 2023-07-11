//
//  IgnoredFriendsList.swift
//  app
//
//  Created by Colton Lathrop on 1/10/23.
//

import Foundation
import SwiftUI

struct IgnoredFriendsList: View {
    @Binding var path: NavigationPath
    
    @EnvironmentObject var friendsCache: FriendsCache
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(self.friendsCache.fullFriends.ignoredRequests) { friend in
                    FriendsListItemLoader(path: self.$path, userId: friend.userId, requestId: friend.id, itemType: .IgnoredItem, atFilter: nil)
                }
            }.padding(.horizontal)
        }.navigationTitle("Ignored Requests").padding(.top)
    }
}
