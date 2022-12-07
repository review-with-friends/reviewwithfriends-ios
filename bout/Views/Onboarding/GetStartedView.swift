//
//  GetStartedView.swift
//  bout
//
//  Created by Colton Lathrop on 12/6/22.
//

import Foundation
import SwiftUI

struct GetStartedView: View {
    @Binding var phase: OnboardingPhase
    
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
        VStack {
            HStack{
                Button(action: {
                    withAnimation(.spring().speed(2.0)){
                        self.phase = .SetProfilePic
                    }
                }){
                    Text("Back")
                        .font(.caption.bold())
                        .padding()
                }.foregroundColor(.primary).disabled(false)
                Spacer()
            }
            Spacer()
            VStack{
                ProfilePicLoader(token: auth.token, userId: auth.user?.id ?? "") { image in
                    ProfilePic(image: image, profilePicSize: .large)
                } placeholder: {
                    ProfilePic(image: UIImage(named: "default")!, profilePicSize: .large)
                }.padding()
                Text(auth.user?.displayName ?? "").font(.title2.bold())
                Text("@" + (auth.user?.name ?? "")).foregroundColor(.secondary)
            }.padding()
            Spacer()
            Button(action: {
                withAnimation(.spring().speed(2.0)){
                    auth.setCachedOnboarding()
                }
            }){
                Text("Finish")
                    .font(.title.bold())
                    .padding()
            }.foregroundColor(.primary).disabled(false)

            Spacer()
        }
    }
}

struct GetStartedView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedView(phase: .constant(OnboardingPhase.GetStarted)).preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
    }
}
