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
    @Binding var path: NavigationPath
    var reviewLocation: UniqueLocationCreateReview
    
    /// Selected image from the photo picker.
    @State var selectedItem: PhotosPickerItem?
    
    @State var selectedImages: [UIImage] = []
    
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
        ScrollView {
            if self.showError {
                Text(self.errorText).foregroundColor(.red)
            }
            VStack {
                HStack{
                    Spacer()
                    ReviewStarsSelector(stars: $stars).padding()
                    Spacer()
                }.padding()
                HStack {
                    VStack {
                        TextField("Write a caption", text: $text, axis: .vertical).lineLimit(3...)
                        if text.count > 400 {
                            Text("too long").foregroundColor(.red)
                        }
                    }.padding().background(.quaternary).cornerRadius(8)
                }
                HStack {
                    Spacer()
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            VStack {
                                    if self.selectedImages.count > 0 {
                                        Text("Add Another Photo").foregroundColor(self.selectedImages.count >= 3 ? .secondary : .primary)
                                    }
                                    else {
                                        Text("Add Photo")
                                    }
                            }
                        }.onChange(of: selectedItem) { newItem in
                            if self.selectedImages.count >= 3 {
                                return
                            }
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        let resizedImage = resizeImage(image: uiImage)
                                        self.selectedImages.append(resizedImage)
                                        print(self.selectedImages.count)
                                        //self.selectedItemData = resizedImage.jpegData(compressionQuality: 0.9)
                                    }
                                }
                            }
                        }.foregroundColor(.primary).disabled(self.selectedImages.count >= 3)
                }.padding()
                VStack {
                    HStack {
                        Text("Photo Preview:").foregroundColor(.secondary)
                        Spacer()
                    }
                    if self.selectedImages.count > 0 {
                        VStack {
                            CreateReviewPhotoCarousel(images: self.selectedImages)
                        }
                    } else {
                        VStack {
                            Image(systemName: "photo.fill").font(.system(size: 96)).foregroundColor(.secondary).opacity(0.5)
                        }.frame(height: 500)
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
        }
    }
    
    func postReview() async {
        var dataToBeUploaded: Data
        
        if let pic = self.selectedImages.first {
            if let data = pic.jpegData(compressionQuality: 0.9) {
                dataToBeUploaded = data
                self.selectedImages.remove(at: 0) // remove the first as it will be the guarenteed uploaded
            } else {
                self.showError(error: "something went wrong resizing the pic")
                return
            }
        } else {
            self.showError(error: "add a pic 🙄")
            return
        }
        
        if self.pending == true {
            return
        }
        
        self.pending = true
        
        if self.review == nil {
            let request = CreateReviewRequest(text: self.text, stars: self.stars, category: self.reviewLocation.category, location_name: self.reviewLocation.locationName, latitude: self.reviewLocation.latitude, longitude: self.reviewLocation.longitude, is_custom: false, pic: dataToBeUploaded.base64EncodedString())
            
            let reviewResult = await spotster.createReview(token: auth.token, reviewRequest: request)
            
            switch reviewResult {
            case .success(let review):
                for image in self.selectedImages {
                    if let data = image.jpegData(compressionQuality: 0.9) {
                        let _ = await spotster.addReviewPic(token: auth.token, reviewId: review.id, data: data)
                    }
                }
                self.path.removeLast()
            case .failure(let err):
                self.showError(error: err.description)
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
        CreateReviewView(path: .constant(NavigationPath()), reviewLocation: UniqueLocationCreateReview(locationName: "Taco Bell", category: "restaurant", latitude: -122.436734, longitude: 45.2384234)).preferredColorScheme(.dark)
    }
}
