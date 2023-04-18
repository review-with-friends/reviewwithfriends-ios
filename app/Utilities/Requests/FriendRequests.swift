//
//  FriendRequests.swift
//  app
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
    
    let result = await app.requestWithRetry(request: request)
    
    switch result {
    case .success(_):
        return .success(())
    case .failure(let error):
        return .failure(error)
    }
}

func acceptFriend(token: String, requestId: String) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: FRIEND_V1_ENDPOINT + "/accept_friend") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed to create url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "request_id", value: requestId)])
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    
    let result = await app.requestWithRetry(request: request)
    
    switch result {
    case .success(_):
        return .success(())
    case .failure(let error):
        return .failure(error)
    }
}

func rejectFriend(token: String, requestId: String) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: FRIEND_V1_ENDPOINT + "/decline_friend") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed to create url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "request_id", value: requestId)])
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    
    let result = await app.requestWithRetry(request: request)
    
    switch result {
    case .success(_):
        return .success(())
    case .failure(let error):
        return .failure(error)
    }
}

func ignoreFriend(token: String, requestId: String) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: FRIEND_V1_ENDPOINT + "/ignore_friend") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed to create url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "request_id", value: requestId)])
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    
    let result = await app.requestWithRetry(request: request)
    
    switch result {
    case .success(_):
        return .success(())
    case .failure(let error):
        return .failure(error)
    }
}

func cancelFriend(token: String, requestId: String) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: FRIEND_V1_ENDPOINT + "/cancel_friend") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed to create url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "request_id", value: requestId)])
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    
    let result = await app.requestWithRetry(request: request)
    
    switch result {
    case .success(_):
        return .success(())
    case .failure(let error):
        return .failure(error)
    }
}

func addFriend(token: String, userId: String) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: FRIEND_V1_ENDPOINT + "/add_friend") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed to create url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "friend_id", value: userId)])
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    
    let result = await app.requestWithRetry(request: request)
    
    switch result {
    case .success(_):
        return .success(())
    case .failure(let error):
        return .failure(error)
    }
}

struct DiscoverFriendsRequest: Codable {
    let numbers: [String]
}

/// Lookup potential friends with a list of phone numbers.
/// Input numbers are expected as: "19999999999"
/// If a number is invalid, the server doesn't care and will remove it
func discoverFriendsWithNumbers(token: String, numbers: [String]) async -> Result<[User], RequestError> {
    var url: URL
    if let url_temp = URL(string: FRIEND_V1_ENDPOINT + "/discover_friends") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed to create url"))
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(token, forHTTPHeaderField: "Authorization")
    
    do {
        let requestObject = DiscoverFriendsRequest(numbers: numbers)
        
        let body = try JSONEncoder().encode(requestObject)
        request.httpBody = body
    } catch {
        return .failure(.URLMalformedError(message: "failed to serialize body"))
    }
    
    let result = await app.requestWithRetry(request: request)
    
    switch result {
    case .success(let data):
        do {
            let decoder =  JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .millisecondsSince1970
            let users = try decoder.decode([User].self, from: data)
            return .success(users)
        } catch (let error) {
            return .failure(.DeserializationError(message: error.localizedDescription))
        }
    case .failure(let error):
        return .failure(error)
    }
}

/// Gets the users you are requestings friend list.
/// Will fail on the backend if you are not friends with this person.
func getUserFriends(token: String, userId: String) async -> Result<[Friend], RequestError> {
    var url: URL
    if let url_temp = URL(string: FRIEND_V1_ENDPOINT + "/user") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed created url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "user_id", value: userId)])
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    
    let result = await app.requestWithRetry(request: request)
    
    switch result {
    case .success(let data):
        do {
            let decoder =  JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .millisecondsSince1970
            
            let userFriends = try decoder.decode([Friend].self, from: data)

            return .success(userFriends)
        } catch (let error) {
            return .failure(.DeserializationError(message: error.localizedDescription))
        }
    case .failure(let error):
        return .failure(error)
    }
}
