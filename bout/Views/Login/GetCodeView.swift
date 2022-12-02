//
//  GetCodeView.swift
//  bout
//
//  Created by Colton Lathrop on 11/29/22.
//

import Foundation
import SwiftUI

struct GetCodeView: View {
    @Binding var phase: LoginPhase
    @Binding var phone: String
    
    @EnvironmentObject var errorDisplay: ErrorDisplay
    
    func requestCode() async {
        errorDisplay.closeError()

        let result: Result<(), RequestError> = await getCode(phone: "1".appending(phone))
        
        switch result {
        case .success():
            self.phase = .SubmitCode
        case .failure(let err):
            errorDisplay.showError(message: err.description)
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("lets get you signed in...")
                .font(.title)
                .padding()
            
            PhoneInputView(phone: $phone)
            
            Button(action: {
                Task {
                    await requestCode()
                }
            }){
                Text("Get Code")
                    .font(.title.bold())
                    .padding()
            }.foregroundColor(phone.count < 10 ? .secondary : .primary)
                .cornerRadius(16.0)
                .disabled(phone.count < 10 ? true : false)
                .animation(.easeInOut(duration: 0.25), value: self.phone.count)
            
            
            Spacer()
        }.frame(alignment: .center)
    }
}

func getCode(phone: String) async -> Result<(), RequestError> {
    var url = URL(string: "https://bout.spacedoglabs.com/auth/requestcode")!
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
        return .failure(.BadRequest(message: content))
    } else {
        return .failure(.InternalServerError(message: content))
    }
}

struct GetCodeView_Previews: PreviewProvider {
    static var previews: some View {
        GetCodeView(phase: .constant(LoginPhase.GetCode), phone: .constant("7014910059")).preferredColorScheme(.dark)
    }
}
