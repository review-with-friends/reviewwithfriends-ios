//
//  EnableContactAccessView.swift
//  belocal
//
//  Created by Colton Lathrop on 3/2/23.
//

import Foundation
import SwiftUI

struct EnableContactAccessView: View {
    
    func openAppSettings() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                Image("friends")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(50).overlay {
                        VStack {
                            Spacer()
                            VStack {
                                HStack {
                                    HStack {
                                        Text("Find your crew already on belocal!").font(.title2.bold()).padding()
                                    }.background(.black).cornerRadius(25)
                                    Spacer()
                                }.padding(.horizontal)
                                HStack {
                                    Spacer()
                                    HStack {
                                        Text("We won't spy on you 👀").font(.title2.bold()).padding()
                                    }.background(.gray).cornerRadius(25)
                                }.padding(.horizontal)
                                VStack {
                                    PrimaryButton(title: "📓 Allow Access to Contacts", action: {self.openAppSettings()})
                                }.padding()
                            }
                        }.shadow(radius: 5)
                    }.unsplashToolTip(URL(string: "https://unsplash.com/@jmuniz")!)
            }
            Spacer()
        }
    }
}

struct EnableContactAccessView_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            EnableContactAccessView()
        }.preferredColorScheme(.dark)
            .environmentObject(FriendsCache.generateDummyData())
            .environmentObject(UserCache())
            .environmentObject(Authentication.initPreview())
    }
}
