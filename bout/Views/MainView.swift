//
//  MainView.swift
//  bout
//
//  Created by Colton Lathrop on 11/29/22.
//

import Foundation
import SwiftUI

struct MainView: View {
    @EnvironmentObject var authentication: Authentication
    
    @State var getMeFailed = false
    @State var getMeFailureReason = ""
    @State var isLoading = true
    
    func isOnboarded(user_opt: User?) -> Bool {
        if let user = user_opt {
            if user.name.starts(with: "newuser") {
                return false
            }
            
            if user.displayName.starts(with: "newuser"){
                return false
            }
            
            return true
        } else {
            return false
        }
    }
    
    func resetUserFetchFailure() {
        self.getMeFailed = false;
        self.getMeFailureReason = ""
    }
    
    func ensureUserFetched() async {
        if authentication.authenticated {
            if authentication.user == nil {
                self.isLoading = true
                let res = await authentication.getMe()
                switch res {
                case .success():
                    self.resetUserFetchFailure()
                    self.isLoading = false
                case .failure(let error):
                    self.getMeFailed = true
                    self.getMeFailureReason = error.description
                    self.isLoading = false
                }
            } else {
                self.isLoading = false
                self.resetUserFetchFailure()
                return
            }
        } else {
            self.isLoading = false
            return
        }
    }
    
    var body: some View {
        VStack {
            if isLoading {
                Text("Loading")
            } else if getMeFailed {
                GetMeFailureView(message: $getMeFailureReason, show: $getMeFailed, retryCallback: ensureUserFetched)
            } else if authentication.authenticated && isOnboarded(user_opt: authentication.user) {
                ActiveView()
            } else if authentication.authenticated && !isOnboarded(user_opt: authentication.user)  {
                OnboardingView()
            } else {
                LoginView()
            }
        }.task {
            // Ensuring the user is fetched is only depended on when not logging in
            // Logging in will populate the user in the authentication
            await self.ensureUserFetched()
        }
    }
}

struct GetMeFailureView: View {
    @EnvironmentObject var authentication: Authentication
    @Binding var message: String
    @Binding var show: Bool
    @State var retryCallback: () async -> Void
    
    var body: some View {
        VStack {
                HStack{
                    Button(action: {
                        self.authentication.logout()
                    }){
                        Text("Logout")
                            .font(.caption.bold())
                            .padding()
                    }.foregroundColor(.primary).disabled(false)
                    Spacer()
                }
            Spacer()
            Text("hmmm, this shouldn't happen.").font(.title2).padding()
            Text(message).font(.caption).foregroundColor(.secondary)
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

struct GetMeFailureView_Previews: PreviewProvider {
    static var previews: some View {
        GetMeFailureView(message: .constant("failed to get user"), show: .constant(true), retryCallback: {() async -> Void in return }).preferredColorScheme(.dark)
    }
}
