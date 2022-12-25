//
//  ReviewView.swift
//  bout
//
//  Created by Colton Lathrop on 12/19/22.
//

import Foundation
import SwiftUI

struct ReviewView: View {
    @Binding var review: Review
    
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
                Text("Loading")
            } else if self.failed {
                Text(self.error)
                Button(action: {}){
                    Text("Retry Loading")
                }
            } else {
                if let user = self.user {
                    VStack {
                        ReviewHeader(user: user, review: self.review)
                        if let fullReview = self.fullReview {
                            ReviewPicLoader(token: auth.token, fullReview: fullReview, reloadCallback: loadFullReview)
                            HStack {
                                ReviewBody(fullReview: fullReview).padding(.top, 3.0)
                            }
                        }
                    }
                }
            }
        }.task {
            await loadReviewAndUser()
        }
    }
}
