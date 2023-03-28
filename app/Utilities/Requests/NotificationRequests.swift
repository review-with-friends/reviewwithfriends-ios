//
//  NotificationRequests.swift
//  app
//
//  Created by Colton Lathrop on 1/31/23.
//

import Foundation

let NOTIFICATION_V1_ENDPOINT = "https://reviewwithfriends.com/api/v1/notification"

func getNotifications(token: String) async -> Result<[UserNotification], RequestError> {
    var url: URL
    if let url_temp = URL(string: NOTIFICATION_V1_ENDPOINT) {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed created url"))
    }
    
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
            let notifications = try decoder.decode([UserNotification].self, from: data)
            return .success(notifications)
        } catch (let error) {
            return .failure(.DeserializationError(message: error.localizedDescription))
        }
    case .failure(let error):
        return .failure(error)
    }
}

func confirmNotifications(token: String) async -> Result<(), RequestError> {
    var url: URL
    if let url_temp = URL(string: NOTIFICATION_V1_ENDPOINT) {
        url = url_temp
    } else {
        return .failure(.NetworkingError(message: "failed created url"))
    }
    
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

