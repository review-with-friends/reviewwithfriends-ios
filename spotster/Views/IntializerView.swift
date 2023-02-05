//
//  MainView.swift
//  spotster
//
//  Created by Colton Lathrop on 11/29/22.
//

import Foundation
import SwiftUI

struct IntializerView: View {
    @EnvironmentObject var authentication: Authentication
    
    @State var getMeFailed = false
    @State var getMeFailureReason = ""
    
    /// Controls whether the main app loader shows or not.
    /// Generally, we want to be in the state for as little time as possible.
    @State var isLoading = true
    
    /// Resets the state away from the GetMeErroView
    func resetUserFetchFailure() {
        self.getMeFailed = false;
        self.getMeFailureReason = ""
    }
    
    /// Fetches the current user if the current authentication context is active.
    /// If no user is authenticated, we instantly know that and can bring up the login menu.
    /// If we are authenticated, and fail to get the user (built-in retries), we bring up a manual retry menu.
    func ensureUserFetched() async {
        do {
            try await Task.sleep(for: Duration.milliseconds(500))
        } catch {}
        if authentication.authenticated {
            if authentication.user == nil {
                self.isLoading = true
                let res = await authentication.getMe()
                switch res {
                case .success():
                    withAnimation {
                        self.resetUserFetchFailure()
                        self.isLoading = false
                    }
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
    
    init() {
        spotster.setAppIcon()
    }
    
    var body: some View {
        VStack {
            if isLoading {
                Loading()
            } else if getMeFailed {
                GetMeErrorView(message: $getMeFailureReason, show: $getMeFailed, retryCallback: ensureUserFetched)
            } else if authentication.authenticated && authentication.onboarded {
                MainView()
            } else if authentication.authenticated && !authentication.onboarded  {
                OnboardingView()
            } else {
                LoginView()
            }
        }.task {
            await self.ensureUserFetched()
        }
    }
}
