//
//  SearchForFriendsListItem.swift
//  spotster
//
//  Created by Colton Lathrop on 3/1/23.
//

import Foundation
import SwiftUI

struct DiscoverFriendsListItem: View {
    @Binding var path: NavigationPath
    
    let user: User
    let navigatable: Bool
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var friendsCache: FriendsCache
    
    var body: some View  {
        HStack {
            FriendsListItemProfileView(path: self.$path, user: self.user, navigatable: self.navigatable)
            Spacer()
            UserActions(path: self.$path, user: user)
        }
    }
}

struct DiscoverFriendsListItem_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            DiscoverFriendsListItem(path: .constant(NavigationPath()), user: generateUserPreviewData(), navigatable: true)
        }.preferredColorScheme(.dark)
            .environmentObject(FriendsCache.generateDummyData())
            .environmentObject(UserCache())
            .environmentObject(Authentication.initPreview())
    }
}
