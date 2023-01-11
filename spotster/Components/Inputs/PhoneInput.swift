//
//  PhoneInputView.swift
//  spotster
//
//  Created by Colton Lathrop on 11/29/22.
//

import Foundation
import SwiftUI

struct PhoneInput: View {
    enum FocusField: Hashable {
        case PhoneEntry
    }
    
    @Binding var phone: String
    
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "phone.fill")
                
                Text("+1")
                    .font(.title3)
                
                TextField("000 000 0000", text: $phone)
                    .font(.title3)
                    .padding(.trailing)
                    .disableAutocorrection(true)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .PhoneEntry)
                    .onAppear {
                        self.focusedField = .PhoneEntry
                    }
                
                Button(action: {
                    self.phone = ""
                }){
                    Image(systemName: "x.circle.fill")
                }.opacity(self.phone.count >= 1 ? 1 : 0)
                    .foregroundColor(.secondary)
                    .animation(.easeInOut(duration: 0.25), value: self.phone.count)
                
                
            }.padding(8).background(.tertiary).cornerRadius(8)
            Text("if its not obvious, we'll text you a verification code to sign you in").font(.caption).foregroundColor(.secondary)
        }.padding()
    }
}
