//
//  IncomingFriendsListItem.swift
//  spotster
//
//  Created by Colton Lathrop on 1/10/23.
//

import Foundation
import SwiftUI

struct IncomingFriendsListItem: View {
    let user: User
    
    @State var isConfirmationShowing = false
    
    var body: some View  {
        HStack {
            ProfilePicLoader(userId: user.id, profilePicSize: .medium, navigatable: true, ignoreCache: true)
            VStack {
                Text(user.displayName)
                Text("@" + user.name).font(.caption)
            }
            Spacer()
            Button(action: {}){
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
                        //await self.removeFriend()
                    }
                } label: {
                    Text("Reject")
                }
                Button(role: .destructive) {
                    Task {
                        //await self.removeFriend()
                    }
                } label: {
                    Text("Block Future Requests")
                }
            } message: {
                Text("If you ignore the request, they won't be able to send another request.")
            }
        }
    }
}

struct IncomingFriendsListItem_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            IncomingFriendsListItem(user: generateUserPreviewData())
        }.preferredColorScheme(.dark)
            .environmentObject(FriendsCache.generateDummyData())
            .environmentObject(UserCache())
            .environmentObject(NavigationManager())
            .environmentObject(Authentication.initPreview())
    }
}
