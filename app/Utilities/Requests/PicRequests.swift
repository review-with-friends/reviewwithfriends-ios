//
//  ImageRequests.swift
//  app
//
//  Created by Colton Lathrop on 12/3/22.
//

import Foundation
import SwiftUI

let PROFILEPIC_V1_ENDPOINT = "https://api.reviewwithfriends.com/api/v1/pic"
let REVIEWPIC_V1_ENDPOINT = "https://api.reviewwithfriends.com/api/v1/review"

func addProfilePic(token: String, data: Data) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: PROFILEPIC_V1_ENDPOINT + "/profile_pic") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed to create url"))
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    request.httpBody = data
    
    let result = await app.requestWithRetry(request: request)
    
    switch result {
    case .success(_):
        return .success(())
    case .failure(let error):
        return .failure(error)
    }
}

func addReviewPic(token: String, reviewId: String, data: Data) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: REVIEWPIC_V1_ENDPOINT + "/review_pic") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed to create url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "review_id", value: reviewId)])
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    request.httpBody = data
    
    let result = await app.requestWithRetry(request: request)
    
    switch result {
    case .success(_):
        return .success(())
    case .failure(let error):
        return .failure(error)
    }
}

func removeReviewPic(token: String, picId: String, reviewId: String) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: REVIEWPIC_V1_ENDPOINT + "/remove_review_pic") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed to create url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "review_id", value: reviewId)])
    url.append(queryItems:  [URLQueryItem(name: "pic_id", value: picId)])
    
    
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

