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
                SetNamesView(path: self.$path)
            }
            .navigationDestination(for: SetProfilePic.self) { _ in
                SetProfilePicView(path: self.$path)
            }
            .navigationDestination(for: ReviewNamesAndProfilePic.self) { _ in
                GetStartedView(path: self.$path)
            }
        }.accentColor(.primary)
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
