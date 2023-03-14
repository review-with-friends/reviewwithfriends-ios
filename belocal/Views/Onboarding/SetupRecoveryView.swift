//
//  SetupRecoveryView.swift
//  belocal
//
//  Created by Colton Lathrop on 3/14/23.
//

import Foundation
import SwiftUI

struct SetupRecoveryView: View {
    @Binding var path: NavigationPath
    
    @State private var isShowingSheet = false
    
    @EnvironmentObject var auth: Authentication
    
    func moveToNextScreen() {
        self.path.append(SetProfilePic())
    }
    
    func isRecoverySet() -> Bool {
        if let recoverySet = self.auth.user?.recovery {
            if recoverySet {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            if self.isRecoverySet() {
                VStack {
                    Image("recovery-done")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(50).overlay {
                            VStack {
                                Spacer()
                                VStack {
                                    HStack {
                                        HStack {
                                            Text("You've already got a recovery email set.").font(.title2.bold()).padding()
                                        }.background(.black).cornerRadius(25)
                                        Spacer()
                                    }.padding(.horizontal)
                                    HStack {
                                        Spacer()
                                        HStack {
                                            Text("But you can change it here.").font(.title2.bold()).padding()
                                        }.background(.gray).cornerRadius(25)
                                    }.padding(.horizontal)
                                    VStack {
                                        PrimaryButtonGreen(title: "✉️ Update Recovery Email", action: {self.isShowingSheet = true})
                                    }.padding()
                                }
                            }.shadow(radius: 5)
                        }.unsplashToolTip(URL(string: "https://unsplash.com/@wocintechchat")!)
                }
            } else {
                VStack {
                    Image("recovery")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(50).overlay {
                            VStack {
                                Spacer()
                                VStack {
                                    HStack {
                                        HStack {
                                            Text("Set a Recovery Email.").font(.title2.bold()).padding()
                                        }.background(.black).cornerRadius(25)
                                        Spacer()
                                    }.padding(.horizontal)
                                    HStack {
                                        Spacer()
                                        HStack {
                                            Text("We won't sell it.").font(.title2.bold()).padding()
                                        }.background(.gray).cornerRadius(25)
                                    }.padding(.horizontal)
                                    VStack {
                                        PrimaryButtonRed(title: "✉️ Set Recovery Email", action: {self.isShowingSheet = true})
                                    }.padding()
                                }
                            }.shadow(radius: 5)
                        }.unsplashToolTip(URL(string: "https://unsplash.com/@conscious_design")!)
                }
            }
            Spacer()
            PrimaryButton(title: "Continue", action: {
                self.moveToNextScreen()
            })
        }.navigationTitle("Recovery Email")
            .sheet(isPresented: $isShowingSheet,
                   onDismiss: {}) {
                SetupRecoveryEmailSheet(isShowing: $isShowingSheet)
            }
        
    }
}

struct SetupRecoveryView_Previews: PreviewProvider {
    static var previews: some View {
        SetupRecoveryView(path: .constant(NavigationPath())).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
    }
}
