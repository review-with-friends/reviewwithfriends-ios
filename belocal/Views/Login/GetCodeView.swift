//
//  GetCodeView.swift
//  belocal
//
//  Created by Colton Lathrop on 11/29/22.
//

import Foundation
import SwiftUI

struct GetCodeView: View {
    @Binding var path: NavigationPath
    
    @Binding var phone: String
    
    @State var pending = false
    
    @State var showError = false
    @State var errorText = ""
    
    @EnvironmentObject var auth: Authentication
    
    func requestCode() async {
        if self.phone == "9999999999" {
            await self.signInDemoUser()
            return
        }
        
        if self.pending == true {
            return
        }
        
        self.pending = true
        self.hideError()
        
        let result: Result<(), RequestError> = await getCode(phone: "1".appending(phone))
        
        switch result {
        case .success():
            self.path.append(SubmitCode())
            self.pending = false
        case .failure(let err):
            self.showError(error: err.description)
            self.pending = false
        }
    }
    
    func signInDemoUser() async {
        self.hideError()
        
        let signInResult = await SignInDemo()
        
        switch signInResult {
        case .success(let token):
            let getMeResult = await auth.getMe(incomingToken: token)
            switch getMeResult {
            case .success():
                auth.setCachedToken(incomingToken: token)
            case .failure(let err):
                self.showError(error: err.description)
                break
            }
        case .failure(let err):
            self.showError(error: err.description)
            break
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
            Spacer()
            HStack {
                Text("Let's start with your phone number.").font(.title.bold())
                Spacer()
            }.padding()
            HStack {
                Text("Don't worry, we won't sell it.")
                Spacer()
            }.padding(.horizontal)
            HStack {
                Spacer()
                Button(action: {
                    self.path.append(RecoverGetStarted())
                }) {
                    Text("Get a new phone number?").font(.caption)
                }.padding(4).accentColor(.red)
            }
            PhoneInput(phone: $phone)
            if self.showError {
                Text(self.errorText).foregroundColor(.red)
            }
            
            PrimaryButton(title: "Text Code", action: {
                Task {
                    await requestCode()
                }
            }).disabled(phone.count < 10 && self.pending ? true : false)
            
            Spacer()
        }.frame(alignment: .center)
    }
}

func getCode(phone: String) async -> Result<(), RequestError> {
    var url = URL(string: "https://spotster.spacedoglabs.com/auth/requestcode")!
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

func SignInDemo() async ->  Result<String, RequestError> {
    let url = URL(string: "https://spotster.spacedoglabs.com/auth/signin-demo")!
    
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
        return .success(content)
    } else if status <= 499 && status >= 400 {
        return .failure(.BadRequestError(message: content))
    } else {
        return .failure(.InternalServerError(message: content))
    }
}

struct GetCodeView_Previews: PreviewProvider {
    static var previews: some View {
        GetCodeView(path: .constant(NavigationPath()), phone: .constant("7014910059"))
            .environmentObject(Authentication.initPreview())
            .preferredColorScheme(.dark)
    }
}
