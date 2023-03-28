//
//  RecoveryGetStartedView.swift
//  app
//
//  Created by Colton Lathrop on 3/13/23.
//

import Foundation
import SwiftUI

struct RecoveryGetStartedView: View {
    @Binding var path: NavigationPath
    
    @Binding var phone: String
    
    @State var pending = false
    
    @State var showError = false
    @State var errorText = ""
    
    @EnvironmentObject var auth: Authentication
    
    func requestEmailCode() async {
        if self.pending == true {
            return
        }
        
        self.pending = true
        self.hideError()
        
        let result: Result<(), RequestError> = await getEmailCode(phone: "1".appending(phone))
        
        switch result {
        case .success():
            self.path.append(RecoveryGetTextCode())
            self.pending = false
        case .failure(let err):
            self.showError(error: err.description)
            self.pending = false
        }
    }
    
    func showError(error: String) {
        showError = true
        errorText = error
    }
    
    func hideError() {
        showError = false
        errorText = ""
    }
    
    var body: some View {
        VStack {
            Text("Update Phone Number").font(.title.bold())
            VStack {
                HStack {
                    Text("How updating your account phone number works:").font(.title3.bold())
                    Spacer()
                }.padding(.vertical)
                HStack {
                    Text("Your account needs to have a recovery email set.").font(.caption)
                    Spacer()
                }.padding(.vertical, 2)
                HStack {
                    Text("You need access to that recovery email.").font(.caption)
                    Spacer()
                }.padding(.vertical, 2)
                HStack {
                    Text("You need access to your new phone number.").font(.caption)
                    Spacer()
                }.padding(.vertical, 2)
                HStack {
                    Text("If you are missing any one of these, email us at support@spacedoglabs.com").font(.caption).foregroundColor(.red)
                    Spacer()
                }.padding(.vertical, 2)
            }.padding()
            Text("Enter your old phone number:").bold()
            PhoneInput(phone: $phone)
            if self.showError {
                Text(self.errorText).foregroundColor(.red)
            }
            
            PrimaryButton(title: "Get Email Code", action: {
                Task {
                    await requestEmailCode()
                }
            }).disabled(phone.count < 10 && self.pending ? true : false)
            
            Spacer()
        }.frame(alignment: .center)
    }
}

func getEmailCode(phone: String) async -> Result<(), RequestError> {
    var url = URL(string: "https://reviewwithfriends.com/auth/recovery_code")!
    url.append(queryItems:  [URLQueryItem(name: "phone", value: phone)])
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
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
        return .success(())
    } else if status <= 499 && status >= 400 {
        return .failure(.BadRequestError(message: content))
    } else {
        return .failure(.InternalServerError(message: content))
    }
}

struct RecoveryGetStartedView_Previews: PreviewProvider {
    static var previews: some View {
        RecoveryGetStartedView(path: .constant(NavigationPath()), phone: .constant("7014910059"))
            .environmentObject(Authentication.initPreview())
            .preferredColorScheme(.dark)
    }
}
