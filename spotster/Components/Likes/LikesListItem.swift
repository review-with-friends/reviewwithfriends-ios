//
//  LikesListItem.swift
//  spotster
//
//  Created by Colton Lathrop on 1/30/23.
//

import Foundation
import SwiftUI

struct LikesListItem: View {
    let userId: String
    let date: Date
    
    @State var isConfirmationShowing = false
    
    @State var isShowingErrorMessage = false
    @State var errorMessage = ""
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var friendsCache: FriendsCache
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View  {
        Button(action: {
            self.navigationManager.path.append(UniqueUser(userId: self.userId))
        }) {
            HStack {
                ProfilePicLoader(userId: self.userId, profilePicSize: .medium, navigatable: false, ignoreCache: false)
                SlimDate(date: date)
                Spacer()
            }.padding(.horizontal)
        }
    }
}

struct LikesListItem_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            LikesListItem(userId: generateUserPreviewData().id, date: Date())
        }.preferredColorScheme(.dark)
            .environmentObject(FriendsCache.generateDummyData())
            .environmentObject(UserCache())
            .environmentObject(NavigationManager())
            .environmentObject(Authentication.initPreview())
    }
}
