//
//  LikeRequests.swift
//  bout
//
//  Created by Colton Lathrop on 12/23/22.
//

import Foundation

let LIKE_V1_ENDPOINT = "https://bout.spacedoglabs.com/api/v1/like"

func likeReview(token: String, reviewId: String) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: LIKE_V1_ENDPOINT) {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed to create url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "review_id", value: reviewId)])
    
    print(url)
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    
    let result = await bout.requestWithRetry(request: request)
    
    switch result {
    case .success(_):
        return .success(())
    case .failure(let error):
        return .failure(error)
    }
}

func unlikeReview(token: String, reviewId: String) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: LIKE_V1_ENDPOINT + "/unlike") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed to create url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "review_id", value: reviewId)])
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    
    let result = await bout.requestWithRetry(request: request)
    
    switch result {
    case .success(_):
        return .success(())
    case .failure(let error):
        return .failure(error)
    }
}
