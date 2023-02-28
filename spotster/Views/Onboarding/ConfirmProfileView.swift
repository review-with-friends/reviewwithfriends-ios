//
//  GetStartedView.swift
//  spotster
//
//  Created by Colton Lathrop on 12/6/22.
//

import Foundation
import SwiftUI

struct ConfirmProfileView: View {
    @Binding var path: NavigationPath
    
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
        VStack {
            Spacer()
            VStack{
                ProfilePicLoader(path: self.$path, userId: auth.user?.id ?? "", profilePicSize: .large, navigatable: false, ignoreCache: true).padding()
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

struct ConfirmProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmProfileView(path: .constant(NavigationPath())).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
    }
}
