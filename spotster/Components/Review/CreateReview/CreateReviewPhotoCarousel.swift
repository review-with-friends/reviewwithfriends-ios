//
//  CreateReviewPhotoCarousel.swift
//  spotster
//
//  Created by Colton Lathrop on 2/12/23.
//

import Foundation
import SwiftUI

struct CreateReviewPhotoCarousel: View {
    var images: [UIImage]
    
    var body: some View {
        TabView {
            ForEach(self.images, id: \.self.hash) { uiImage in
                Image(uiImage: uiImage).resizable().scaledToFit().cornerRadius(16)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 500)
    }
}

struct CreateReviewPhotoCarousel_Previews: PreviewProvider {
    static func dummyCallback() async {}
    
    static var previews: some View {
        CreateReviewPhotoCarousel(images: spotster.generateArrayOfImages()).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
    }
}

