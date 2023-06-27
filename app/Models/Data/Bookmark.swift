//
//  Bookmark.swift
//  app
//
//  Created by Colton Lathrop on 6/27/23.
//

import Foundation

struct Bookmark : Codable, Identifiable, Equatable, Hashable {
    let id: String
    let userId: String
    let created: Date
    let category: String
    let locationName: String
    let latitude: Double
    let longitude: Double
}
