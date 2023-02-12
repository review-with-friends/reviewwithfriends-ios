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
        TabView {
            ForEach(self.fullReview.pics) { pic in
                VStack {
                    ReviewPicLoader(path: self.$path, pic: pic).overlay {
                        ReviewPicOverlay(path: self.$path, likes: fullReview.likes, reviewId: fullReview.review.id, reloadCallback: reloadCallback)
                    }
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 500)
    }
}

struct ReviewPicCarousel_Previews: PreviewProvider {
    static func dummyCallback() async {}
    
    static var previews: some View {
        ReviewPicCarousel(path: .constant(NavigationPath()),fullReview: generateFullReviewPreviewData(), reloadCallback: dummyCallback).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
    }
}

