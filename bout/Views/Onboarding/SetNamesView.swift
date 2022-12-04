//
//  SetNamesView.swift
//  bout
//
//  Created by Colton Lathrop on 11/29/22.
//

import Foundation
import SwiftUI

struct SetNamesView: View {
    @Binding var phase: OnboardingPhase
    @State var name: String = ""
    @State var displayName: String = ""
    @State var pending = false;
    
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var errorDisplay: ErrorDisplay
    
    func validateNames() -> Result<(), NameValidationError> {
        if self.name == "" {
            return .failure(.Invalid(message: "choose a username"))
        } else if self.displayName == "" {
            return .failure(.Invalid(message: "choose a display name"))
        }
        if self.name.count > 26 {
            
        }
        return .success(())
    }
    
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
        
        let result = await bout.setNames(token: authentication.token, name: self.name, displayName: self.displayName)
        
        
        switch result {
        case .success():
            self.phase = .SetProfilePic
            self.pending = false
        case .failure(let err):
            errorDisplay.showError(message: err.description)
            self.pending = false
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            if let user = authentication.user {
                VStack {
                    Text("pick a username").font(.title2).padding()
                    Text("this is how other people will find/add you").font(.caption).foregroundColor(.secondary)
                    Text("letters and numbers only").font(.caption).foregroundColor(.secondary)
                    HStack {
                        Image(systemName: "at.circle.fill")
                        TextField(user.name, text: $name)
                            .font(.title3)
                            .padding(.trailing)
                            .disableAutocorrection(true)
                            .fixedSize()
                        
                    }.padding().frame(alignment: .center).background(.tertiary).cornerRadius(16.0)
                }.padding()
                VStack {
                    Text("pick a display name").font(.title2).padding()
                    Text("this is what people mostly see everywhere").font(.caption).foregroundColor(.secondary)
                    HStack {
                        TextField(user.displayName, text: $displayName)
                            .font(.title3)
                            .padding(.trailing)
                            .disableAutocorrection(true)
                            .fixedSize()
                        
                    }.padding().frame(alignment: .center).background(.tertiary).cornerRadius(16.0)
                }.padding()
                Button(action: {
                    Task {
                        await setNames()
                    }
                }){
                    Text("Submit")
                        .font(.title.bold())
                        .padding()
                }.foregroundColor(.primary)
            } else {
                
            }
            Spacer()
        }
    }
}

struct SetNamesView_Previews: PreviewProvider {
    static var previews: some View {
        SetNamesView(phase: .constant(OnboardingPhase.SetNames)).preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
    }
}
