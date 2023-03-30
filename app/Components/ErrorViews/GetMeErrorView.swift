//
//  GetMeErrorView.swift
//  app
//
//  Created by Colton Lathrop on 12/6/22.
//

import Foundation
import SwiftUI

struct GetMeErrorView: View {
    @EnvironmentObject var authentication: Authentication
    
    @Binding var message: String
    @Binding var show: Bool
    
    @State var retryCallback: () async -> Void
    @State var showConfirmation = false
    
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    Image("wall")
                        .resizable()
                        .scaledToFit()
                        .overlay {
                            VStack {
                                Spacer()
                                VStack {
                                    HStack {
                                        HStack {
                                            Text("We failed to fetch your user info.").font(.title2.bold()).padding().foregroundColor(.primary)
                                        }.background(.red).cornerRadius(25)
                                        Spacer()
                                    }.padding(.horizontal)
                                    HStack {
                                        Spacer()
                                        HStack {
                                            Text("Are you connected to the internet?").font(.title2.bold()).padding().foregroundColor(.primary)
                                        }.background(.red).cornerRadius(25)
                                    }.padding(.horizontal)
                                    HStack {
                                        PrimaryButton(title: "Try Again", action: {
                                            Task {
                                                await self.retryCallback()
                                            }
                                        })
                                    }.padding(.bottom.union(.horizontal))
                                    HStack {
                                        PrimaryButton(title: "Logout", action: {
                                            self.showConfirmation = true
                                        })
                                    }.padding(.bottom.union(.horizontal))
                                }
                            }.shadow(radius: 5)
                        }.unsplashToolTip(URL(string: "https://unsplash.com/@ardentlysarah")!).cornerRadius(16)
                }
            }.confirmationDialog("Are you sure you want to logout?", isPresented: $showConfirmation)
            {
                Button("Yes", role: .destructive) {
                    self.authentication.logout()
                    self.show = false
                }
            } message: {
                Text("If you are offline, logging out won't fix it. You'll just need to sign in again.")
            }
            HStack {
                Text("Error message: \(message)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }.padding()
            Spacer()
        }
    }
}

struct GetMeErrorView_Previews: PreviewProvider {
    static var previews: some View {
        GetMeErrorView(message: .constant("failed to get user"), show: .constant(true), retryCallback: {() async -> Void in return }).preferredColorScheme(.dark)
    }
}
