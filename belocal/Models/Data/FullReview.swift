//
//  FullReview.swift
//  belocal
//
//  Created by Colton Lathrop on 12/22/22.
//

import Foundation

struct FullReview: Codable, Hashable, Equatable {
    var review: Review
    var likes: [Like]
    var replies: [Reply]
    var pics: [Pic]
}
