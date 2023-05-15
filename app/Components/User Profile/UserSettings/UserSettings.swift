//
//  UserSettings.swift
//  app
//
//  Created by Colton Lathrop on 1/10/23.
//

import Foundation
import SwiftUI

struct UserSettings: View {
    @Binding var path: NavigationPath
    
    var user: User
    
    @State var logoutConfirmationShowing = false
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var friendsCache: FriendsCache
    
    var body: some View {
        VStack {
            if user.recovery == false {
                SetupRecoveryEmail()
            }
            List {
                Section {
                    Button(action:{
                        self.path.append(LikedReviewsDestination())
                    }){
                        HStack {
                            Text("View Likes")
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.secondary)
                        }
                    }
                }
                Section {
                    Link(destination: URL(string: "https://reviewwithfriends.com/PRIVACYPOLICY.pdf")!){
                        HStack {
                            Text("Privacy Policy")
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.secondary)
                        }
                    }
                }
                Section {
                    Button(action:{
                        auth.resetCachedOnboarding()
                    }){
                        HStack {
                            Text("Change Profile")
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.secondary)
                        }
                    }
                    Button("Logout", role: .cancel){
                        logoutConfirmationShowing = true
                    }
                    Button("Delete Account", role: .destructive){
                        path.append(DeleteAccountDestination())
                    }
                }
            }
        }.accentColor(.primary)
            .navigationBarTitle("Settings", displayMode: .large)
            .confirmationDialog("Are you sure you want to logout?", isPresented: $logoutConfirmationShowing){
            Button("Yes", role: .destructive) {
                self.auth.logout()
            }
        } message: {
            Text("Are you sure you want to logout?")
        }
    }
}

struct MyProfileView_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            UserSettings(path: .constant(NavigationPath()), user: generateUserPreviewData())
                .preferredColorScheme(.dark)
                .environmentObject(Authentication.initPreview())
                .environmentObject(UserCache())
                .environmentObject(FriendsCache.generateDummyData())
        }
    }
}
