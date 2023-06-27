//
//  BookmarkRequests.swift
//  app
//
//  Created by Colton Lathrop on 6/26/23.
//

import Foundation

let BOOKMARKS_V1_ENDPOINT = "https://api.reviewwithfriends.com/api/v1/bookmark"

func addBookmark(token: String, cache: BookmarkCache, locationName: String, category: String, latitude: Double, longitude: Double) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: BOOKMARKS_V1_ENDPOINT) {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed created url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "location_name", value: locationName)])
    url.append(queryItems:  [URLQueryItem(name: "category", value: category)])
    url.append(queryItems:  [URLQueryItem(name: "latitude", value: String(latitude))])
    url.append(queryItems:  [URLQueryItem(name: "longitude", value: String(longitude))])
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    
    let result = await app.requestWithRetry(request: request)
    
    switch result {
    case .success(_):
        Task {
            await cache.refresh(token: token)
        }
        return .success(())
    case .failure(let error):
        return .failure(error)
    }
}

func removeBookmark(token: String, cache: BookmarkCache, locationName: String, latitude: Double, longitude: Double) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: BOOKMARKS_V1_ENDPOINT + "/remove_bookmark") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed created url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "location_name", value: locationName)])
    url.append(queryItems:  [URLQueryItem(name: "latitude", value: String(latitude))])
    url.append(queryItems:  [URLQueryItem(name: "longitude", value: String(longitude))])
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(token, forHTTPHeaderField: "Authorization")
    
    let result = await app.requestWithRetry(request: request)
    
    switch result {
    case .success(_):
        Task {
            await cache.refresh(token: token)
        }
        return .success(())
    case .failure(let error):
        return .failure(error)
    }
}

func getAllBookmarksForUser(token: String, userId: String) async -> Result<[Bookmark], RequestError> {
    var url: URL
    if let url_temp = URL(string: BOOKMARKS_V1_ENDPOINT + "/all_by_user") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed created url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "user_id", value: userId)])
    
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
            let reviews = try decoder.decode([Bookmark].self, from: data)
            return .success(reviews)
        } catch (let error) {
            return .failure(.DeserializationError(message: error.localizedDescription))
        }
    case .failure(let error):
        return .failure(error)
    }
}
