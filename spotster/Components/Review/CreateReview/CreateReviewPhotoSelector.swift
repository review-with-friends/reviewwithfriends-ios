//
//  CreateReviewPhotoSelector.swift
//  spotster
//
//  Created by Colton Lathrop on 3/6/23.
//

import Foundation
import SwiftUI
import PhotosUI

struct CreateReviewPhotoSelector: View {
    @Binding var tabSelection: Int
    @Binding var selectedImages: [UIImage]
    
    /// Selected image from the photo picker.
    @State var selectedItems: [PhotosPickerItem] = []
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                PhotosPicker(
                    selection: $selectedItems,
                    maxSelectionCount: 3,
                    matching: .images,
                    photoLibrary: .shared()) {
                        VStack {
                            if self.selectedImages.count > 0 {
                                PrimaryButton(title: "Add/Remove Photos", action: {}).disabled(true)
                            }
                            else {
                                PrimaryButton(title: "Add Photos", action: {}).disabled(true)
                            }
                        }
                    }.onChange(of: selectedItems) { newItems in
                        self.selectedImages = []
                        Task {
                            for newItem in self.selectedItems {
                                if let data = try? await newItem.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        let resizedImage = resizeImage(image: uiImage)
                                        self.selectedImages.append(resizedImage)
                                    }
                                }
                            }
                        }
                    }.foregroundColor(.primary)
            }.padding(.vertical)
            VStack {
                if self.selectedImages.count > 0 {
                    VStack {
                        CreateReviewPhotoCarousel(pickerItems: self.$selectedItems)
                    }
                } else {
                    VStack {
                        Image(systemName: "photo.fill").font(.system(size: 96)).foregroundColor(.secondary).opacity(0.5)
                        Text("Add some photos! 🤩").foregroundColor(.secondary).font(.caption)
                    }.frame(height: 500)
                }
            }
            Spacer()
            VStack {
                if selectedImages.count == 0 {
                    DisabledPrimaryButton(title: "Continue")
                }
                else {
                    PrimaryButton(title: "Continue", action: {self.tabSelection = 1})
                }
            }
        }
    }
    
    /// Resizes the given UIImage to within the given size constraints and returns the new one.
    func resizeImage(image: UIImage) -> UIImage {
        let size = image.size
        var scale: CGFloat = 1
        
        var newSize = getSizeFromRatio(size: size, scale: scale)
        
        while newSize.height > 2000 || newSize.width > 2000 {
            scale += 1
            newSize = getSizeFromRatio(size: size, scale: scale)
        }
        
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        
        image.draw(in: rect)
        
        if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            
            return newImage
        }
        
        return image
    }
}

struct CreateReviewPhotoSelector_Preview: PreviewProvider {
    struct BindingTestHolder: View {
        @State var selectedImages: [UIImage] = []
        @State var tabSelection: Int = 0
        var body: some View {
            CreateReviewPhotoSelector(tabSelection: self.$tabSelection, selectedImages: self.$selectedImages)
        }
    }
    
    static var previews: some View {
        VStack {
            BindingTestHolder()
        }.preferredColorScheme(.dark)
            .environmentObject(FriendsCache.generateDummyData())
            .environmentObject(UserCache())
            .environmentObject(Authentication.initPreview())
    }
}
