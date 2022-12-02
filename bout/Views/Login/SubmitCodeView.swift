//
//  SubmitCodeView.swift
//  bout
//
//  Created by Colton Lathrop on 11/29/22.
//

import Foundation
import SwiftUI

struct SubmitCodeView: View {
    enum FocusField: Hashable {
        case CodeEntry
    }
    
    @Binding var phase: LoginPhase
    @Binding var phone: String
    
    @State var code: String = ""
    
    @FocusState private var focusedField: FocusField?
    
    @EnvironmentObject var errorDisplay: ErrorDisplay
    @EnvironmentObject var auth: Authentication
    
    func submitCode() async {
        let signInResult = await SignIn(phone: "1".appending(phone), code: self.code)
        switch signInResult {
        case .success(let token):
            let getMeResult = await auth.getMe(incomingToken: token)
            switch getMeResult {
            case .success():
                auth.setCachedToken(incomingToken: token)
            case .failure(let err):
                errorDisplay.showError(message: err.description)
            }
        case .failure(let err):
            errorDisplay.showError(message: err.description)
        }
    }
    
    var body: some View {
        VStack {
            HStack{
                Button(action: {
                    self.phone = ""
                    self.phase = .GetCode
                }){
                    Text("Resend")
                        .font(.caption.bold())
                        .padding()
                }.foregroundColor(.primary).disabled(false)
                Spacer()
            }
            Spacer()
            VStack {
                Text("we just sent you a text...").font(.title2)
                Text("might take a minute...").font(.caption).foregroundColor(.secondary)
            }.padding()
            HStack {
                Image(systemName: "number.square")
                TextField("123456789", text: $code)
                    .font(.title3)
                    .padding(.trailing)
                    .disableAutocorrection(true)
                    .keyboardType(.numberPad)
                    .fixedSize()
                    .textContentType(.oneTimeCode)
                    .focused($focusedField, equals: .CodeEntry)
                    .onAppear {
                        self.focusedField = .CodeEntry
                    }
                    
            }.padding().frame(alignment: .center).background(.tertiary).cornerRadius(16.0)
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
    var url = URL(string: "https://bout.spacedoglabs.com/auth/signin")!
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
        return .failure(.BadRequest(message: content))
    } else {
        return .failure(.InternalServerError(message: content))
    }
}

struct SubmitCodeView_Previews: PreviewProvider {
    static var previews: some View {
        SubmitCodeView(phase: .constant(LoginPhase.SubmitCode), phone: .constant("7014910059")).preferredColorScheme(.dark)
    }
}
