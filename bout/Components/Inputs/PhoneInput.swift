//
//  PhoneInputView.swift
//  bout
//
//  Created by Colton Lathrop on 11/29/22.
//

import Foundation
import SwiftUI

struct PhoneInput: View {
    @Binding var phone: String
    
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
                
                Button(action: {
                    self.phone = ""
                }){
                    Image(systemName: "x.circle.fill")
                }.opacity(self.phone.count >= 1 ? 1 : 0)
                    .foregroundColor(.secondary)
                    .animation(.easeInOut(duration: 0.25), value: self.phone.count)
                
                
            }.padding().frame(alignment: .center).background(.tertiary).cornerRadius(16.0)
            Text("if its not obvious, we'll text you a verification code").font(.caption).foregroundColor(.secondary)
        }.padding()
    }
}
