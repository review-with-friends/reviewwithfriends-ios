//
//  IgnoredFriendsListItem.swift
//  spotster
//
//  Created by Colton Lathrop on 1/11/23.
//

import Foundation
import SwiftUI

struct IgnoredFriendsListItem: View {
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
    
    func acceptFriend() async {
        if self.pending {
            return
        }
        
        self.pending = true
        
        let result = await spotster.acceptFriend(token: auth.token, requestId: requestId)
        
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
            FriendsListItemProfileView(path: self.$path, user: self.user)
            Spacer()
            Button(action: {
                Task {
                    await self.acceptFriend()
                }
            }){
                HStack {
                    Text("Unignore and Accept")
                    Image(systemName: "checkmark.circle").font(.system(size: 20))
                }.foregroundColor(.green)
            }
        }.alert("Failed to accept friend request", isPresented: $isShowingErrorMessage){
        } message: {
            Text(self.errorMessage)
        }
    }
}

struct IgnoredFriendsListItem_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            IgnoredFriendsListItem(path: .constant(NavigationPath()), user: generateUserPreviewData(), requestId: "peepeepoopoo")
        }.preferredColorScheme(.dark)
            .environmentObject(FriendsCache.generateDummyData())
            .environmentObject(UserCache())
            .environmentObject(Authentication.initPreview())
    }
}
