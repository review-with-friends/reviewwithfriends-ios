//
//  FullReview.swift
//  bout
//
//  Created by Colton Lathrop on 12/22/22.
//

import Foundation

struct FullReview: Codable {
    var review: Review
    var likes: [Like]
    var replies: [Reply]
}
