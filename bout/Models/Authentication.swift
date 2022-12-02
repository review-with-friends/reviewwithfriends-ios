//
//  Authentication.swift
//  bout
//
//  Created by Colton Lathrop on 11/29/22.
//

import SwiftUI

let NO_TOKEN = "<NOTOKEN>"
let AUTH_TOKEN_KEY = "AuthenticationToken"

@MainActor
class Authentication: ObservableObject {
    @Published var authenticated: Bool
    @Published var token: String
    @Published var user: User?
    
    init(){
        let token = Authentication.getCachedToken()
        
        if (token == NO_TOKEN){
            self.authenticated = false
        } else {
            self.authenticated = true
        }
        
        self.token = token
    }
    
    static func getCachedToken() -> String {
        let value = AppStorage.init(wrappedValue: NO_TOKEN, AUTH_TOKEN_KEY)
        return value.wrappedValue
    }
    
    func setCachedToken(incomingToken: String) {
        var value = AppStorage.init(wrappedValue: NO_TOKEN, AUTH_TOKEN_KEY)
        value.wrappedValue = incomingToken
        value.update()
        self.token = incomingToken
        self.authenticated = true
    }
    
    func getMe(incomingToken: String) async -> Result<(), RequestError> {
        let url = URL(string: "https://bout.spacedoglabs.com/api/v1/user/me")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue(incomingToken, forHTTPHeaderField: "Authorization")
        
        var data: Data
        var response: HTTPURLResponse
        var content: String
        
        do {
            var tempResponse: URLResponse
            (data, tempResponse) = try await URLSession.shared.data(for: request)
            response = (tempResponse as? HTTPURLResponse)!
            content = String(data: data, encoding: .utf8)!
        } catch {
            return .failure(.NetworkingError(message: "failed due to networking issues"))
        }
        
        let status = response.statusCode
        
        if status == 200 {
            do {
                let decoder =  JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .millisecondsSince1970
                self.user = try decoder.decode(User.self, from: data)
                return .success(())
            } catch let error {
                print(error)
                return .failure(.DeserializationError(message: "failed to deserialize response"))
            }
        } else if status <= 499 && status >= 400 {
            return .failure(.BadRequest(message: content))
        } else {
            return .failure(.InternalServerError(message: content))
        }
    }
    
    func logout() {
        var value = AppStorage.init(wrappedValue: NO_TOKEN, AUTH_TOKEN_KEY)
        value.wrappedValue = NO_TOKEN
        value.update()
        self.token = NO_TOKEN
        self.authenticated = false
    }
}
