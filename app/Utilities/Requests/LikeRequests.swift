//
//  LikeRequests.swift
//  app
//
//  Created by Colton Lathrop on 12/23/22.
//

import Foundation

let LIKE_V1_ENDPOINT = "https://api.reviewwithfriends.com/api/v1/like"

func likeReview(token: String, reviewId: String) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: LIKE_V1_ENDPOINT) {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed to create url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "review_id", value: reviewId)])
    
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
    
    let result = await app.requestWithRetry(request: request)
    
    switch result {
    case .success(_):
        return .success(())
    case .failure(let error):
        return .failure(error)
    }
}

func getLikedReviews(token: String, page: Int) async -> Result<[Review], RequestError> {
    var url: URL
    if let url_temp = URL(string: LIKE_V1_ENDPOINT + "/current") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed created url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "page", value: "\(page)")])
    
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
            let reviews = try decoder.decode([Review].self, from: data)
            return .success(reviews)
        } catch (let error) {
            return .failure(.DeserializationError(message: error.localizedDescription))
        }
    case .failure(let error):
        return .failure(error)
    }
}

func getLikedFullReviews(token: String, page: Int) async -> Result<[FullReview], RequestError> {
    var url: URL
    if let url_temp = URL(string: LIKE_V1_ENDPOINT + "/current_full") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed created url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "page", value: "\(page)")])
    
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
            let reviews = try decoder.decode([FullReview].self, from: data)
            return .success(reviews)
        } catch (let error) {
            return .failure(.DeserializationError(message: error.localizedDescription))
        }
    case .failure(let error):
        return .failure(error)
    }
}
