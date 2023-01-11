//
//  SetNamesView.swift
//  spotster
//
//  Created by Colton Lathrop on 11/29/22.
//

import Foundation
import SwiftUI

struct SetNamesView: View {
    /// Username used as an additional unique identifier for users.
    @State var name: String = ""
    /// Display name used to display in most cases within the app. Not unique.
    @State var displayName: String = ""
    /// Tracks if the request has started to prevent double input.
    @State var pending = false
    
    @State var showError = false
    @State var errorText = ""
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var navigationManager: NavigationManager
    
    func moveToNextScreen() {
        self.navigationManager.path.append(SetProfilePic())
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
            if let user = auth.user {
                VStack {
                    Form {
                        HStack {
                            Text("Username")
                            Text("Letters and numbers only.").font(.caption).foregroundColor(.secondary)
                        }
                        HStack {
                            Image(systemName: "at.circle.fill")
                            
                            TextField(user.name, text: $name)
                                .disableAutocorrection(true)
                            
                            Button(action: {
                                self.name = ""
                            }){
                                Image(systemName: "x.circle.fill")
                            }.opacity(self.name.count >= 1 ? 1 : 0)
                                .foregroundColor(.secondary)
                                .animation(.easeInOut(duration: 0.25), value: self.name.count)
                        }.padding(8).frame(alignment: .center).background(.quaternary).cornerRadius(8.0)
                        
                        HStack {
                            Text("Display Name")
                            Text("Any characters or emojis.").font(.caption).foregroundColor(.secondary)
                        }
                        HStack {
                            TextField(user.displayName, text: $displayName)
                                .disableAutocorrection(true)
                            
                            
                            Button(action: {
                                self.displayName = ""
                            }){
                                Image(systemName: "x.circle.fill")
                            }.opacity(self.displayName.count >= 1 ? 1 : 0)
                                .foregroundColor(.secondary)
                                .animation(.easeInOut(duration: 0.25), value: self.displayName.count)
                        }.padding(8).frame(alignment: .center).background(.quaternary).cornerRadius(8)
                        if self.showError {
                            Text(self.errorText).foregroundColor(.red)
                        }
                    }
                }.padding()
                Button(action: {
                    Task {
                        await setNames()
                        let _ = await auth.getMe()
                    }
                }){
                    Text("Save")
                        .font(.title.bold())
                        .padding()
                }.foregroundColor(.primary)
            } else {
                
            }
            
            Spacer()
        }.toolbar {
            Button("Skip for now") {
                moveToNextScreen()
            }
        }.onAppear {
            if let user = auth.user {
                self.name = user.name
                self.displayName = user.displayName
            }
        }
    }
    
    /// Attempts to set both names for the given user.
    func setNames() async {
        let validationResult = self.validateNames()
        switch validationResult {
        case .success():
            break
        case .failure(let err):
            self.showError(error: err.description)
            return
        }
        
        if self.pending == true {
            return
        }
        
        self.pending = true;
        self.hideError()
        
        let result = await spotster.setNames(token: auth.token, name: self.name, displayName: self.displayName)
        
        
        switch result {
        case .success():
            self.navigationManager.path.append(SetProfilePic())
            self.pending = false
        case .failure(let err):
            self.showError(error: err.description)
            self.pending = false
        }
    }
    
    /// Validation for the user input.
    func validateNames() -> Result<(), NameValidationError> {
        if self.name == "" {
            return .failure(.Invalid(message: "choose a username"))
        } else if self.displayName == "" {
            return .failure(.Invalid(message: "choose a display name"))
        }
        
        if self.name.count > 26 {
            return .failure(.Invalid(message: "username too long"))
        } else if self.name.count < 4 {
            return .failure(.Invalid(message: "username too short"))
        }
        
        if self.displayName.count > 26 {
            return .failure(.Invalid(message: "display name too long"))
        } else if self.displayName.count < 4 {
            return .failure(.Invalid(message: "username too short"))
        }
        return .success(())
    }
}

struct SetNamesView_Previews: PreviewProvider {
    static var previews: some View {
        SetNamesView().preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
    }
}
