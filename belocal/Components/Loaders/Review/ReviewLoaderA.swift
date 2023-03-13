//
//  ReviewLoaderA.swift
//  belocal
//
//  Created by Colton Lathrop on 2/9/23.
//

import Foundation
import SwiftUI

struct ReviewLoaderA: View {
    @Binding var path: NavigationPath
    
    @State var review: ReviewViewData
    
    var showListItem: Bool
    var showLocation = true
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var userCache: UserCache
    
    func loadFullReview() async -> Void {
        let fullReviewResult = await getFullReviewById(token: auth.token, reviewId: review.id)
        
        switch fullReviewResult {
        case .success(let fullReview):
            self.review.fullReview = fullReview
        case .failure(_):
            return
        }
    }
    
    var body: some View {
        HStack {
            if showListItem {
                ReviewListItem(path: self.$path, reloadCallback: self.loadFullReview, user: self.review.user, fullReview: self.review.fullReview, showLocation: showLocation)
            } else {
                ReviewView(path: self.$path, reloadCallback: self.loadFullReview, user: self.review.user, fullReview: self.review.fullReview)
            }
        }
    }
}
