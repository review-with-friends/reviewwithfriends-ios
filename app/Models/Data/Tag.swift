//
//  Tag.swift
//  app
//
//  Created by Colton Lathrop on 7/14/23.
//

import Foundation

public struct Tag : Codable, Identifiable, Equatable, Hashable {
    public let id: String
    public let created: Date
    public let reviewId: String
    public let userId: String
    public let picId: String
    public let x: Double
    public let y: Double
}
