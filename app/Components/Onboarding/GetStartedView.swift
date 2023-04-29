//
//  GetStartedView.swift
//  app
//
//  Created by Colton Lathrop on 2/28/23.
//

import Foundation
import SwiftUI

struct GetStartedView: View {
    @Binding var path: NavigationPath
    
    @EnvironmentObject var auth: Authentication
    
    let photos = [GetStartedPhoto(id: "like"), GetStartedPhoto(id: "find"), GetStartedPhoto(id: "map_friends"), GetStartedPhoto(id: "search")]
    
    func moveToNextScreen() {
        self.path.append(SetNames())
    }
    
    var body: some View {
        VStack {
            Spacer()
            Image("hood")
                .resizable()
                .scaledToFit()
                .cornerRadius(50).overlay {
                    VStack {
                        Spacer()
                        VStack {
                            HStack {
                                Spacer()
                                HStack {
                                    Text("You are logged in now!").font(.title2.bold()).padding()
                                }.background(.black).cornerRadius(25)
                            }.padding()
                            HStack {
                                HStack {
                                    Text("Let's setup your profile.").font(.title2.bold()).padding()
                                }.background(.gray).cornerRadius(25)
                                Spacer()
                            }.padding(.horizontal.union(.bottom))
                        }
                    }.shadow(radius: 5)
                }.unsplashToolTip(URL(string: "https://unsplash.com/@umit1010")!)
            Spacer()
            PrimaryButton(title: "Get Started", action: {
                self.moveToNextScreen()
            })
        }
    }
}

struct GetStartedPhoto: Identifiable {
    let id: String
}

struct GetStartedView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedView(path: .constant(NavigationPath())).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
    }
}
