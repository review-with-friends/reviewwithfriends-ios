//
//  ReviewViewData.swift
//  app
//
//  Created by Colton Lathrop on 2/9/23.
//

import Foundation

class ReviewViewData: Identifiable, ObservableObject {
    var id: String
    var fullReview: FullReview
    var user: User
    
    init(id: String, fullReview: FullReview, user: User) {
        self.id = id
        self.fullReview = fullReview
        self.user = user
    }
}
