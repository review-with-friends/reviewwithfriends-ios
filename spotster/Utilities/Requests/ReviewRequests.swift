//
//  ReviewRequests.swift
//  spotster
//
//  Created by Colton Lathrop on 12/13/22.
//

import Foundation

let REVIEW_V1_ENDPOINT = "https://spotster.spacedoglabs.com/api/v1/review"

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
    
    let result = await spotster.requestWithRetry(request: request)
    
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

func getReviewsForUser(token: String, userId: String, page: Int) async -> Result<[Review], RequestError> {
    var url: URL
    if let url_temp = URL(string: REVIEW_V1_ENDPOINT + "/reviews_from_user") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed created url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "user_id", value: userId)])
    url.append(queryItems:  [URLQueryItem(name: "page", value: "\(page)")])
    
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
            let reviews = try decoder.decode([Review].self, from: data)
            return .success(reviews)
        } catch (let error) {
            return .failure(.DeserializationError(message: error.localizedDescription))
        }
    case .failure(let error):
        return .failure(error)
    }
}

func getLatestReviews(token: String, page: Int) async -> Result<[Review], RequestError> {
    var url: URL
    if let url_temp = URL(string: REVIEW_V1_ENDPOINT + "/latest") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed created url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "page", value: "\(page)")])
    
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
            let reviews = try decoder.decode([Review].self, from: data)
            return .success(reviews)
        } catch (let error) {
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
    
    let result = await spotster.requestWithRetry(request: request)
    
    switch result {
    case .success(let data):
        do {
            let decoder =  JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .millisecondsSince1970
            let fullReview = try decoder.decode(FullReview.self, from: data)
            return .success(fullReview)
        } catch (let error) {
            return .failure(.DeserializationError(message: error.localizedDescription))
        }
    case .failure(let error):
        return .failure(error)
    }
}

func deleteReview(token: String, reviewId: String) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: REVIEW_V1_ENDPOINT + "/remove_review") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed created url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "review_id", value: reviewId)])
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    
    let result = await spotster.requestWithRetry(request: request)
    
    switch result {
    case .success(_):
        return .success(())
    case .failure(let error):
        return .failure(error)
    }
}

func createReview(token: String, reviewRequest: CreateReviewRequest) async -> Result<Review, RequestError> {
    var url: URL
    if let url_temp = URL(string: REVIEW_V1_ENDPOINT + "/") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed created url"))
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(token, forHTTPHeaderField: "Authorization")
    do {
        request.httpBody = try JSONEncoder().encode(reviewRequest)
    } catch {
        return .failure(.URLMalformedError(message: "failed to serialize body"))
    }
    
    let result = await spotster.requestWithRetry(request: request)
    
    switch result {
    case .success(let data):
        do {
            let decoder =  JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .millisecondsSince1970
            let review = try decoder.decode(Review.self, from: data)
            return .success(review)
        } catch (let error) {
            return .failure(.DeserializationError(message: error.localizedDescription))
        }
    case .failure(let error):
        return .failure(error)
    }
}

struct CreateReviewRequest: Codable {
    let text: String
    let stars: Int
    let category: String
    let location_name: String
    let latitude: Double
    let longitude: Double
    let is_custom: Bool
}

func getReviewFromBoundary(token: String, boundary: MapBoundary, page: Int) async -> Result<[Review], RequestError> {
    var url: URL
    if let url_temp = URL(string: REVIEW_V1_ENDPOINT + "/reviews_from_bounds") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed created url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "latitude_north", value: "\(boundary.maxY)")])
    url.append(queryItems:  [URLQueryItem(name: "latitude_south", value: "\(boundary.minY)")])
    url.append(queryItems:  [URLQueryItem(name: "longitude_west", value: "\(boundary.minX)")])
    url.append(queryItems:  [URLQueryItem(name: "longitude_east", value: "\(boundary.maxX)")])
    
    url.append(queryItems:  [URLQueryItem(name: "page", value: "\(page)")])
    
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
            let reviews = try decoder.decode([Review].self, from: data)
            return .success(reviews)
        } catch (let error) {
            return .failure(.DeserializationError(message: error.localizedDescription))
        }
    case .failure(let error):
        return .failure(error)
    }
}

func getReviewFromBoundaryWithExclusion(token: String, boundary: MapBoundary, excludedBoundary: MapBoundary, page: Int) async -> Result<[Review], RequestError> {
    var url: URL
    if let url_temp = URL(string: REVIEW_V1_ENDPOINT + "/reviews_from_bounds_exclusions") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed created url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "latitude_north", value: "\(boundary.maxY)")])
    url.append(queryItems:  [URLQueryItem(name: "latitude_south", value: "\(boundary.minY)")])
    url.append(queryItems:  [URLQueryItem(name: "longitude_west", value: "\(boundary.minX)")])
    url.append(queryItems:  [URLQueryItem(name: "longitude_east", value: "\(boundary.maxX)")])
    
    url.append(queryItems:  [URLQueryItem(name: "page", value: "\(page)")])
    
    url.append(queryItems:  [URLQueryItem(name: "latitude_north_e", value: "\(excludedBoundary.maxY)")])
    url.append(queryItems:  [URLQueryItem(name: "latitude_south_e", value: "\(excludedBoundary.minY)")])
    url.append(queryItems:  [URLQueryItem(name: "longitude_west_e", value: "\(excludedBoundary.minX)")])
    url.append(queryItems:  [URLQueryItem(name: "longitude_east_e", value: "\(excludedBoundary.maxX)")])
    
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
            let reviews = try decoder.decode([Review].self, from: data)
            return .success(reviews)
        } catch (let error) {
            return .failure(.DeserializationError(message: error.localizedDescription))
        }
    case .failure(let error):
        return .failure(error)
    }
}
