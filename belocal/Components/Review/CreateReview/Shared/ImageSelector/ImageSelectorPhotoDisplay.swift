//
//  ImageSelectorPhotoDisplay.swift
//  belocal
//
//  Created by Colton Lathrop on 3/20/23.
//

import Foundation
import SwiftUI
import PhotosUI

struct ImageSelectorPhotoDisplay: View {
    @Binding var imageSelection: [ImageSelection]
    
    var body: some View {
        TabView {
            ForEach(self.imageSelection) { imageSelection in
                Image(uiImage: imageSelection.image).resizable().scaledToFit().frame(height: 350)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 400)
    }
}
