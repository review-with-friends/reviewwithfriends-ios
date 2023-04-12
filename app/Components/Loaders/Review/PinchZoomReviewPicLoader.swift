//
//  PinchZoomReviewPicLoader.swift
//  app
//
//  Created by Colton Lathrop on 3/8/23.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct PinchZoomReviewPicLoader: View {
    @Binding var path: NavigationPath
    
    let pic: Pic
    
    @State var reloadHard = false
    @State var scale: CGFloat = 1.0
    
    var magnify: some Gesture {
        MagnificationGesture(minimumScaleDelta: 0.1)
            .onChanged { scaleDelta in
                self.scale = scaleDelta
            }.onEnded { _ in
                self.scale = 1.0
            }
    }
    
    var body: some View {
        if self.reloadHard {
            ReviewPicSkeleton(loading: true, width: pic.width, height: pic.height)
        } else {
            WebImage(url: URL(string: "https://bout.sfo3.cdn.digitaloceanspaces.com/" + pic.id))
                .placeholder {
                    ReviewPicSkeleton(loading: true, width: pic.width, height: pic.height)
                }
                .resizable().scaledToFit()
                .scaleEffect(scale)
                .gesture(magnify)
        }
    }
}
