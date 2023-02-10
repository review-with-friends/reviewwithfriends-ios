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
            VStack {
                    HStack{
                        Spacer()
                        ReviewStarsSelector(stars: $stars).padding()
                        Spacer()
                    }.padding()
                Rectangle().frame(height: 1).padding().foregroundColor(.secondary).opacity(0.5)
                    VStack {
                        TextField("Write a caption", text: $text, axis: .vertical).lineLimit(3...).padding(.horizontal)
                        if text.count > 400 {
                            Text("too long").foregroundColor(.red)
                        }
                    }
                Rectangle().frame(height: 1).padding().foregroundColor(.secondary).opacity(0.5)
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        if let image = self.selectedImage {
                            Image(uiImage: image).resizable().scaledToFit().cornerRadius(16)
                        } else {
                            ZStack {
                                Rectangle().scaledToFit().cornerRadius(16).foregroundColor(.secondary).opacity(0.25)
                                VStack {
                                    Image(systemName: "photo.fill").font(.system(size: 96)).foregroundColor(.secondary).opacity(0.5)
                                    Text("tap to add a pic").foregroundColor(.secondary).fontWeight(.semibold).opacity(0.5)
                                }
                            }
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
        
        if let picData = self.selectedItemData {
            dataToBeUploaded = picData
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
            case .success(_):
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
