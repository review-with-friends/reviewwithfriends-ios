//
//  OnboardingView.swift
//  belocal
//
//  Created by Colton Lathrop on 11/28/22.
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    @State var path = NavigationPath()
    
    @EnvironmentObject var friendsCache: FriendsCache
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
        NavigationStack(path: self.$path) {
            VStack{
                // First Stop
                GetStartedView(path: self.$path)
            }
            .navigationDestination(for: DiscoverFriends.self) { _ in
                // Second Stop
                DiscoverFriendsView(path: self.$path)
            }
            .navigationDestination(for: SetNames.self) { _ in
                // Third Stop
                SetNamesView(path: self.$path)
            }
            .navigationDestination(for: SetupRecovery.self) { _ in
                // Fourth Stop
                SetupRecoveryView(path: self.$path)
            }
            .navigationDestination(for: SetProfilePic.self) { _ in
                // Fifth Stop
                SetProfilePicView(path: self.$path)
            }
            .navigationDestination(for: ConfirmProfile.self) { _ in
                // Sixth Stop
                ConfirmProfileView(path: self.$path)
            }
        }.accentColor(.primary).onAppear {
            belocal.requestNotifications()
        }.onAppear {
            Task {
                let _ = await self.friendsCache.refreshFriendsCache(token: self.auth.token)
            }
        }
    }
}

struct SetProfilePic: Hashable {}
struct SetNames: Hashable {}
struct ConfirmProfile: Hashable {}
struct DiscoverFriends: Hashable {}
struct SetupRecovery: Hashable {}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .preferredColorScheme(.dark)
            .environmentObject(Authentication.initPreview())
            .environmentObject(UserCache())
            .environmentObject(FriendsCache())
    }
}
