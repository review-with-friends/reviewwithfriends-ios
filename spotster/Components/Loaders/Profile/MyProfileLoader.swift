//
//  MyProfileLoader.swift
//  spotster
//
//  Created by Colton Lathrop on 1/6/23.
//

import Foundation
import SwiftUI

struct MyProfileLoader: View {
    @Binding var path: NavigationPath
    
    let userId: String
    
    @State var loading = true
    @State var failed = false
    @State var error = ""
    @State var user: User?
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var userCache: UserCache
    
    func loadUserAndFriendRequests() async -> Void {
        self.resetError()
        
        self.loading = true
        
        await self.loadUser()
        
        self.loading = false
    }
    
    func loadUser() async -> Void {
        let userResult = await userCache.getUserById(token: auth.token, userId: self.userId)
        
        switch userResult {
        case .success(let user):
            self.user = user
        case .failure(let error):
            self.setError(error: error.description)
        }
    }
    
    func resetError() {
        self.error = ""
        self.failed = false
    }
    
    func setError(error: String) {
        self.error = error
        self.failed = true
    }
    
    var body: some View {
        VStack {
            if self.loading {
                ReviewListItemSkeleton(loading: self.loading)
            } else if self.failed {
                Text(self.error)
                Button(action: {}){
                    Text("Retry Loading")
                }
            } else {
                if let user = self.user {
                    MyProfileView(path: self.$path, user: user)
                }
            }
        }.onFirstAppear(loadUserAndFriendRequests)
    }
}
