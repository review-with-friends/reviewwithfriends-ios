//
//  ImageLookupHelp.swift
//  belocal
//
//  Created by Colton Lathrop on 3/21/23.
//

import Foundation
import SwiftUI

struct ImageLookupHelp: View {
    var body: some View {
        VStack {
            ZStack {
                Image("maphelp")
                    .resizable()
                    .scaledToFill()
                    .overlay {
                        VStack {
                            Spacer()
                            VStack {
                                HStack {
                                    HStack {
                                        Text("Use the map to find where you went.").font(.title2.bold()).padding()
                                    }.background(.red).cornerRadius(25).foregroundColor(.black)
                                    Spacer()
                                }.padding(.leading)
                                HStack {
                                    Spacer()
                                    HStack {
                                        Text("Tap the annotation to select it.").font(.title2.bold()).padding()
                                    }.background(.green).cornerRadius(25).foregroundColor(.black)
                                }.padding(.horizontal)
                                HStack {
                                    HStack {
                                        Text("If you can't find the place, try zooming in.").font(.title2.bold()).padding().foregroundColor(.black)
                                    }.background(.yellow).cornerRadius(25)
                                    Spacer()
                                }.padding(.horizontal)
                                HStack {
                                    Spacer()
                                    HStack {
                                        Text("Make sure to enable Locations in the Camera App.").font(.title2.bold()).padding()
                                    }.background(.blue).cornerRadius(25).foregroundColor(.black)
                                }.padding(.bottom.union(.horizontal))
                            }
                        }.shadow(radius: 5)
                    }.unsplashToolTip(URL(string: "https://unsplash.com/@leio")!)
            }
        }
    }
}

struct ImageLookupHelp_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            ImageLookupHelp().preferredColorScheme(.dark)
        }
    }
}
