//
//  PaginatedReviewModel.swift
//  app
//
//  Created by Colton Lathrop on 2/9/23.
//

import Foundation
import SwiftUI

/// Observable model to fetch reviews for rendering.
@MainActor
class PaginatedReviewModel: ObservableObject {
    @Published var loading = false
    @Published var failed = false
    @Published var error = ""
    @Published var reviews: [FullReview] = []
    @Published var reviewsToRender: [ReviewViewData] = []
    
    var nextPage = 0
    var noMorePages = false
    var pendingTasks: [Task<(), Never>] = []
    
    func onItemAppear(auth: Authentication, userCache: UserCache, action: @escaping (_: Int) async -> Result<[FullReview], RequestError>) async {
        if reviews.count == 0 {
            return
        }
        
        if noMorePages {
            return
        }
        
        await loadReviews(auth: auth, userCache: userCache, action: action)
    }
    
    func removeExisting(incomingReviews: [FullReview]) -> [FullReview] {
        var incomingReviews = incomingReviews
        
        for fullReview in self.reviews {
            incomingReviews.removeAll(where: {$0.review.id == fullReview.review.id})
        }
        
        return incomingReviews
    }
    
    func loadReviews(auth: Authentication, userCache: UserCache, action: @escaping (_: Int) async -> Result<[FullReview], RequestError>) async {
        if self.loading {
            return
        }
        
        self.loading = true
        
        self.resetError()
        let reviews_res = await action(self.nextPage)
        
        switch reviews_res {
        case .success(var fullReviews):
            self.nextPage += 1
            
            if fullReviews.count == 0 {
                self.noMorePages = true
            }
            
            fullReviews = removeExisting(incomingReviews: fullReviews)
            
            for fullReview in fullReviews {
                let userResult = await userCache.getUserById(token: auth.token, userId: fullReview.review.userId)
                switch userResult {
                case .success(let user):
                    let id = "\(fullReview.review.id)|\(fullReview.likes.count)\(fullReview.replies.count)\(fullReview.pics.count)"
                    self.reviewsToRender.append(ReviewViewData(id: id, fullReview: fullReview, user: user))
                case .failure(_):
                    print("failure loading user")
                }
            }
            
            self.reviews.append(contentsOf: fullReviews)
        case .failure(let error):
            self.setError(error: error.description)
        }
        
        self.loading = false
    }
    
    func hardLoadReviews(auth: Authentication, userCache: UserCache, action: @escaping (_: Int) async -> Result<[FullReview], RequestError>) async {
        self.loading = false
        self.nextPage = 0
        self.reviews = []
        self.reviewsToRender = []
        self.noMorePages = false
        
        await self.loadReviews(auth: auth, userCache: userCache, action: action)
        
    }
    
    func resetError() {
        self.error = ""
        self.failed = false
    }
    
    func setError(error: String) {
        self.error = error
        self.failed = true
    }
}

func extractReviewIdFromRenderId(renderId: String) -> String {
    let parts = renderId.split(separator: "|")
    if let id = parts.first {
        return String(id)
    } else {
        return ""
    }
}
