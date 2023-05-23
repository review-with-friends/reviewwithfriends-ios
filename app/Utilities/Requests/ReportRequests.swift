//
//  ReportRequests.swift
//  app
//
//  Created by Colton Lathrop on 4/17/23.
//

import Foundation

let REPORT_V1_ENDPOINT = "https://api.reviewwithfriends.com/api/v1/report"

func reportUserById(token: String, userId: String) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: REPORT_V1_ENDPOINT + "/user") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed to create url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "user_id", value: userId)])
    
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

struct BugRequest: Codable {
    var title: String
    var description: String
}

func reportBug(token: String, title: String, description: String) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: REPORT_V1_ENDPOINT + "/bug") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed to create url"))
    }
    
    let requestBody = BugRequest(title: title, description: description)
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        request.httpBody = try JSONEncoder().encode(requestBody)
    } catch {
        return .failure(.URLMalformedError(message: "failed to serialize body"))
    }
    
    let result = await app.requestWithRetry(request: request)
    
    switch result {
    case .success(_):
        return .success(())
    case .failure(let error):
        return .failure(error)
    }
}
