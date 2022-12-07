//
//  ImageRequests.swift
//  bout
//
//  Created by Colton Lathrop on 12/3/22.
//

import Foundation
import SwiftUI

let PIC_V1_ENDPOINT = "https://bout.spacedoglabs.com/api/v1/pic"

func getProfilePic(token: String, userId: String) async -> Result<UIImage, RequestError> {
    var url: URL
    if let url_temp = URL(string: PIC_V1_ENDPOINT + "/profile_pic") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed created url"))
    }
    
    url.append(queryItems:  [URLQueryItem(name: "user_id", value: userId)])
    
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

func addProfilePic(token: String, data: Data) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: PIC_V1_ENDPOINT + "/profile_pic") {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed created url"))
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
