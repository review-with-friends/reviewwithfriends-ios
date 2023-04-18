//
//  UserProfileCommandBar.swift
//  app
//
//  Created by Colton Lathrop on 4/16/23.
//

import Foundation
import SwiftUI

struct UserProfileCommandBar: View {
    @Binding var path: NavigationPath
    @Binding var showReportSheet: Bool
    
    let userId: String
    
    @EnvironmentObject var friendsCache: FriendsCache
    
    var body: some View {
            HStack {
                if friendsCache.areFriends(userId: userId) {
                    IconButton(icon: "person.2.fill", action: {
                        self.path.append(UserFriendsListDestination(userId: self.userId))
                    }).padding(.horizontal)
                }
                DangerousIconButton(icon: "flag.fill", action: {
                    self.showReportSheet = true
                })
            }
    }
}

struct UserProfileCommandBar_Preview: PreviewProvider {
    static var previews: some View {
        VStack{
            UserProfileCommandBar(path: .constant(NavigationPath()), showReportSheet: .constant(false), userId: "123")
                .preferredColorScheme(.dark)
                .environmentObject(Authentication.initPreview())
                .environmentObject(UserCache())
                .environmentObject(FriendsCache.generateDummyData())
        }
    }
}
