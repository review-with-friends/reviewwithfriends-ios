//
//  Notification.swift
//  app
//
//  Created by Colton Lathrop on 1/31/23.
//

import Foundation

struct UserNotification : Codable, Identifiable, Equatable, Hashable {
    let id: String
    let created: Date
    let reviewUserId: String
    let userId: String
    let reviewId: String
    let actionType: Int
    let reviewLocation: String
}
