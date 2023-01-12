//
//  UserProfileView.swift
//  spotster
//
//  Created by Colton Lathrop on 12/27/22.
//

import Foundation
import SwiftUI

struct UserProfileView: View {
    var user: User
    
    var body: some View {
        VStack{
            ProfilePicLoader(userId: user.id, profilePicSize: .large, navigatable: false, ignoreCache: true)
            HStack {
                VStack {
                    Text(user.displayName).padding(4)
                    Text("@" + user.name).font(.caption)
                        .padding(.bottom)
                    UserActions(user: user)
                }
            }
            Spacer()
        }
    }
}

struct UserProfileView_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            UserProfileView(user: generateUserPreviewData()).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
        }
    }
}
