//
//  ReviewPicCarousel.swift
//  spotster
//
//  Created by Colton Lathrop on 2/12/23.
//

import Foundation
import SwiftUI

struct ReviewPicCarousel: View {
    @Binding var path: NavigationPath
    
    var fullReview: FullReview
    var reloadCallback: () async -> Void
    
    var body: some View {
        HStack {
            TabView {
                ForEach(self.fullReview.pics) { pic in
                    PinchZoomReviewPicLoader(path: self.$path, pic: pic).padding(0)
                }
            }.padding(0).frame(height: 600)
            .aspectRatio(contentMode: .fill)
            .tabViewStyle(PageTabViewStyle())
        }
    }
}

struct ReviewPicCarousel_Previews: PreviewProvider {
    static func dummyCallback() async {}
    
    static var previews: some View {
        ReviewPicCarousel(path: .constant(NavigationPath()),fullReview: generateFullReviewPreviewData(), reloadCallback: dummyCallback).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
    }
}

