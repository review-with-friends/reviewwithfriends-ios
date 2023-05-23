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
    @State var reportBugShowing = false
    @State var recoveryEmailShowing = false
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var friendsCache: FriendsCache
    
    var body: some View {
        VStack {
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
                    Button(action:{
                        self.reportBugShowing = true
                    }){
                        HStack {
                            Text("Report Bug")
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
                    if user.recovery == false {
                        Button("Set Recovery Email", role: .destructive){
                            self.recoveryEmailShowing = true
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
        }.sheet(isPresented: self.$reportBugShowing ){
            ReportBug()
        }
        .sheet(isPresented: self.$recoveryEmailShowing ){
            SetupRecoveryEmailSheet(isShowing: self.$recoveryEmailShowing)
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
