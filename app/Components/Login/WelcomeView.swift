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
            ZStack {
                VStack {
                    Spacer()
                }.overlay {
                    Image("coffee").resizable().scaledToFill().ignoresSafeArea(.all).overlay {
                        LinearGradient(gradient: Gradient(colors: [.clear, .clear, .clear, .clear, .black.opacity(0.90)]), startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
                    }
                }
                VStack{
                    Image("loader").resizable().cornerRadius(48).scaledToFit().padding(36).shadow(radius: 5.0)
                    Spacer()
                    Text("By pressing Get Started, you agree to our policies:").font(.caption).foregroundColor(.secondary).padding(.horizontal).multilineTextAlignment(.center)
                    HStack {
                        Link(destination: URL(string: "https://reviewwithfriends.com/TERMSOFUSE.pdf")!){
                            Text("Terms of Use").font(.caption).foregroundColor(.secondary).underline()
                        }
                        Link(destination: URL(string: "https://reviewwithfriends.com/PRIVACYPOLICY.pdf")!){
                            Text("Privacy Policy").font(.caption).foregroundColor(.secondary).underline()
                        }
                        Link(destination: URL(string: "https://reviewwithfriends.com/EULA.pdf")!){
                            Text("EULA").font(.caption).foregroundColor(.secondary).underline()
                        }
                        Link(destination: URL(string: "https://reviewwithfriends.com/COMMUNITYGUIDELINES.pdf")!){
                            Text("Community Guidelines").font(.caption).foregroundColor(.secondary).underline()
                        }
                    }.padding(.top, 8)
                    VStack {
                        Button(action: {
                            self.path.append(GetCode())
                        }){
                            HStack {
                                Spacer()
                                Text("Get Started")
                                    .font(.title3.weight(.bold))
                                    .padding()
                                Spacer()
                            }.foregroundColor(.black).disabled(false)
                        }.background(.primary).cornerRadius(50).padding(.horizontal)
                    }.padding()
                }
            }.accentColor(.primary)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(path: .constant(NavigationPath())).preferredColorScheme(.dark)
    }
}
