//
//  IncomingFriendsListItem.swift
//  app
//
//  Created by Colton Lathrop on 1/10/23.
//

import Foundation
import SwiftUI

struct IncomingFriendsListItem: View {
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
        
        let result = await app.acceptFriend(token: auth.token, requestId: requestId)
        
        switch result {
        case .success():
            let _ = await friendsCache.refreshFriendsCache(token: auth.token)
        case .failure(let error):
            self.errorMessage = error.description
            self.isShowingErrorMessage = true
        }
        
        self.pending = false
    }
    
    func rejectFriend() async {
        if self.pending {
            return
        }
        
        self.pending = true
        
        let result = await app.rejectFriend(token: auth.token, requestId: requestId)
        
        switch result {
        case .success():
            let _ = await friendsCache.refreshFriendsCache(token: auth.token)
        case .failure(let error):
            self.errorMessage = error.description
            self.isShowingErrorMessage = true
        }
        
        self.pending = false
    }
    
    func ignoreFriend() async {
        if self.pending {
            return
        }
        
        self.pending = true
        
        let result = await app.ignoreFriend(token: auth.token, requestId: requestId)
        
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
                    Text("Accept")
                    Image(systemName: "checkmark.circle").font(.system(size: 20))
                }.foregroundColor(.green)
            }
            Button(action: {
                isConfirmationShowing = true
            }){
                HStack {
                    Image(systemName: "x.circle").font(.system(size: 20))
                    Text("Reject")
                }.foregroundColor(.red)
            }.alert("Are you sure you want to reject this friend request?", isPresented: $isConfirmationShowing){
                Button(role: .destructive) {
                    Task {
                        await self.rejectFriend()
                    }
                } label: {
                    Text("Reject")
                }
                Button(role: .destructive) {
                    Task {
                        await self.ignoreFriend()
                    }
                } label: {
                    Text("Block Future Requests")
                }
            } message: {
                Text("If you ignore the request, they won't be able to send another request.")
            }
        }.alert("Request failed", isPresented: $isShowingErrorMessage){
        } message: {
            Text(self.errorMessage)
        }
    }
}

struct IncomingFriendsListItem_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            IncomingFriendsListItem(path: .constant(NavigationPath()) ,user: generateUserPreviewData(), requestId: "peepeepoopoo")
        }.preferredColorScheme(.dark)
            .environmentObject(FriendsCache.generateDummyData())
            .environmentObject(UserCache())
            .environmentObject(Authentication.initPreview())
    }
}
