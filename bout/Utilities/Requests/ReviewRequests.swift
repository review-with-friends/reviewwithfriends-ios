//
//  ReviewRequests.swift
//  bout
//
//  Created by Colton Lathrop on 12/13/22.
//

import Foundation

let REVIEW_V1_ENDPOINT = "https://bout.spacedoglabs.com/api/v1/review"

func getReviewsForLocation(token: String, location_name: String, latitude: Double, longitude: Double) async -> Result<[Review], RequestError> {
    var url: URL
    if let url_temp = URL(string: REVIEW_V1_ENDPOINT + "/reviews_from_loc") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed created url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "name", value: location_name)])
    url.append(queryItems:  [URLQueryItem(name: "latitude", value: String(latitude))])
    url.append(queryItems:  [URLQueryItem(name: "longitude", value: String(longitude))])
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    
    let result = await bout.requestWithRetry(request: request)
    
    switch result {
    case .success(let data):
        do {
            let decoder =  JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .millisecondsSince1970
            let reviews = try decoder.decode([Review].self, from: data)
            return .success(reviews)
        } catch (let error) {
            print(error)
            return .failure(.DeserializationError(message: error.localizedDescription))
        }
    case .failure(let error):
        return .failure(error)
    }
}

func getFullReviewById(token: String, reviewId: String) async -> Result<FullReview, RequestError> {
    var url: URL
    if let url_temp = URL(string: REVIEW_V1_ENDPOINT + "/review_by_id") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed created url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "review_id", value: reviewId)])
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    
    let result = await bout.requestWithRetry(request: request)
    
    switch result {
    case .success(let data):
        do {
            let decoder =  JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .millisecondsSince1970
            let fullReview = try decoder.decode(FullReview.self, from: data)
            return .success(fullReview)
        } catch (let error) {
            print(error)
            return .failure(.DeserializationError(message: error.localizedDescription))
        }
    case .failure(let error):
        return .failure(error)
    }
}
