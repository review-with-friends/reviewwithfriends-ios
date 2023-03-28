//
//  LikesListItem.swift
//  app
//
//  Created by Colton Lathrop on 1/30/23.
//

import Foundation
import SwiftUI

struct LikesListItem: View {
    @Binding var path: NavigationPath
    
    let userId: String
    let date: Date
    
    @State var isConfirmationShowing = false
    
    @State var isShowingErrorMessage = false
    @State var errorMessage = ""
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var friendsCache: FriendsCache
    
    var body: some View  {
        Button(action: {
            self.path.append(UniqueUser(userId: self.userId))
        }) {
            HStack {
                ProfilePicLoader(path: self.$path, userId: self.userId, profilePicSize: .medium, navigatable: true, ignoreCache: false)
                SlimDate(date: date)
                Spacer()
            }.padding(.horizontal)
        }
    }
}

struct LikesListItem_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            LikesListItem(path: .constant(NavigationPath()), userId: generateUserPreviewData().id, date: Date())
        }.preferredColorScheme(.dark)
            .environmentObject(FriendsCache.generateDummyData())
            .environmentObject(UserCache())
            .environmentObject(Authentication.initPreview())
    }
}
