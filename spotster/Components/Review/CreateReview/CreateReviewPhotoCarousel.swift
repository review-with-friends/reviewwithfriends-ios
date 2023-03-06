//
//  CreateReviewPhotoCarousel.swift
//  spotster
//
//  Created by Colton Lathrop on 2/12/23.
//

import Foundation
import SwiftUI
import PhotosUI

struct CreateReviewPhotoCarousel: View {
    @Binding var pickerItems: [PhotosPickerItem]
    @State var images: [PhotoPickerDisplayMapping] = []
    
    var body: some View {
        TabView {
            ForEach(self.images) { map in
                Image(uiImage: map.image).resizable().scaledToFit().cornerRadius(16)
            }
        }.onChange(of: self.pickerItems, perform: { _ in
            Task {
                await self.loadImages()
            }
        })
        .onAppear {
            Task {
                await self.loadImages()
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 500)
    }
    
    func loadImages() async {
        self.images = []
        for pickerItem in self.pickerItems {
            if let data = try? await pickerItem.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    images.append(PhotoPickerDisplayMapping(id: pickerItem.hashValue, image: uiImage, photosPickerItem: pickerItem))
                }
            }
        }
    }
}

struct PhotoPickerDisplayMapping: Identifiable {
    let id: Int
    let image: UIImage
    let photosPickerItem: PhotosPickerItem
}
