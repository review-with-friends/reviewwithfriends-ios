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
        self.path.append(DiscoverFriends())
    }
    
    var body: some View {
        VStack {
            Text("app.").font(.system(size: 72).bold())
            Image("powells")
                .resizable()
                .scaledToFit()
                .cornerRadius(50).overlay {
                    VStack {
                        Spacer()
                        VStack {
                            HStack {
                                HStack {
                                    Text("Doubletap reviews to favorite.").font(.title2.bold()).padding()
                                }.background(.green).cornerRadius(25)
                                Spacer()
                            }.padding()
                            HStack {
                                Spacer()
                                HStack {
                                    Text("Find where you've been on the map.").font(.title2.bold()).padding().foregroundColor(.black)
                                }.background(.yellow).cornerRadius(25)
                            }.padding(.horizontal)
                            HStack {
                                HStack {
                                    Text("Write some reviews for your friends.").font(.title2.bold()).padding()
                                }.background(.blue).cornerRadius(25)
                                Spacer()
                            }.padding()
                        }
                    }.shadow(radius: 5)
                }.unsplashToolTip(URL(string: "https://unsplash.com/@coleito")!)
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
