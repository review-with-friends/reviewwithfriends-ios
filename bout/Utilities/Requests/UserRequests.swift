//
//  UserService.swift
//  bout
//
//  Created by Colton Lathrop on 12/3/22.
//

import Foundation

let USER_V1_ENDPOINT = "https://bout.spacedoglabs.com/api/v1/user"

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
    
    let result = await bout.requestWithRetry(request: request)
    
    switch result {
    case .success(_):
        return .success(())
    case .failure(let error):
        return .failure(error)
    }
}

