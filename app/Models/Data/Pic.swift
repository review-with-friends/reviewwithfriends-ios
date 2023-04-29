//
//  Pic.swift
//  app
//
//  Created by Colton Lathrop on 1/17/23.
//

import Foundation

struct Pic : Codable, Identifiable, Equatable, Hashable {
    let id: String
    let created: Date
    let reviewId: String
    let width: Int
    let height: Int
    let url: String
}
