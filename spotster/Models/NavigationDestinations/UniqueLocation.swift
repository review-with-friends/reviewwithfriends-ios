//
//  UniqueLocation.swift
//  spotster
//
//  Created by Colton Lathrop on 12/25/22.
//

import Foundation

struct UniqueLocation: Hashable, Codable {
    var locationName: String
    var category: String
    var latitude: Double
    var longitude: Double
}
