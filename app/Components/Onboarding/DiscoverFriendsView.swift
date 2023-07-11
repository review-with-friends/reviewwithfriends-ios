//
//  DiscoverFriendsView.swift
//  app
//
//  Created by Colton Lathrop on 3/1/23.
//

import Foundation
import SwiftUI

struct DiscoverFriendsView: View {
    @Binding var path: NavigationPath
    
    @EnvironmentObject var auth: Authentication
    
    func moveToNextScreen() {
        self.path.append(SetupRecovery())
    }
    
    var body: some View {
        ZStack {
            VStack {
                DiscoverFriendsList(path: self.$path, navigatable: false)
            }
            VStack {
                Spacer()
                PrimaryButton(title: "Continue", action: {
                    self.moveToNextScreen()
                })
            }
        }
    }
}

struct DiscoverFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverFriendsView(path: .constant(NavigationPath())).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
    }
}
