//
//  ReviewViewData.swift
//  belocal
//
//  Created by Colton Lathrop on 2/9/23.
//

import Foundation

struct ReviewViewData: Identifiable {
    var id: String
    var fullReview: FullReview
    var user: User
}
