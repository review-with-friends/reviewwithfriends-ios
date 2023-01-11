//
//  WelcomeView.swift
//  spotster
//
//  Created by Colton Lathrop on 12/6/22.
//

import Foundation
import SwiftUI
import SafariServices

struct WelcomeView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    VStack {
                        Image("shops").resizable().scaledToFit().cornerRadius(6)
                        Image("steak").resizable().scaledToFit().cornerRadius(6)
                        Image("clams").resizable().scaledToFit().cornerRadius(6)
                    }
                    VStack {
                        Image("coffee").resizable().scaledToFit().cornerRadius(6)
                        Image("cafe").resizable().scaledToFit().cornerRadius(6)
                        Image("doordash").resizable().scaledToFit().cornerRadius(6)
                    }
                }
            }.padding()
            
            Button(action: {
                navigationManager.path.append(GetCode())
            }) {
                Text("Get Started").font(.largeTitle).fontWeight(.bold)
            }
        }.accentColor(.primary)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView().preferredColorScheme(.dark).environmentObject(NavigationManager())
    }
}
