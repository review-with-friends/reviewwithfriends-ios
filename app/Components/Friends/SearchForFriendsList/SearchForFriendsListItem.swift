//
//  SearchForFriendsListItem.swift
//  app
//
//  Created by Colton Lathrop on 1/11/23.
//

import Foundation
import SwiftUI

struct SearchForFriendsListItem: View {
    @Binding var path: NavigationPath
    
    let user: User
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var friendsCache: FriendsCache
    
    var body: some View  {
        HStack {
            FriendsListItemProfileView(path: self.$path, user: self.user)
            Spacer()
            UserActions(path: self.$path, user: user)
        }
    }
}

struct SearchForFriendsListItem_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            SearchForFriendsListItem(path: .constant(NavigationPath()), user: generateUserPreviewData())
        }.preferredColorScheme(.dark)
            .environmentObject(FriendsCache.generateDummyData())
            .environmentObject(UserCache())
            .environmentObject(Authentication.initPreview())
    }
}
