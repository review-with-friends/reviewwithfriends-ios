//
//  SubmitCodeView.swift
//  spotster
//
//  Created by Colton Lathrop on 11/29/22.
//

import Foundation
import SwiftUI

struct SubmitCodeView: View {
    @Binding var path: NavigationPath
    
    enum FocusField: Hashable {
        case CodeEntry
    }

    @Binding var phone: String
    
    @State var code: String = ""
    
    @State var showError = false
    @State var errorText = ""
    
    @FocusState private var focusedField: FocusField?
    
    @EnvironmentObject var auth: Authentication
    
    func submitCode() async {
        self.hideError()
        
        let signInResult = await SignIn(phone: "1".appending(phone), code: self.code)
        
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
            Form {
                VStack {
                    HStack {
                        Image(systemName: "number.square")
                        TextField("123456789", text: $code)
                            .font(.title3)
                            .padding(.trailing)
                            .disableAutocorrection(true)
                            .keyboardType(.numberPad)
                            .textContentType(.oneTimeCode)
                            .focused($focusedField, equals: .CodeEntry)
                            .onAppear {
                                self.focusedField = .CodeEntry
                            }
                    }.padding(8.0).frame(alignment: .center).background(.tertiary).cornerRadius(8.0)
                    Text("if you dont get the code in 30 seconds, go back and try again").font(.caption).foregroundColor(.secondary)
                }
            }
            Button(action: {
                Task {
                    await submitCode()
                }
            }){
                Text("Submit")
                    .font(.title.bold())
                    .padding()
            }.foregroundColor(self.code.count < 9 ? .secondary : .primary).disabled(self.code.count < 9 ? true : false)
            Spacer()
        }.frame(alignment: .center)
    }
}

func SignIn(phone: String, code: String) async ->  Result<String, RequestError> {
    var url = URL(string: "https://spotster.spacedoglabs.com/auth/signin")!
    url.append(queryItems:  [URLQueryItem(name: "phone", value: phone),URLQueryItem(name: "code", value: code)])
    
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

struct SubmitCodeView_Previews: PreviewProvider {
    static var previews: some View {
        SubmitCodeView(path: .constant(NavigationPath()), phone: .constant("7014910059"))
            .preferredColorScheme(.dark)
    }
}
