//
//  GetMeErrorView.swift
//  belocal
//
//  Created by Colton Lathrop on 12/6/22.
//

import Foundation
import SwiftUI

struct GetMeErrorView: View {
    @EnvironmentObject var authentication: Authentication
    
    @Binding var message: String
    @Binding var show: Bool
    
    @State var retryCallback: () async -> Void
    @State var showConfirmation = false
    
    var body: some View {
        VStack {
                HStack{
                    Button(action: {
                        self.showConfirmation = true
                    }){
                        Text("Logout")
                            .font(.body.bold())
                            .padding()
                    }
                    .foregroundColor(.primary)
                    .confirmationDialog("Are you sure you want to logout?", isPresented: $showConfirmation)
                    {
                        Button("Yes", role: .destructive) {
                            self.authentication.logout()
                        }
                    } message: {
                        Text("If you are offline, logging out won't fix it.")
                    }
                    Spacer()
                }
            Spacer()
            Text("Damn, something failed while talking to the server...")
                .font(.title2)
                .padding()
                .multilineTextAlignment(.center)
            HStack {
                Text("Error:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(message)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }.padding()
            Button(action: {
                Task {
                    await self.retryCallback()
                }
            }){
                Text("Try Again")
                    .font(.title.bold())
                    .padding()
            }.foregroundColor(.primary)
                .cornerRadius(16.0).padding()
            Spacer()
        }
    }
}

struct GetMeErrorView_Previews: PreviewProvider {
    static var previews: some View {
        GetMeErrorView(message: .constant("failed to get user"), show: .constant(true), retryCallback: {() async -> Void in return }).preferredColorScheme(.dark)
    }
}
