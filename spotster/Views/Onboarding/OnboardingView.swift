//
//  OnboardingView.swift
//  spotster
//
//  Created by Colton Lathrop on 11/28/22.
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    @StateObject var navigationManager = NavigationManager()
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack{
                SetNamesView()
            }
            .navigationDestination(for: SetProfilePic.self) { _ in
                SetProfilePicView()
            }
            .navigationDestination(for: ReviewNamesAndProfilePic.self) { _ in
                GetStartedView()
            }
        }.environmentObject(self.navigationManager).accentColor(.primary)
    }
}

struct SetProfilePic: Hashable {}
struct ReviewNamesAndProfilePic: Hashable {}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .preferredColorScheme(.dark)
            .environmentObject(Authentication.initPreview())
            .environmentObject(UserCache())
    }
}
