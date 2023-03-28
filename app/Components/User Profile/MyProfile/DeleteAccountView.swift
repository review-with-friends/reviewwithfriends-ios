//
//  DeleteAccountButton.swift
//  app
//
//  Created by Colton Lathrop on 1/10/23.
//

import Foundation
import SwiftUI

struct DeleteAccountView: View {
    
    @State var secondsLeft = 30
    @State var deleteEnabled = false
    
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
        VStack {
            Image(systemName: self.deleteEnabled ? "lock.open" : "lock").font(.system(size: 128))
            Text("Please wait \(secondsLeft) seconds...").font(.title2).padding()
            Button("Delete Account", role: .destructive){
                
            }.disabled(!self.deleteEnabled).padding()
            HStack {
                Text("Disclaimer: Pressing the above 'Delete Account' button will permanently delete your account and all associated data immediately. app has no way to recover this information once deleted. You can create a new account at anytime.").font(.caption)
            }.padding()
        }.navigationTitle("Delete Account").task {
            while secondsLeft >= 1 {
                try? await Task.sleep(for: Duration.seconds(1))
                self.secondsLeft += -1
            }
            deleteEnabled = true
        }
    }
}

struct DeleteAccountView_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            DeleteAccountView()
                .preferredColorScheme(.dark)
                .environmentObject(Authentication.initPreview())
                .environmentObject(UserCache())
                .environmentObject(FriendsCache.generateDummyData())
        }
    }
}

