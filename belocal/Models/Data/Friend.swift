//
//  Friend.swift
//  belocal
//
//  Created by Colton Lathrop on 1/6/23.
//

import Foundation

struct Friend : Codable, Identifiable, Hashable, Equatable {
    let id: String
    let created: Date
    
    /// Creator of friend request.
    let userId: String
    
    /// Receiver of friend request.
    let friendId: String
}
