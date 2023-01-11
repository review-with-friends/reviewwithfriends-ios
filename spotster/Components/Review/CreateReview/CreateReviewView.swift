//
//  CreateReviewView.swift
//  spotster
//
//  Created by Colton Lathrop on 1/2/23.
//

import Foundation
import SwiftUI
import PhotosUI

struct CreateReviewView: View {
    var reviewLocation: UniqueLocationCreateReview
    
    /// Selected image from the photo picker.
    @State var selectedItem: PhotosPickerItem?
    /// Image data from the selected image.
    @State var selectedItemData: Data?
    
    @State var selectedImage: UIImage?
    /// Image Data that will be uploaded.
    @State var dataToUpload: Data?
    /// Tracks if the uploading has started to prevent double input.
    @State var pending: Bool = false
    
    @State var text: String = ""
    @State var stars: Int = 0
    
    @State var showError = false
    @State var errorText = ""
    
    @State var review: Review?
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var reloadCallback: ChildViewReloadCallback
    
    func showError(error: String) {
        showError = true
        errorText = error
    }
    
    func hideError() {
        showError = false
        errorText = ""
    }
    
    var body: some View {
        VStack {
            if self.showError {
                Text(self.errorText).foregroundColor(.red)
            }
            Text(reviewLocation.locationName).font(.title).lineLimit(1)
                .padding()
            VStack {
                HStack{
                    Spacer()
                    ReviewStarsSelector(stars: $stars).padding()
                    Spacer()
                }
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        if let image = self.selectedImage {
                            Image(uiImage: image).resizable().scaledToFit().cornerRadius(16)
                        } else {
                            Image(systemName: "photo.fill").font(.system(size: 96)).foregroundColor(.secondary)
                        }
                    }.onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                if let uiImage = UIImage(data: data) {
                                    let resizedImage = resizeImage(image: uiImage)
                                    self.selectedImage = resizedImage
                                    self.selectedItemData = resizedImage.jpegData(compressionQuality: 0.9)
                                }
                            }
                        }
                    }.foregroundColor(.primary)
                Form {
                    TextField("Max 400 characters.", text: $text, axis: .vertical).lineLimit(3...)
                    if text.count > 400 {
                        Text("too long").foregroundColor(.red)
                    }
                }
            }
            Spacer()
        }.accentColor(.primary).toolbar {
            Button(action: {
                Task {
                    await postReview()
                }
            }) {
                Text("Post")
            }
        }.onAppear{print(reloadCallback.callback)}
    }
    
    func postReview() async {
        if self.pending == true {
            return
        }
        self.pending = true
        
        if self.review == nil {
            let request = CreateReviewRequest(text: self.text, stars: self.stars, location_name: self.reviewLocation.locationName, latitude: self.reviewLocation.latitude, longitude: self.reviewLocation.longitude, is_custom: false)
            
            let reviewResult = await spotster.createReview(token: auth.token, reviewRequest: request)
            
            switch reviewResult {
            case .success(let review):
                self.review = review
            case .failure(let err):
                self.showError(error: err.description)
            }
        }
        
        if let review = self.review {
            if let picData = self.selectedItemData {
                let picResult = await spotster.addReviewPic(token: auth.token, reviewId: review.id, data: picData)
                switch picResult {
                case .success(_):
                    navigationManager.path.removeLast()
                case .failure(let err):
                    self.showError(error: err.description)
                }
            } else {
                navigationManager.path.removeLast()
            }
        }
        
        await self.reloadCallback.callIfExists()
        
        self.pending = false
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
            
            self.dataToUpload = newImage.jpegData(compressionQuality: 0.9)
            
            return newImage
        }
        
        return image
    }
}


struct CreateReviewView_Preview: PreviewProvider {
    static var previews: some View {
        CreateReviewView(reviewLocation: UniqueLocationCreateReview(locationName: "Taco Bell", latitude: -122.436734, longitude: 45.2384234)).preferredColorScheme(.dark)
    }
}
