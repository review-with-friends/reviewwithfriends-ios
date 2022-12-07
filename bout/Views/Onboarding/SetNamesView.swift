//
//  SetNamesView.swift
//  bout
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
    @State var pending = false;
    
    @Binding var phase: OnboardingPhase
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var errorDisplay: ErrorDisplay
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                
                Button(action: {
                    withAnimation(.spring().speed(2.0)){
                        self.phase = .SetProfilePic
                    }
                }){
                    Text("Skip")
                        .font(.caption.bold())
                        .padding()
                }.foregroundColor(.primary).disabled(false)
            }
            if let user = auth.user {
                VStack {
                    Text("Pick a username").font(.title2).padding()
                    
                    Text("Letters and numbers only.").font(.caption).foregroundColor(.secondary)
                    
                    HStack {
                        Image(systemName: "at.circle.fill")
                        
                        TextField(user.name, text: $name)
                            .font(.title3)
                            .padding(.trailing)
                            .disableAutocorrection(true)
                            .fixedSize()
                        
                        Button(action: {
                            self.name = ""
                        }){
                            Image(systemName: "x.circle.fill")
                        }.opacity(self.name.count >= 1 ? 1 : 0)
                            .foregroundColor(.secondary)
                            .animation(.easeInOut(duration: 0.25), value: self.name.count)
                        
                    }.padding().frame(alignment: .center).background(.tertiary).cornerRadius(16.0)
                }.padding()
                VStack {
                    Text("Pick a display name").font(.title2).padding()
                    
                    HStack {
                        TextField(user.displayName, text: $displayName)
                            .font(.title3)
                            .padding(.trailing)
                            .disableAutocorrection(true)
                            .fixedSize()
                        
                        Button(action: {
                            self.displayName = ""
                        }){
                            Image(systemName: "x.circle.fill")
                        }.opacity(self.displayName.count >= 1 ? 1 : 0)
                            .foregroundColor(.secondary)
                            .animation(.easeInOut(duration: 0.25), value: self.displayName.count)
                        
                    }.padding().frame(alignment: .center).background(.tertiary).cornerRadius(16.0)
                }.padding()
                Button(action: {
                    Task {
                        await setNames()
                        let _ = await auth.getMe()
                    }
                }){
                    Text("Submit")
                        .font(.title.bold())
                        .padding()
                }.foregroundColor(.primary)
            } else {
                
            }
            
            Spacer()
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
        case .failure(let error):
            errorDisplay.showError(message: error.description)
            return
        }
        
        if self.pending == true {
            return
        }
        
        self.pending = true;
        errorDisplay.closeError()
        
        let result = await bout.setNames(token: auth.token, name: self.name, displayName: self.displayName)
        
        
        switch result {
        case .success():
            self.phase = .SetProfilePic
            self.pending = false
        case .failure(let err):
            errorDisplay.showError(message: err.description)
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
        SetNamesView(phase: .constant(OnboardingPhase.SetNames)).preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
    }
}
