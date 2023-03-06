//
//  UnsplashOverlay.swift
//  spotster
//
//  Created by Colton Lathrop on 12/29/22.
//

import Foundation
import SwiftUI

extension View {
    public func unsplashToolTip(_ creditsURL: URL) -> some View {
        self.overlay(UnsplashOverlay(creditsURL: creditsURL))
    }
}

struct UnsplashOverlay: View {
    
    var creditsURL: URL
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Link(destination: creditsURL){
                        Image("logo").resizable().scaledToFit().frame(width: 100).cornerRadius(8)
                    }
                }
            }.padding(4)
            Spacer()
        }.padding()
    }
}


struct UnsplashOverlay_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            UnsplashOverlay(creditsURL: URL(string: "https://www.apple.com")!)
        }.preferredColorScheme(.dark)
            .environmentObject(FriendsCache.generateDummyData())
            .environmentObject(UserCache())
            .environmentObject(Authentication.initPreview())
    }
}

