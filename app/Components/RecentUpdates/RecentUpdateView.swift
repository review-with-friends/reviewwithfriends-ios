//
//  RecentUpdateView.swift
//  app
//
//  Created by Colton Lathrop on 5/17/23.
//

import Foundation
import SwiftUI

struct RecentUpdateView: View {
    var body: some View {
            ScrollView {
                VStack {
                    HStack {
                        Text("🎉 Update to 1.0.1 🎉").font(.title).bold()
                    }.padding()
                    HStack {
                        Text("Major Changes:").font(.title2).bold()
                        Spacer()
                    }.padding()
                    HStack {
                        Text("- Review photos limit increased to 7 😍")
                        Spacer()
                    }.padding(8)
                    HStack {
                        Text("- Friends is now its own button on your profile 👯‍♀️")
                        Spacer()
                    }.padding(8)
                    HStack {
                        Text("Minor Changes:").font(.title3).bold()
                        Spacer()
                    }.padding()
                    HStack {
                        Text("- TabBar got a minor facelift 📸")
                        Spacer()
                    }.padding(8)
                    HStack {
                        Text("- Pressing the Home button while already on it refreshes the feed 🫠")
                        Spacer()
                    }.padding(8)
                    HStack {
                        Text("- Added warning button when Full Access to Photos Library is given 🕵️‍♀️")
                        Spacer()
                    }.padding(8)
                    HStack {
                        Text("- Added how many miles you are away from a location from the location view 🏃‍♀️")
                        Spacer()
                    }.padding(8)
                    HStack {
                        Text("- Added search to the map where you find where you went 🔎")
                        Spacer()
                    }.padding(8)
                }.padding()
            }.presentationDragIndicator(.visible)
    }
}

struct RecentUpdateView_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
        }.sheet(isPresented: .constant(true)) {
            RecentUpdateView().preferredColorScheme(.dark)
        }.preferredColorScheme(.dark)
    }
}
