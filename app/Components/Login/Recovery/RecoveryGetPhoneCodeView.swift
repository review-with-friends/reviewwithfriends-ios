//
//  RecoveryGetPhoneCodeView.swift
//  app
//
//  Created by Colton Lathrop on 3/13/23.
//
//
//  GetCodeView.swift
//  app
//
//  Created by Colton Lathrop on 11/29/22.
//

import Foundation
import SwiftUI

struct RecoveryGetPhoneCodeView: View {
    @Binding var path: NavigationPath
    
    @Binding var phone: String
    
    @State var pending = false
    
    @State var showError = false
    @State var errorText = ""
    
    @EnvironmentObject var auth: Authentication
    
    func requestCode() async {
        if self.pending == true {
            return
        }
        
        self.pending = true
        self.hideError()
        
        let result: Result<(), RequestError> = await getCode(phone: "1".appending(phone))
        
        switch result {
        case .success():
            self.path.append(RecoverySubmitCode())
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
            Spacer()
            Text("Enter your new phone number:").bold()
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

struct RecoveryGetPhoneCodeView_Previews: PreviewProvider {
    static var previews: some View {
        RecoveryGetPhoneCodeView(path: .constant(NavigationPath()), phone: .constant("7014910059"))
            .environmentObject(Authentication.initPreview())
            .preferredColorScheme(.dark)
    }
}
