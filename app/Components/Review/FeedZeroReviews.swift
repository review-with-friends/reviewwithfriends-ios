//
//  FeedZeroReviews.swift
//  app
//
//  Created by Colton Lathrop on 3/29/23.
//

import Foundation
import SwiftUI

struct FeedZeroReviews: View {
    @Binding var path: NavigationPath
    var body: some View {
        VStack {
            ZStack {
                Image("voodoo")
                    .resizable()
                    .scaledToFit()
                    .overlay {
                        VStack {
                            Spacer()
                            VStack {
                                HStack {
                                    HStack {
                                        Text("Looks like there are no reviews to show you yet.").font(.title3.bold()).padding().foregroundColor(.primary)
                                    }.background(.black).cornerRadius(25)
                                    Spacer()
                                }.padding(.horizontal)
                                HStack {
                                    Spacer()
                                    HStack {
                                        Text("Post some, get your friends on the app, or see if they are already here below 👇").font(.title3.bold()).padding()
                                    }.background(.white).cornerRadius(25).foregroundColor(.black)
                                }.padding(.bottom.union(.horizontal))
                                HStack {
                                    PrimaryButton(title: "Find Friends 🔎", action: {
                                        self.path.append(DiscoverFriendsDestination())
                                    })
                                }.padding(.bottom.union(.horizontal))
                            }
                        }.shadow(radius: 5)
                    }.unsplashToolTip(URL(string: "https://unsplash.com/@mathewbrowne")!).cornerRadius(16)
            }
        }
    }
}

struct FeedZeroReviews_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            FeedZeroReviews(path: .constant(NavigationPath())).preferredColorScheme(.dark)
        }
    }
}
