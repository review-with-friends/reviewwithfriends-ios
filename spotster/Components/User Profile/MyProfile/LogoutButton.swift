//
//  LogoutButton.swift
//  spotster
//
//  Created by Colton Lathrop on 1/10/23.
//

import Foundation
import SwiftUI

struct LogoutButton: View {
    @State var confirmationShowing = false
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
        Button(action:{
            confirmationShowing = true
        }){
            HStack {
                Text("Logout")
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.secondary)
            }
        }.confirmationDialog("Are you sure you want to logout?", isPresented: $confirmationShowing){
            Button("Yes", role: .destructive) {
                self.auth.logout()
            }
        } message: {
            Text("Are you sure you want to logout?")
        }
    }
}
