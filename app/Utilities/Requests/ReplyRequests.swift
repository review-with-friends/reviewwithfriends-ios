//
//  ReplyRequests.swift
//  app
//
//  Created by Colton Lathrop on 1/5/23.
//

import Foundation

let REPLY_V1_ENDPOINT = "https://api.reviewwithfriends.com/api/v1/reply"

struct AddReplyRequest: Codable {
    var text: String
    var review_id: String
    var reply_to_id: String?
}

func addReplyToReview(token: String, reviewId: String, text: String, replyTo: String?) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: REPLY_V1_ENDPOINT) {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed created url"))
    }
    
    let requestBody = AddReplyRequest(text: text, review_id: reviewId, reply_to_id: replyTo)
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(token, forHTTPHeaderField: "Authorization")
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

func removeReplyFromReview(token: String, reviewId: String, replyId: String) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: REPLY_V1_ENDPOINT + "/remove"){
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed created url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "review_id", value: reviewId)])
    url.append(queryItems:  [URLQueryItem(name: "reply_id", value: replyId)])

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
