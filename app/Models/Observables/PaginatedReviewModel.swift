//
//  PaginatedReviewModel.swift
//  app
//
//  Created by Colton Lathrop on 2/9/23.
//

import Foundation

/// Observable model to fetch reviews for rendering.
@MainActor
class PaginatedReviewModel: ObservableObject {
    @Published var loading = true
    @Published var failed = false
    @Published var error = ""
    @Published var reviews: [Review] = []
    @Published var reviewsToRender: [ReviewViewData] = []
    
    var nextPage = 0
    var noMorePages = false
    
    func onItemAppear(auth: Authentication, userCache: UserCache, action: (_: Int) async -> Result<[Review], RequestError>) async {
        if reviews.count == 0 {
            return
        }

        if noMorePages {
            return
        }
        
        if self.loading {
            return
        }

        await loadReviews(auth: auth, userCache: userCache, action: action)
    }
    
    func removeExisting(incomingReviews: [Review]) -> [Review] {
        var incomingReviews = incomingReviews
        for review in self.reviews {
            incomingReviews.removeAll(where: {$0.id == review.id})
        }
        return incomingReviews
    }
    
    func loadReviews(auth: Authentication, userCache: UserCache, action: (_: Int) async -> Result<[Review], RequestError>) async {
        self.loading = true
        self.resetError()
        
        let reviews_res = await action(self.nextPage)
        
        switch reviews_res {
        case .success(var reviews):
            if reviews.count == 0 {
                self.noMorePages = true
            }
            reviews = removeExisting(incomingReviews: reviews)
            
            for review in reviews {
                if review.id == "ecc7b206-90bc-49e1-a36e-5df9f56cfa6a"{
                    continue
                }
                let fullReviewResult = await getFullReviewById(token: auth.token, reviewId: review.id)
                switch fullReviewResult {
                case .success(let fullReview):
                    let userResult = await userCache.getUserById(token: auth.token, userId: review.userId)
                    switch userResult {
                    case .success(let user):
                        let id = "\(review.id)|\(fullReview.likes.count)\(fullReview.replies.count)\(fullReview.pics.count)"
                        self.reviewsToRender.append(ReviewViewData(id: id, fullReview: fullReview, user: user))
                    case .failure(_):
                        print("failure loading user")
                    }
                case .failure(_):
                    print("failure loading full review")
                }
            }
            self.reviews.append(contentsOf: reviews)

            self.nextPage += 1
        case .failure(let error):
            self.setError(error: error.description)
        }
        
        self.loading = false
    }
    
    func hardLoadReviews(auth: Authentication, userCache: UserCache, action: (_: Int) async -> Result<[Review], RequestError>) async {
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
