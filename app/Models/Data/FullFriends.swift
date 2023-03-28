//
//  FullFriends.swift
//  app
//
//  Created by Colton Lathrop on 1/10/23.
//

import Foundation

struct FullFriends: Codable, Hashable, Equatable {
    var friends: [Friend] = []
    var incomingRequests: [FriendRequest] = []
    var outgoingRequests: [FriendRequest] = []
    var ignoredRequests: [FriendRequest] = []
}
