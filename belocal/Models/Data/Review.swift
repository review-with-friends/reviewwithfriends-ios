//
//  Review.swift
//  belocal
//
//  Created by Colton Lathrop on 12/13/22.
//

import Foundation

struct Review : Codable, Identifiable, Equatable, Hashable {
    let id: String
    let userId: String
    let created: Date
    let picId: String?
    let category: String
    let text: String
    let stars: Int
    let locationName: String
    let latitude: Double
    let longitude: Double
    let isCustom: Bool
}
