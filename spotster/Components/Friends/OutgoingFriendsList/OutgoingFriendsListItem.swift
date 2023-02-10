//
//  OutgoingFriendsListItem.swift
//  spotster
//
//  Created by Colton Lathrop on 1/11/23.
//

import Foundation
import SwiftUI

struct OutgoingFriendsListItem: View {
    @Binding var path: NavigationPath
    
    /// User who issued the given request
    let user: User
    
    /// RequestId for the given request
    let requestId: String
    
    @State var pending = false
    
    @State var isConfirmationShowing = false
    
    @State var isShowingErrorMessage = false
    @State var errorMessage = ""
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var friendsCache: FriendsCache
    
    func cancelFriend() async {
        if self.pending {
            return
        }
        
        self.pending = true
        
        let result = await spotster.cancelFriend(token: auth.token, requestId: requestId)
        
        switch result {
        case .success():
            let _ = await friendsCache.refreshFriendsCache(token: auth.token)
        case .failure(let error):
            self.errorMessage = error.description
            self.isShowingErrorMessage = true
        }
        
        self.pending = false
    }
    
    var body: some View  {
        HStack {
            ProfilePicLoader(path: self.$path, userId: user.id, profilePicSize: .medium, navigatable: true, ignoreCache: true)
            VStack {
                Text(user.displayName)
                Text("@" + user.name).font(.caption)
            }
            Spacer()
            Button(action: {
                Task {
                    await self.cancelFriend()
                }
            }){
                HStack {
                    Text("Cancel")
                    Image(systemName: "x.circle").font(.system(size: 20))
                }.foregroundColor(.red)
            }
        }.alert("Failed to cancel friend request", isPresented: $isShowingErrorMessage){
        } message: {
            Text(self.errorMessage)
        }
    }
}

struct OutgoingFriendsListItem_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            OutgoingFriendsListItem(path: .constant(NavigationPath()) , user: generateUserPreviewData(), requestId: "peepeepoopoo")
        }.preferredColorScheme(.dark)
            .environmentObject(FriendsCache.generateDummyData())
            .environmentObject(UserCache())
            .environmentObject(Authentication.initPreview())
    }
}
