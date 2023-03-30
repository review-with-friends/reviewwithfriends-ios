//
//  ZeroNotifications.swift
//  app
//
//  Created by Colton Lathrop on 3/30/23.
//

import Foundation
import SwiftUI

struct ZeroNotifications: View {
    var body: some View {
        VStack {
            ZStack {
                Image("tables")
                    .resizable()
                    .scaledToFit()
                    .overlay {
                        VStack {
                            Spacer()
                            VStack {
                                HStack {
                                    Spacer()
                                    HStack {
                                        Text("No notifications yet.").font(.title3.bold()).padding()
                                    }.background(.white).cornerRadius(25).foregroundColor(.black)
                                }.padding(.bottom.union(.horizontal))
                                HStack {
                                    HStack {
                                        Text("You should post some reviews.").font(.title3.bold()).padding()
                                    }.background(.black).cornerRadius(25).foregroundColor(.white)
                                    Spacer()
                                }.padding(.bottom.union(.horizontal))
                            }
                        }.shadow(radius: 5)
                    }.unsplashToolTip(URL(string: "https://unsplash.com/@kcurtis113")!).cornerRadius(16)
            }
        }
    }
}

struct ZeroNotifications_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            ZeroNotifications().preferredColorScheme(.dark)
        }
    }
}
