//
//  LoaderError.swift
//  app
//
//  Created by Colton Lathrop on 3/15/23.
//

import Foundation
import SwiftUI

struct LoaderError: View {
    var id: String
    var contextText: String
    var errorText: String
    var callback: () -> Void
    
    @State var isShowingSheet = false
    
    var body: some View {
        VStack {
            Image("angry")
                .resizable()
                .scaledToFit()
                .cornerRadius(50).overlay {
                    VStack {
                        VStack {
                            HStack {
                                Button(action: {
                                    self.isShowingSheet = true
                                }) {
                                    Image(systemName: "questionmark.circle")
                                }.padding(8).accentColor(.secondary)
                                Spacer()
                            }.padding()
                        }.sheet(isPresented: $isShowingSheet,
                                onDismiss: {}) {
                            VStack {
                                HStack {
                                    Text("Screenshot this if you are reporting the error:").font(.title.bold())
                                }.padding()
                                HStack {
                                    Text("review id:").bold()
                                    Text("\(self.id)")
                                }
                                HStack {
                                    Text("error reason:").bold()
                                    Text("\(self.errorText)")
                                }
                                HStack {
                                    Text("timestamp:").bold()
                                    Text("\(Date())")
                                }
                            }
                         }
                        Spacer()
                        VStack {
                            HStack {
                                HStack {
                                    Text("\(self.contextText)").font(.title2.bold()).padding()
                                }.background(.red).cornerRadius(25)
                                Spacer()
                            }.padding(.horizontal)
                            HStack {
                                Spacer()
                                HStack {
                                    Text("Offline? Not added? Bug?").font(.title2.bold()).padding()
                                }.background(.red).cornerRadius(25)
                            }.padding(.horizontal)
                            VStack {
                                PrimaryButton(title: "Try Again", action: self.callback)
                            }.padding()
                        }
                    }.shadow(radius: 5)
                }.unsplashToolTip(URL(string: "https://unsplash.com/@enginakyurt")!)
        }.padding()
    }
}

struct LoaderError_Preview: PreviewProvider {
    static var previews: some View {
        LoaderError(id: "123", contextText: "We failed to load this review.", errorText: "unable to find review", callback: {}).preferredColorScheme(.dark)
    }
}
