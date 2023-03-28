//
//  SetupRecoveryEmail.swift
//  app
//
//  Created by Colton Lathrop on 3/13/23.
//

import Foundation
import SwiftUI

struct SetupRecoveryEmail: View {
    
    @State private var isShowingSheet = false
    
    var body: some View {
        Button(action: {
            self.isShowingSheet = true
        }) {
            Text("Setup Recovery Email")
        }.accentColor(.red)
            .sheet(isPresented: $isShowingSheet,
                   onDismiss: {}) {
                SetupRecoveryEmailSheet(isShowing: $isShowingSheet)
            }
    }
}

struct SetupRecoveryEmailSheet: View {
    @Binding var isShowing: Bool
    @State var email = ""
    
    @State var showError = false
    @State var errorText = ""
    
    @FocusState private var focusedField: FocusField?
    
    @EnvironmentObject var auth: Authentication
    
    enum FocusField: Hashable {
        case EmailEntry
    }
    
    func submitEmail() async {
        self.hideError()
        
        let signInResult = await app.setRecoveryEmail(token: auth.token, email: self.email)
        
        switch signInResult {
        case .success():
            let getMeResult = await auth.getMe()
            switch getMeResult {
            case .success():
                self.isShowing = false
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
            HStack {
                Text("Setup a Recovery Email").font(.title.bold())
                Spacer()
            }.padding(.vertical)
            HStack {
                Text("Your email is only used for recovering your account if you get a new phone number.")
                Spacer()
            }.padding(.vertical, 4)
            HStack {
                Text("We won't send you advertisements or sell it to anyone.")
                Spacer()
            }.padding(.vertical, 4)
            HStack {
                Text("Try out the 'Hide My Email' option, we actually prefer you use it! 🤫")
                Spacer()
            }.padding(.vertical, 4)
            HStack {
                Image(systemName: "at.circle.fill")
                TextField("support@spacedoglabs.com", text: $email)
                    .font(.title3)
                    .padding(.trailing)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .focused($focusedField, equals: .EmailEntry)
                    .onAppear {
                        self.focusedField = .EmailEntry
                    }
            }.padding(8.0).frame(alignment: .center).background(.tertiary).cornerRadius(8.0)
            if self.showError {
                Text(self.errorText).foregroundColor(.red)
            }
            PrimaryButton(title: "Set Email", action: {
                Task {
                    await self.submitEmail()
                }
            })
            Spacer()
        }.padding()
    }
}

struct SetupRecoveryEmail_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            SetupRecoveryEmailSheet(isShowing: .constant(true))
        }.preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
    }
}

