//
//  FeedEndOfReviews.swift
//  app
//
//  Created by Colton Lathrop on 3/29/23.
//

import Foundation
import SwiftUI

struct FeedEndOfReviews: View {
    var body: some View {
        VStack {
            ZStack {
                Image("bus")
                    .resizable()
                    .scaledToFit()
                    .overlay {
                        VStack {
                            Spacer()
                            VStack {
                                HStack {
                                    Spacer()
                                    HStack {
                                        Text("Thats it. Go on an adventure.").font(.title3.bold()).padding()
                                    }.background(.white).cornerRadius(25).foregroundColor(.black)
                                }.padding(.bottom.union(.horizontal))
                            }
                        }.shadow(radius: 5)
                    }.unsplashToolTip(URL(string: "https://unsplash.com/@charleypangus")!).cornerRadius(16)
            }
        }
    }
}

struct FeedEndOfReviews_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            FeedEndOfReviews().preferredColorScheme(.dark)
        }
    }
}
