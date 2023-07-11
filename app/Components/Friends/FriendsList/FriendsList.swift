//
//  FriendsList.swift
//  app
//
//  Created by Colton Lathrop on 1/10/23.
//

import Foundation
import SwiftUI

struct FriendsList: View {
    @Binding var path: NavigationPath
    
    @EnvironmentObject var friendsCache: FriendsCache
    
    @State var searchText = ""
    
    var body: some View {
        ScrollView {
            HStack {
                TextField("@", text: $searchText).padding(8)
            }.background(.quaternary).cornerRadius(8).padding()
            VStack {
                ForEach(self.friendsCache.fullFriends.friends) { friend in
                    FriendsListItemLoader(path: self.$path, userId: friend.friendId, requestId: friend.id, itemType: .FriendItem, atFilter: searchText)
                }
            }.padding(.horizontal)
        }.navigationTitle("Friends").padding(.top)
    }
}
