//
//  GetStartedView.swift
//  spotster
//
//  Created by Colton Lathrop on 2/28/23.
//

import Foundation
import SwiftUI

struct GetStartedView: View {
    @Binding var path: NavigationPath
    
    @EnvironmentObject var auth: Authentication
    
    func moveToNextScreen() {
        self.path.append(SetNames())
    }
    
    var body: some View {
        VStack {
            Spacer()
            VStack{
                Text("Lets get your profile set up!").font(.title)
            }.padding()
            Spacer()
            Button(action: {
                self.moveToNextScreen()
            }){
                Text("Get Started")
                    .font(.title.bold())
                    .padding()
            }.foregroundColor(.primary).disabled(false)
        }
    }
}

struct GetStartedView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedView(path: .constant(NavigationPath())).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
    }
}
