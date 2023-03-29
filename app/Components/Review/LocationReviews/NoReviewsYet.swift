//
//  NoReviewsYet.swift
//  app
//
//  Created by Colton Lathrop on 3/29/23.
//

import Foundation
import SwiftUI

struct NoReviewsYet: View {
    var body: some View {
        VStack {
            ZStack {
                Image("empty")
                    .resizable()
                    .scaledToFit()
                    .overlay {
                        VStack {
                            Spacer()
                            VStack {
                                HStack {
                                    HStack {
                                        Text("None of your friends have left a review here yet.").font(.title2.bold()).padding().foregroundColor(.primary)
                                    }.background(.black).cornerRadius(25)
                                    Spacer()
                                }.padding(.horizontal)
                                HStack {
                                    Spacer()
                                    HStack {
                                        Text("You should be the first 🤩").font(.title2.bold()).padding()
                                    }.background(.white).cornerRadius(25).foregroundColor(.black)
                                }.padding(.bottom.union(.horizontal))
                            }
                        }.shadow(radius: 5)
                    }.unsplashToolTip(URL(string: "https://unsplash.com/@ilyuza")!).cornerRadius(16)
            }
        }
    }
}

struct NoReviewsYet_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            NoReviewsYet().preferredColorScheme(.dark)
        }
    }
}
