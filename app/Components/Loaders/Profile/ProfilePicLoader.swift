//
//  ProfilePicView.swift
//  app
//
//  Created by Colton Lathrop on 12/3/22.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct ProfilePicLoader: View {
    @Binding var path: NavigationPath
    
    let userId: String
    let profilePicSize: ProfilePicSize
    let navigatable: Bool
    let ignoreCache: Bool
    
    @State var user: User?
    @State var reloadHard = false
    
    @EnvironmentObject var userCache: UserCache
    @EnvironmentObject var auth: Authentication
    
    func loadUser(ignoreCachee: Bool) async -> Void {
        let userResult = await userCache.getUserById(token: auth.token, userId: self.userId, ignoreCache: ignoreCachee)
        
        switch userResult {
        case .success(let user):
            self.user = user
        case .failure(_):
            //self.setError(error: error.description)
            break
        }
    }
    
    var image: some View {
        VStack {
            if let user = self.user {
                WebImage(url: URL(string: "https://bout.sfo3.cdn.digitaloceanspaces.com/" + user.picId))
                    .placeholder {
                        ProfilePicSkeleton(loading: true, profilePicSize: self.profilePicSize)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: profilePicSize.rawValue, height: profilePicSize.rawValue)
                    .clipShape(Circle())
                    .transition(.fade(duration: 0.5)) // Fade Transition with duration
            } else {
                ProfilePicSkeleton(loading: true, profilePicSize: self.profilePicSize)
            }
        }
    }
    
    var body: some View {
        VStack {
            if self.reloadHard {
                ProfilePicSkeleton(loading: true, profilePicSize: self.profilePicSize)
            } else {
                if self.navigatable {
                    self.image
                        .onTapGesture {
                            if navigatable {
                                self.path.append(UniqueUser(userId: self.userId))
                            }
                        }
                } else {
                    self.image
                }
            }
        }.onFirstAppear {
            Task {
                await self.loadUser(ignoreCachee: self.ignoreCache)
            }
        }
    }
}

enum ProfilePicSize: CGFloat {
    case small = 28.0
    case smallMedium = 32.0
    case mediumSmall = 36.0
    case medium = 48.0
    case large = 256.0
}
