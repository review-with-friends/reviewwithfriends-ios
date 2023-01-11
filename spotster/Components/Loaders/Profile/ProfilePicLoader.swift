//
//  ProfilePicView.swift
//  spotster
//
//  Created by Colton Lathrop on 12/3/22.
//

import Foundation
import SwiftUI

struct ProfilePicLoader: View {
    let userId: String
    let profilePicSize: ProfilePicSize
    let navigatable: Bool
    let ignoreCache: Bool
    
    @State var user: User?
    @State var reloadHard = false
    
    @EnvironmentObject var userCache: UserCache
    @EnvironmentObject var navigationManager: NavigationManager
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
    
    var body: some View {
        VStack {
            if self.reloadHard {
                ProfilePicSkeleton(loading: true, profilePicSize: self.profilePicSize)
            } else {
                if let user = self.user {
                    AsyncImage(url: URL(string: "https://bout.sfo3.cdn.digitaloceanspaces.com/" + user.picId), transaction: Transaction(animation: .spring())) { phase in
                        if let image = phase.image {
                            ProfilePic(image: image, profilePicSize: self.profilePicSize).onTapGesture {
                                if navigatable {
                                    navigationManager.path.append(UniqueUser(userId: self.userId))
                                }
                            }
                        } else if phase.error != nil {
                            Button(action: {
                                Task {
                                    self.reloadHard = true
                                    
                                    do { try await Task.sleep(for: Duration.milliseconds(100)) }
                                    catch {}
                                    
                                    self.reloadHard = false
                                }
                            }){
                                ProfilePicSkeleton(loading: false, profilePicSize: self.profilePicSize, error: true)
                            }.accentColor(.primary).onAppear {
                                Task {
                                    await self.loadUser(ignoreCachee: true)
                                }
                            }
                        } else {
                            ProfilePicSkeleton(loading: true, profilePicSize: self.profilePicSize)
                        }
                    }
                } else {
                    ProfilePicSkeleton(loading: true, profilePicSize: self.profilePicSize)
                }
            }
        }.onFirstAppear {
            Task {
                await self.loadUser(ignoreCachee: self.ignoreCache)
            }
        }
    }
}
