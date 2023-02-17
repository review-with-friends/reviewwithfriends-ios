//
//  LikedReviewsList.swift
//  spotster
//
//  Created by Colton Lathrop on 2/16/23.
//

import Foundation
import SwiftUI

struct LikedReviewsList: View {
    @Binding var path: NavigationPath
    
    @StateObject var model = PaginatedReviewModel()
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var userCache: UserCache
    
    func createActionCallback(page: Int) async -> Result<[Review], RequestError> {
        return await spotster.getLikedReviews(token: self.auth.token, page: page)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(self.model.reviewsToRender) { review in
                    ReviewLoaderA(path: self.$path, review: review, showListItem: true, showLocation: true)
                }
                VStack {
                    if self.model.noMorePages {
                        Text("Hmmm, no more favorites...").foregroundColor(.secondary).padding(50).font(.caption)
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
        }.refreshable {
            Task {
                await self.model.hardLoadReviews(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
            }
        }.onAppear {
            Task {
                await self.model.loadReviews(auth: self.auth, userCache: self.userCache, action: self.createActionCallback)
            }
        }.scrollIndicators(.hidden).navigationTitle("Favorites")
    }
}
