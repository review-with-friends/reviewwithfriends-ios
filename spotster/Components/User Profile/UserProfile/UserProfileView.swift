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
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @StateObject var model = PaginatedReviewModel()
    
    @State var showGrid = getCachedGridPreference()
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var userCache: UserCache
    
    func createActionCallback(page: Int) async -> Result<[Review], RequestError> {
        return await spotster.getReviewsForUser(token: self.auth.token, userId: self.user.id, page: page)
    }
    
    static func getCachedGridPreference() -> Bool {
        let value = AppStorage.init(wrappedValue: false, "GRID_PREFERENCE")
        return value.wrappedValue
    }
    
    func setCachedGridPreference() {
        var value = AppStorage.init(wrappedValue: false, "GRID_PREFERENCE")
        value.wrappedValue = self.showGrid
        value.update()
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
                HStack {
                    Spacer()
                    Picker("What is your favorite color?", selection: $showGrid) {
                        Image(systemName: "photo.stack").tag(false)
                        Image(systemName: "rectangle.grid.3x2.fill").tag(true)
                    }.onChange(of: showGrid) { g in
                        self.setCachedGridPreference()
                    }
                    .pickerStyle(.segmented)
                    Spacer()
                }
                if self.showGrid {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 125))]) {
                        ForEach(self.model.reviewsToRender) { review in
                            ReviewGridItem(path: self.$path, fullReview: review.fullReview)
                        }
                    }
                }
                else {
                    ForEach(self.model.reviewsToRender) { review in
                        ReviewLoaderA(path: self.$path, review: review, showListItem: true, showLocation: true)
                    }
                }
                VStack {
                    if self.model.noMorePages {
                        Text("Hmmm, no more reviews...").foregroundColor(.secondary).padding(50).font(.caption)
                    }
                    else {
                        ProgressView().padding()
                    }
                }.onAppear {
                    Task {
                        await self.model.onItemAppear(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
                    }
                }
            }
            if self.model.failed {
                Text(self.model.error)
                
                Button(action: {
                    Task {
                        await self.model.hardLoadReviews(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
                    }
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
                if self.showGrid {
                    await self.model.onItemAppear(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
                }
            }
        }.scrollIndicators(.hidden)
    }
}
