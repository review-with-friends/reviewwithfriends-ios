//
//  UniqueLocationCreateReview.swift
//  app
//
//  Created by Colton Lathrop on 1/2/23.
//

import Foundation

struct UniqueLocationCreateReview: Hashable, Codable {
    var locationName: String
    var category: String
    var latitude: Double
    var longitude: Double
}
