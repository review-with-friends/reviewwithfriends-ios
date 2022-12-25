//
//  ImageRequests.swift
//  bout
//
//  Created by Colton Lathrop on 12/3/22.
//

import Foundation
import SwiftUI

let PROFILEPIC_V1_ENDPOINT = "https://bout.spacedoglabs.com/api/v1/pic"
let REVIEWPIC_V1_ENDPOINT = "https://bout.spacedoglabs.com/api/v1/review"

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
    
    let result = await bout.requestWithRetry(request: request)
    
    switch result {
    case .success(_):
        return .success(())
    case .failure(let error):
        return .failure(error)
    }
}

func getReviewPic(token: String, reviewId: String) async -> Result<UIImage, RequestError> {
    var url: URL
    if let url_temp = URL(string: REVIEWPIC_V1_ENDPOINT + "/review_pic") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed to create url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "review_id", value: reviewId)])
    
    print(url)
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    
    let result = await bout.requestWithRetry(request: request)
    
    switch result {
    case .success(let data):
        if let image = UIImage(data: data) {
            return .success(image)
        } else {
            return .failure(.DeserializationError(message: "pic data was not an image"))
        }
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
    
    let result = await bout.requestWithRetry(request: request)
    
    switch result {
    case .success(_):
        return .success(())
    case .failure(let error):
        return .failure(error)
    }
}

