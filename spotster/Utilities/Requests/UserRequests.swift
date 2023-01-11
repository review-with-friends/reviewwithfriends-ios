//
//  UserService.swift
//  spotster
//
//  Created by Colton Lathrop on 12/3/22.
//

import Foundation

let USER_V1_ENDPOINT = "https://spotster.spacedoglabs.com/api/v1/user"

struct UpdateUserRequest : Codable {
    let name: String
    let display_name: String
}

func setNames(token: String, name: String, displayName: String) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: USER_V1_ENDPOINT) {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed created url"))
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(token, forHTTPHeaderField: "Authorization")
    do {
        request.httpBody = try JSONEncoder().encode(UpdateUserRequest(name: name, display_name: displayName))
    } catch {
        return .failure(.URLMalformedError(message: "failed to serialize body"))
    }
    
    let result = await spotster.requestWithRetry(request: request)
    
    switch result {
    case .success(_):
        return .success(())
    case .failure(let error):
        return .failure(error)
    }
}

func getUserById(token: String, userId: String) async -> Result<User, RequestError> {
    var url: URL
    if let url_temp = URL(string: USER_V1_ENDPOINT + "/by_id") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed created url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "id", value: userId)])
    
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
            let reviews = try decoder.decode(User.self, from: data)
            return .success(reviews)
        } catch (let error) {
            print(error)
            return .failure(.DeserializationError(message: error.localizedDescription))
        }
    case .failure(let error):
        return .failure(error)
    }
}

