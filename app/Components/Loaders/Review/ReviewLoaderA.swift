//
//  ReviewLoaderA.swift
//  app
//
//  Created by Colton Lathrop on 2/9/23.
//

import Foundation
import SwiftUI

struct ReviewLoaderA: View {
    @Binding var path: NavigationPath
    
    var review: ReviewViewData
    
    var showListItem: Bool
    var showLocation = true
    
    @State var fullReview: FullReview
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var userCache: UserCache
    @EnvironmentObject var feedRefreshManager: FeedRefreshManager
    
    init(path: Binding<NavigationPath>, review: ReviewViewData, showListItem: Bool, showLocation: Bool) {
        self._path = path
        self.review = review
        self.showListItem = showListItem
        self.showLocation = showLocation
        self._fullReview = State(initialValue: review.fullReview)
    }
    
    func loadFullReview() async -> Void {
        let fullReviewResult = await getFullReviewById(token: auth.token, reviewId: review.id)
        
        switch fullReviewResult {
        case .success(let fullReview):
            self.fullReview = fullReview
            print("\(self.fullReview.likes.count)")
        case .failure(_):
            return
        }
    }
    
    var body: some View {
        HStack {
            if showListItem {
                ReviewListItem(path: self.$path, reloadCallback: self.loadFullReview, user: self.review.user, fullReview: self.fullReview, showLocation: showLocation)
            } else {
                ReviewView(path: self.$path, reloadCallback: self.loadFullReview, user: self.review.user, fullReview: self.fullReview)
            }
        }.onAppear {
            if self.feedRefreshManager.pop(review_id: self.review.id) {
                Task {
                    await self.loadFullReview()
                }
            }
        }
    }
}
