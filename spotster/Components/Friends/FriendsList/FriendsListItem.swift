//
//  FriendsListItem.swift
//  spotster
//
//  Created by Colton Lathrop on 1/10/23.
//

import Foundation
import SwiftUI

struct FriendsListItem: View {
    let user: User
    
    @State var isConfirmationShowing = false
    
    @State var isShowingErrorMessage = false
    @State var errorMessage = ""
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var friendsCache: FriendsCache
    
    func removeFriend() async {
        let result = await spotster.removeFriend(token: auth.token, friendId: user.id)
        
        switch result {
        case .success():
            let _ = await friendsCache.refreshFriendsCache(token: auth.token)
        case .failure(let error):
            self.errorMessage = error.description
            self.isShowingErrorMessage = true
        }
    }
    
    var body: some View  {
        HStack {
            ProfilePicLoader(userId: user.id, profilePicSize: .medium, navigatable: true, ignoreCache: true)
            VStack {
                Text(user.displayName)
                Text("@" + user.name).font(.caption)
            }
            Spacer()
            Button(action: {
                isConfirmationShowing = true
            }){
                HStack {
                    Image(systemName: "x.circle").font(.system(size: 20))
                    Text("Remove")
                }.foregroundColor(.red)
            }.alert("Are you sure you want to remove this friend?", isPresented: $isConfirmationShowing){
                Button(role: .destructive) {
                    Task {
                        await self.removeFriend()
                    }
                } label: {
                    Text("Remove")
                }
            } message: {
                Text("You can add them back later.")
            }
        }.alert("Failed to remove friend", isPresented: $isShowingErrorMessage){

        } message: {
            Text(self.errorMessage)
        }
    }
}

struct FriendsListItem_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            FriendsListItem(user: generateUserPreviewData())
        }.preferredColorScheme(.dark)
            .environmentObject(FriendsCache.generateDummyData())
            .environmentObject(UserCache())
            .environmentObject(NavigationManager())
            .environmentObject(Authentication.initPreview())
    }
}
