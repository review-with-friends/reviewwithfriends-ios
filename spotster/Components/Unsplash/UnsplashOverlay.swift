//
//  UnsplashOverlay.swift
//  spotster
//
//  Created by Colton Lathrop on 12/29/22.
//

import Foundation
import SwiftUI

struct UnsplashOverlay: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack {
                    Text("Credit in settings")
                }.padding(4).font(.system(size: 9)).foregroundColor(.secondary)
            }.padding()
        }
    }
}
