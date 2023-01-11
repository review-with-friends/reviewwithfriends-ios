//
//  FriendRequests.swift
//  spotster
//
//  Created by Colton Lathrop on 1/10/23.
//

import Foundation

func removeFriend(token: String, friendId: String) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: FRIEND_V1_ENDPOINT + "/remove") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed to create url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "friend_id", value: friendId)])
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    
    let result = await spotster.requestWithRetry(request: request)
    
    switch result {
    case .success(_):
        return .success(())
    case .failure(let error):
        return .failure(error)
    }
}

func acceptFriend(token: String, friendId: String) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: FRIEND_V1_ENDPOINT + "/remove") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed to create url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "friend_id", value: friendId)])
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    
    let result = await spotster.requestWithRetry(request: request)
    
    switch result {
    case .success(_):
        return .success(())
    case .failure(let error):
        return .failure(error)
    }
}

func rejectFriend(token: String, friendId: String) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: FRIEND_V1_ENDPOINT + "/remove") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed to create url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "friend_id", value: friendId)])
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    
    let result = await spotster.requestWithRetry(request: request)
    
    switch result {
    case .success(_):
        return .success(())
    case .failure(let error):
        return .failure(error)
    }
}

func ignoreFriend(token: String, friendId: String) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: FRIEND_V1_ENDPOINT + "/remove") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed to create url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "friend_id", value: friendId)])
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    
    let result = await spotster.requestWithRetry(request: request)
    
    switch result {
    case .success(_):
        return .success(())
    case .failure(let error):
        return .failure(error)
    }
}
