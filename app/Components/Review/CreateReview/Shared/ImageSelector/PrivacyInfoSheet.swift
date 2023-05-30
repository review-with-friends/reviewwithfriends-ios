//
//  PrivacyInfoSheet.swift
//  app
//
//  Created by Colton Lathrop on 5/17/23.
//

import Foundation
import SwiftUI

struct PrivacyInfoSheet: View {
    
    var navigateToSettings: some View {
        SmallPrimaryButton(title: "Change App Settings", action: {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        .padding()
    }
    
    var navigateToPrivacyDocs: some View {
        SmallPrimaryButton(title: "Apple Privacy Control", action: {
            UIApplication.shared.open(URL(string: "https://www.apple.com/privacy/control")!)
        })
        .padding()
    }
    
    var body: some View {
            ScrollView {
                Image("washhands").resizable().scaledToFit().unsplashToolTip(URL(string: "https://unsplash.com/@joshuaryanphoto")!)
                VStack {
                    HStack {
                        Text("What is this warning?").font(.title).bold().padding()
                    }
                    HStack {
                        Text("The team at Review with Friends takes pride in protecting the privacy of our users. Knowledge is power, and we feel it's important for you to know giving ANY app full-access to your photos can put your privacy at risk.")
                        Spacer()
                    }.padding()
                    HStack {
                        Text("As a program installed and running on your phone, if given 'All Photos' access, we can access any photo in your library (without you even knowing). Apple does a good job of giving you the tools to limit what we can see; and we recommend using these features to the fullest potential.")
                        Spacer()
                    }.padding()
                    HStack {
                        Text("We recommend using the 'Selected Photos' option and manually adding photos that our app is able to see. With this setting, we can't see any photos that you don't explicitly add from the built-in menu.")
                        Spacer()
                    }.padding()
                    HStack {
                        Text("We respect your privacy, and will never access your photos outside of you selecting them for writing a review. While you may trust our team, you don't need to trust us by easily limiting what we can see. We suggest you also review your Photo Library settings for any other app you have have given Full Access to.")
                        Spacer()
                    }.padding()
                    HStack {
                        Text("Follow the link below to adjust your settings:")
                        Spacer()
                    }.padding()
                    navigateToSettings
                    HStack {
                        Text("Also check out how Apple enables you to best protect your privacy:")
                        Spacer()
                    }.padding()
                    navigateToPrivacyDocs
                }.multilineTextAlignment(.leading)
                
            }.presentationDragIndicator(.visible)
    }
}

struct PrivacyInfoSheet_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
        }.sheet(isPresented: .constant(true)) {
            PrivacyInfoSheet().preferredColorScheme(.dark)
        }.preferredColorScheme(.dark)
    }
}
