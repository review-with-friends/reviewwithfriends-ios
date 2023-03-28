//
//  RecoverySubmitCodeView.swift
//  app
//
//  Created by Colton Lathrop on 3/13/23.
//

import Foundation
import SwiftUI

struct RecoverySubmitCodeView: View {
    @Binding var path: NavigationPath
    
    enum FocusField: Hashable {
        case CodeEntry
    }
    
    @Binding var oldPhone: String
    @Binding var newPhone: String
    
    @State var oldPhoneCode: String = ""
    @State var newPhoneCode: String = ""
    
    @State var showError = false
    @State var errorText = ""
    
    @FocusState private var focusedField: FocusField?
    
    @EnvironmentObject var auth: Authentication
    
    func submitCode() async {
        self.hideError()
        
        let signInResult = await submitRecovery(oldPhone: "1".appending(oldPhone), oldPhoneCode: self.oldPhoneCode, newPhone: "1".appending(newPhone), newPhoneCode: self.newPhoneCode)
        
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
            VStack {
                HStack {
                    Text("Code from recovery email:").bold()
                    Spacer()
                }
                HStack {
                    Image(systemName: "number.square")
                    TextField("123456789", text: $oldPhoneCode)
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
            }.padding()
            VStack {
                HStack {
                    Text("Code from text:").bold()
                    Spacer()
                }
                HStack {
                    Image(systemName: "number.square")
                    TextField("123456789", text: $newPhoneCode)
                        .font(.title3)
                        .padding(.trailing)
                        .disableAutocorrection(true)
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                }.padding(8.0).frame(alignment: .center).background(.tertiary).cornerRadius(8.0)
            }.padding()
            if self.showError {
                Text(self.errorText).foregroundColor(.red)
            }
            if (self.oldPhoneCode.count < 9 || self.newPhoneCode.count < 9) {
                DisabledPrimaryButton(title: "Submit Codes")
            } else {
                PrimaryButton(title: "Submit Codes", action: {
                    Task {
                        await submitCode()
                    }
                })
            }
            Spacer()
        }.frame(alignment: .center)
    }
}

func submitRecovery(oldPhone: String, oldPhoneCode: String, newPhone: String, newPhoneCode: String) async ->  Result<String, RequestError> {
    var url = URL(string: "https://spotster.spacedoglabs.com/auth/update_phone")!
    url.append(queryItems:  [URLQueryItem(name: "phone", value: oldPhone),URLQueryItem(name: "new_phone", value: newPhone),URLQueryItem(name: "code", value: oldPhoneCode),URLQueryItem(name: "new_phone_code", value: newPhoneCode)])
    
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

struct RecoverySubmitCodeView_Previews: PreviewProvider {
    static var previews: some View {
        RecoverySubmitCodeView(path: .constant(NavigationPath()), oldPhone: .constant("7014910059"), newPhone: .constant("7014910059"))
            .preferredColorScheme(.dark)
    }
}
