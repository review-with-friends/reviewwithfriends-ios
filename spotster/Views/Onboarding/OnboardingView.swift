//
//  OnboardingView.swift
//  spotster
//
//  Created by Colton Lathrop on 11/28/22.
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: self.$path) {
            VStack{
                // First Stop
                GetStartedView(path: self.$path)
            }
            .navigationDestination(for: SetNames.self) { _ in
                // Third Stop
                SetNamesView(path: self.$path)
            }
            .navigationDestination(for: SetProfilePic.self) { _ in
                // Fourth Stop
                SetProfilePicView(path: self.$path)
            }
            .navigationDestination(for: ConfirmProfile.self) { _ in
                // Fifth Stop
                ConfirmProfileView(path: self.$path)
            }
        }.accentColor(.primary).onAppear {
            spotster.requestNotifications()
        }
    }
}

struct SetProfilePic: Hashable {}
struct SetNames: Hashable {}
struct ConfirmProfile: Hashable {}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .preferredColorScheme(.dark)
            .environmentObject(Authentication.initPreview())
            .environmentObject(UserCache())
    }
}
