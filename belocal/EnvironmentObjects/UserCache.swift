//
//  UserCache.swift
//  belocal
//
//  Created by Colton Lathrop on 12/23/22.
//

import Foundation
import SwiftUI

@MainActor
class UserCache: ObservableObject {
    private let cache = URLCache(memoryCapacity: 36384, diskCapacity: 268435456, diskPath: nil)
    
    func getUserById(token: String, userId: String, ignoreCache: Bool = false) async -> Result<User, RequestError> {
        var url: URL
        if let url_temp = URL(string: USER_V1_ENDPOINT + "/by_id") {
            url = url_temp
        } else {
            return .failure(.NetworkingError(message: "failed created url"))
        }
        
        url.append(queryItems:  [URLQueryItem(name: "id", value: userId)])
        
        if !ignoreCache {
            if let response = cache.cachedResponse(for: URLRequest(url: url)) {
                do {
                    let decoder =  JSONDecoder()
                    
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    decoder.dateDecodingStrategy = .millisecondsSince1970
                    
                    let user = try decoder.decode(User.self, from: response.data)
                    
                    return .success(user)
                } catch (let error) {
                    return .failure(.DeserializationError(message: error.localizedDescription))
                }
            }
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        let result = await belocal.requestWithRetry(request: request)
        
        switch result {
        case .success(let data):
            do {
                let decoder =  JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .millisecondsSince1970
                
                let user = try decoder.decode(User.self, from: data)
                
                let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: ["Cache-Control": "max-age=259000"])!
                let cachedResponse = CachedURLResponse(response: httpResponse as URLResponse, data: data, userInfo: nil, storagePolicy: .allowed)
                
                self.cache.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
                
                return .success(user)
            } catch (let error) {
                return .failure(.DeserializationError(message: error.localizedDescription))
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getProfilePic(token: String, userId: String, ignoreCache: Bool) async -> Result<UIImage, RequestError> {
        var url: URL
        if let url_temp = URL(string: PROFILEPIC_V1_ENDPOINT + "/profile_pic") {
            url = url_temp
        } else {
            return .failure(.NetworkingError(message: "failed to create url"))
        }
        
        url.append(queryItems:  [URLQueryItem(name: "user_id", value: userId)])
        
        if let response = cache.cachedResponse(for: URLRequest(url: url)) {
            if let image = UIImage(data: response.data) {
                return .success(image)
            } else {
                return .failure(.DeserializationError(message: "pic data was not an image"))
            }
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        let result = await belocal.requestWithRetry(request: request)
        
        switch result {
        case .success(let data):
            if let image = UIImage(data: data) {
                let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: ["Cache-Control": "max-age=259000"])!
                let cachedResponse = CachedURLResponse(response: httpResponse as URLResponse, data: data, userInfo: nil, storagePolicy: .allowed)
                self.cache.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
                
                return .success(image)
            } else {
                return .failure(.DeserializationError(message: "pic data was not an image"))
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
