//
//  FriendsCache.swift
//  spotster
//
//  Created by Colton Lathrop on 1/6/23.
//

import Foundation
import SwiftUI

let FRIEND_V1_ENDPOINT = "https://spotster.spacedoglabs.com/api/v1/friends"

@MainActor
class FriendsCache: ObservableObject {
    @Published var fullFriends: FullFriends = FullFriends()
    
    func refreshFriendsCache(token: String) async -> Result<(), RequestError> {
        var url: URL
        if let url_temp = URL(string: FRIEND_V1_ENDPOINT + "/full_friends") {
            url = url_temp
        } else {
            return .failure(.NetworkingError(message: "failed created url"))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        let result = await spotster.requestWithRetry(request: request)
        
        switch result {
        case .success(let data):
            do {
                let decoder =  JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .millisecondsSince1970
                
                self.fullFriends = try decoder.decode(FullFriends.self, from: data)
                
                return .success(())
            } catch (let error) {
                return .failure(.DeserializationError(message: error.localizedDescription))
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    static func generateDummyData() -> FriendsCache {
        let friendsCache = FriendsCache()
        
        friendsCache.fullFriends.incomingRequests = [FriendRequest(id: "123", created: Date(), userId: "123", friendId: "456"),FriendRequest(id: "123", created: Date(), userId: "123", friendId: "456"),FriendRequest(id: "123", created: Date(), userId: "123", friendId: "456")]
        
        friendsCache.fullFriends.outgoingRequests = [FriendRequest(id: "123", created: Date(), userId: "123", friendId: "456"),FriendRequest(id: "123", created: Date(), userId: "123", friendId: "456"),FriendRequest(id: "123", created: Date(), userId: "123", friendId: "456")]
        
        friendsCache.fullFriends.ignoredRequests = [FriendRequest(id: "123", created: Date(), userId: "123", friendId: "456"),FriendRequest(id: "123", created: Date(), userId: "123", friendId: "456"),FriendRequest(id: "123", created: Date(), userId: "123", friendId: "456")]
        
        friendsCache.fullFriends.friends = [Friend(id: "123", created: Date(), userId: "123", friendId: "456"), Friend(id: "123", created: Date(), userId: "123", friendId: "456"), Friend(id: "123", created: Date(), userId: "123", friendId: "456")]
        
        return friendsCache
    }
}
