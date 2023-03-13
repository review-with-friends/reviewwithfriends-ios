//
//  Like.swift
//  belocal
//
//  Created by Colton Lathrop on 12/22/22.
//

import Foundation

struct Like : Codable, Identifiable, Equatable, Hashable {
    let id: String
    let created: Date
    let userId: String
    let reviewId: String
}
