//
//  FriendsList.swift
//  spotster
//
//  Created by Colton Lathrop on 1/10/23.
//

import Foundation

struct FriendsListDestination: Hashable {
    var view: FriendsListType
}

enum FriendsListType {
    case Friends
    case Incoming
    case Outgoing
    case Ignored
    case Search
}
