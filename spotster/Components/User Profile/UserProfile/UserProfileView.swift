//
//  UserProfileView.swift
//  spotster
//
//  Created by Colton Lathrop on 1/30/23.
//

import Foundation
import SwiftUI


struct UserProfileView: View {
    @Binding var path: NavigationPath
    var user: User
    
    @StateObject var model = PaginatedReviewModel()
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var userCache: UserCache
    
    func createActionCallback(page: Int) async -> Result<[Review], RequestError> {
        return await spotster.getReviewsForUser(token: self.auth.token, userId: self.user.id, page: page)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                HStack {
                    Spacer()
                    VStack {
                        ProfilePicLoader(path: self.$path, userId: user.id, profilePicSize: .large, navigatable: false, ignoreCache: true)
                        HStack {
                            VStack {
                                Text(user.displayName).padding(4)
                                Text("@" + user.name).font(.caption)
                                    .padding(.bottom)
                                UserActions(path: self.$path, user: user).padding(.bottom)
                            }
                        }
                    }
                    Spacer()
                }
                ForEach(self.model.reviewsToRender) { review in
                    ReviewLoaderA(path: self.$path, review: review, showListItem: true, showLocation: true)
                }
                ProgressView().padding().onAppear {
                    Task {
                        await self.model.onItemAppear(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
                    }
                }
            }
            if self.model.failed {
                Text(self.model.error)
                
                Button(action: {
                    
                }){
                    Text("Retry Loading")
                }
            }
        }.refreshable {
            Task {
                await self.model.hardLoadReviews(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
            }
        }.onAppear {
            Task {
                await self.model.loadReviews(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
            }
        }
    }
}
