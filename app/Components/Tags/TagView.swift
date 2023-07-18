//
//  Tag.swift
//  app
//
//  Created by Colton Lathrop on 7/14/23.
//

import Foundation
import SwiftUI

struct TagView: View {
    @Binding var path: NavigationPath
    
    let userId: String
    
    @State var loading = false
    @State var user: User?
    
    @EnvironmentObject var userCache: UserCache
    @EnvironmentObject var auth: Authentication
    
    func loadUser() async {
        self.loading = true
        
        let result = await userCache.getUserById(token: auth.token, userId: userId)

        switch result {
        case .success(let user):
            self.user = user
        case .failure(_):
            break
        }
        
        self.loading = false
    }
    
    var body: some View {
        VStack {
            HStack {
                ProfilePicLoader(path: self.$path,  userId: userId, profilePicSize: .small, navigatable: false, ignoreCache: false)
                Text("@\(userId)").foregroundColor(.white)
            }.padding(4.0)
        }.background(.black)
            .cornerRadius(8.0)
            .shadow(radius: 4.0)
    }
}


struct TagView_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            TagView(path: .constant(NavigationPath()), userId: "123")
        }
            .environmentObject(FriendsCache.generateDummyData())
            .environmentObject(UserCache())
            .environmentObject(Authentication.initPreview())
    }
}
