//
//  GetStartedView.swift
//  spotster
//
//  Created by Colton Lathrop on 12/6/22.
//

import Foundation
import SwiftUI

struct GetStartedView: View {
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        VStack {
            Spacer()
            VStack{
                ProfilePicLoader(userId: auth.user?.id ?? "", profilePicSize: .large, navigatable: false, ignoreCache: true).padding()
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
        GetStartedView().preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
    }
}
