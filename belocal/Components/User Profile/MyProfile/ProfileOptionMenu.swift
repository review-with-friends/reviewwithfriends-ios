//
//  ProfileOptionMenu.swift
//  belocal
//
//  Created by Colton Lathrop on 2/15/23.
//

import Foundation
import SwiftUI

struct ProfileOptionMenu: View {
    @Binding var path: NavigationPath
    @State var logoutConfirmationShowing = false

    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var notifications: NotificationManager
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack {
                    Menu {
                        Button(action:{
                            auth.resetCachedOnboarding()
                        }){
                            HStack {
                                Text("Change Profile")
                            }
                        }
                        Button("Logout"){
                            logoutConfirmationShowing = true
                        }
                        Button("Delete Account", role: .destructive){
                            path.append(DeleteAccountDestination())
                        }
                    } label: {
                        Image(systemName: "gearshape.fill").font(.title).foregroundColor(.white)
                    }.padding(4).confirmationDialog("Are you sure you want to logout?", isPresented: $logoutConfirmationShowing){
                        Button("Yes", role: .destructive) {
                            self.auth.logout()
                        }
                    } message: {
                        Text("Are you sure you want to logout?")
                    }
                }.background(.black).shadow(radius: 3.0).cornerRadius(8.0)
            }.padding().padding()
        }
    }
}
