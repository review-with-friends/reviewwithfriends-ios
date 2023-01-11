//
//  ReviewView.swift
//  spotster
//
//  Created by Colton Lathrop on 12/19/22.
//

import Foundation
import SwiftUI

struct ReviewLoader: View {
    var review: Review
    var showListItem: Bool
    var showLocation = true
    
    @State var loading = true
    @State var failed = false
    @State var error = ""
    @State var user: User?
    @State var fullReview: FullReview?
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var userCache: UserCache
    
    func loadReviewAndUser() async -> Void {
        self.resetError()
        
        self.loading = true
        
        await self.loadUser()
        await self.loadFullReview()
        
        self.loading = false
    }
    
    func loadUser() async -> Void {
        let userResult = await userCache.getUserById(token: auth.token, userId: review.userId)
        
        switch userResult {
        case .success(let user):
            self.user = user
        case .failure(let error):
            self.setError(error: error.description)
        }
    }
    
    func loadFullReview() async -> Void {
        let fullReviewResult = await getFullReviewById(token: auth.token, reviewId: review.id)
        
        switch fullReviewResult {
        case .success(let fullReview):
            self.fullReview = fullReview
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
                    if let fullReview = self.fullReview {
                        if showListItem {
                            ReviewListItem(reloadCallback: self.loadFullReview, user: user, fullReview: fullReview, showLocation: showLocation)
                        } else {
                            ReviewView(reloadCallback: self.loadFullReview, user: user, fullReview: fullReview)
                        }
                    }
                }
            }
        }.onFirstAppear(loadReviewAndUser)
    }
}
