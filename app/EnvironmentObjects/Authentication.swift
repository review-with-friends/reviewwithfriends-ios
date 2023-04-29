//
//  Authentication.swift
//  app
//
//  Created by Colton Lathrop on 11/29/22.
//

import SwiftUI

let NO_TOKEN = "<NOTOKEN>"
let AUTH_TOKEN_KEY = "AuthenticationToken"
let ONBOARDING_KEY = "Onboarding_1"

@MainActor
class Authentication: ObservableObject {
    @Published var authenticated: Bool
    @Published var token: String
    @Published var user: User?
    @Published var onboarded: Bool
    
    init(){
        let token = Authentication.getCachedToken()
        self.onboarded = Authentication.getCachedOnboarding()
        
        if (token == NO_TOKEN){
            self.authenticated = false
        } else {
            self.authenticated = true
        }
        
        self.token = token
    }
    
    static func initPreview() -> Authentication
    {
        let auth = Authentication()
        auth.user = User(id: "123", name: "newuser123", displayName: "newuser123", created: Date.now, picId: "default", recovery: false, picUrl: "")
        auth.authenticated = true
        auth.token = "wow much token"
        return auth
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
    
    static func getCachedOnboarding() -> Bool {
        let value = AppStorage.init(wrappedValue: false, ONBOARDING_KEY)
        return value.wrappedValue
    }
    
    func setCachedOnboarding() {
        var value = AppStorage.init(wrappedValue: false, ONBOARDING_KEY)
        value.wrappedValue = true
        value.update()
        self.onboarded = true
    }
    
    func resetCachedOnboarding() {
        var value = AppStorage.init(wrappedValue: false, ONBOARDING_KEY)
        value.wrappedValue = false
        value.update()
        self.onboarded = false
    }
    
    func getMe(incomingToken: String) async -> Result<(), RequestError> {
        let url = URL(string: "https://api.reviewwithfriends.com/api/v1/user/me")!
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
            } catch {
                return .failure(.DeserializationError(message: "failed to deserialize response"))
            }
        } else if status <= 499 && status >= 400 {
            return .failure(.BadRequestError(message: content))
        } else {
            return .failure(.InternalServerError(message: content))
        }
    }
    
    func getMe() async -> Result<(), RequestError> {
        return await self.getMe(incomingToken: self.token)
    }
    
    func logout() {
        var value = AppStorage.init(wrappedValue: NO_TOKEN, AUTH_TOKEN_KEY)
        value.wrappedValue = NO_TOKEN
        value.update()
        self.token = NO_TOKEN
        self.authenticated = false
    }
}
