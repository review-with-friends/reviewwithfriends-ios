//
//  ReviewPreviewData.swift
//  spotster
//
//  Created by Colton Lathrop on 12/19/22.
//

import Foundation

func generateReviewListPreviewData() -> [Review] {
    var reviews: [Review] = []
    
    reviews.append(Review(id: "Test1", userId: "TestUser1", created: Date(), picId: nil, category: "Restaurant", text: "Word", stars: 4, locationName: "Taco Bell", latitude: 45.34834, longitude: -120.343434, isCustom: false))
    reviews.append(Review(id: "Test2", userId: "TestUser2", created: Date(), picId: nil, category: "Restaurant", text: "Kinda ass", stars: 2, locationName: "Taco Bell", latitude: 45.34834, longitude: -120.343434, isCustom: false))
    reviews.append(Review(id: "Test3", userId: "TestUser3", created: Date(), picId: nil, category: "Restaurant", text: "spent all night on the toilet - 5/5", stars: 5, locationName: "Taco Bell", latitude: 45.34834, longitude: -120.343434, isCustom: false))
    reviews.append(Review(id: "Test4", userId: "TestUser4", created: Date(), picId: nil, category: "Restaurant", text: "Word", stars: 1, locationName: "Taco Bell", latitude: 45.34834, longitude: -120.343434, isCustom: false))
    reviews.append(Review(id: "Test5", userId: "TestUser4", created: Date(), picId: nil, category: "Restaurant", text: "got into a fight with the cook, never got my nacho fries", stars: 0, locationName: "Taco Bell", latitude: 45.34834, longitude: -120.343434, isCustom: false))
    
    
    return reviews
}

func generateReviewPreviewData() -> Review {
    return Review(id: "Test1", userId: "123", created: Date(), picId: "2341db03-07bd-49d9-94f2-ed2d9d75b0b", category: "Restaurant", text: "Pretty tasty pizza if you ask me. I even got a drink because I really love pizza, sorry andrea I deleted this text and lost it, so here this is.", stars: 4, locationName: "La Jolla Beach San Diego - Parking Center", latitude: 45.34834, longitude: -120.343434, isCustom: false)
}

func generateFullReviewPreviewData() -> FullReview {
    let review = generateReviewPreviewData()
    return FullReview(review: review, likes: [Like(id: "123", created: Date(), userId: "123", reviewId: review.id)], replies: [Reply(id: "1", created: Date(), userId: "123", reviewId: review.id, text: "This is a sample reply! Something something Something something Something something Something something Something something  vSomething something Something somethingSomething somethingSomething somethingv Something something dfgdf"),Reply(id: "2", created: Date().addingTimeInterval(-1000), userId: "123", reviewId: review.id, text: "This is a sample reply! -1000"),Reply(id: "3", created: Date(), userId: "123", reviewId: review.id, text: "This is a sample reply! Something something Something something Something something Something something Something something  vSomething something Something somethingSomething somethingSomething somethingv Something something dfgdf"),Reply(id: "4", created: Date().addingTimeInterval(-459874985), userId: "123", reviewId: review.id, text: "This is a sample reply! -459874985"),Reply(id: "5", created: Date(), userId: "123", reviewId: review.id, text: "This is a sample reply!")], pics: [Pic(id: "123", created: Date(), reviewId: "123", width: 900, height: 1600), Pic(id: "123", created: Date(), reviewId: "123", width: 900, height: 1600), Pic(id: "123", created: Date(), reviewId: "123", width: 900, height: 1600)])
}
