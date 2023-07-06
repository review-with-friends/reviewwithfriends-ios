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
    
    let like: Like
    
    @State var isConfirmationShowing = false
    
    @State var isShowingErrorMessage = false
    @State var errorMessage = ""
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var friendsCache: FriendsCache
    
    var body: some View  {
        Button(action: {
            self.path.append(UniqueUser(userId: self.like.userId))
        }) {
            HStack {
                ProfilePicLoader(path: self.$path, userId: self.like.userId, profilePicSize: .medium, navigatable: true, ignoreCache: false)
                VStack {
                    HStack {
                        SlimDate(date: self.like.created)
                        Spacer()
                    }
                    HStack {
                        Text("reacted to your review with \(app.getEmojiFromNumber(number: like.likeType).emoji)").font(.caption)
                        Spacer()
                    }
                }
                Spacer()
            }.padding(.horizontal)
        }.accentColor(.primary)
    }
}

struct LikesListItem_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            LikesListItem(path: .constant(NavigationPath()), like: Like(id: "123", created: Date(), userId: "123", reviewId: "123", likeType: 2))
        }.preferredColorScheme(.dark)
            .environmentObject(FriendsCache.generateDummyData())
            .environmentObject(UserCache())
            .environmentObject(Authentication.initPreview())
    }
}
