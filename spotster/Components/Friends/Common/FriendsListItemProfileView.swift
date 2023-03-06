//
//  FriendsListItemProfileView.swift
//  spotster
//
//  Created by Colton Lathrop on 3/2/23.
//

import Foundation
import SwiftUI

/// View for showing the user profile icon and name.
/// Designed to be shown in a list view.
struct FriendsListItemProfileView: View {
    @Binding var path: NavigationPath
    
    let user: User
    var navigatable: Bool = true
    
    var text: some View {
        VStack {
            HStack {
                Text(user.displayName)
                Spacer()
            }
            HStack {
                Text("@" + user.name).font(.caption)
                Spacer()
            }
        }
    }
    
    var body: some View {
        HStack {
            ProfilePicLoader(path: self.$path,  userId: user.id, profilePicSize: .medium, navigatable: self.navigatable, ignoreCache: true)
            if self.navigatable {
                Button(action: {
                    self.path.append(UniqueUser(userId: self.user.id))
                }) {
                    self.text
                }.accentColor(.primary)
            } else {
                self.text
            }
        }
    }
}
