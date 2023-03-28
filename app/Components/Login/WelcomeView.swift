//
//  WelcomeView.swift
//  app
//
//  Created by Colton Lathrop on 12/6/22.
//

import Foundation
import SwiftUI
import SafariServices

struct WelcomeView: View {
    @Binding var path: NavigationPath
    
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
            }.padding().overlay {
                VStack {
                    Spacer()
                    VStack {
                        Text("app.").font(.system(size: 78).bold()).padding()
                    }.background(.black).cornerRadius(16).shadow(radius: 8)
                    Spacer()
                    Spacer()
                }
            }
            Text("By pressing Get Started, you are agreeing to our Terms of Service and Privacy policy.").font(.caption).foregroundColor(.secondary).padding(.horizontal).multilineTextAlignment(.center)
            PrimaryButton(title: "Get Started", action: {
                self.path.append(GetCode())
            }).padding(.vertical)
        }.accentColor(.primary)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(path: .constant(NavigationPath())).preferredColorScheme(.dark)
    }
}
