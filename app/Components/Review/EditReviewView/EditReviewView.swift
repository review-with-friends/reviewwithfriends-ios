//
//  EditReviewView.swift
//  app
//
//  Created by Colton Lathrop on 2/16/23.
//

import Foundation
import SwiftUI
import PhotosUI

struct EditReviewView: View {
    @Binding var path: NavigationPath
    var fullReview: FullReview
    
    @State var text: String = ""
    @State var stars: Int = 0
    @State var delivered: Bool = false
    
    @State var selectedPhoto: Int = 0
    @State var selectedItem: PhotosPickerItem?
    
    @State var tabSelection: Int = 0
    @State var selectedPhotosToUpload: [ImageSelection] = []
    
    @State var uploading = false
    
    @EnvironmentObject var auth: Authentication
    
    func saveReview() async {
        let result = await app.editReview(token: auth.token, editRequest: EditReviewRequest(review_id: self.fullReview.review.id, text: self.text, stars: self.stars, delivered: self.delivered))
        
        switch result {
        case .success():
            self.path.removeLast()
        case .failure(_):
            return
        }
    }
    
    func addPic(data: Data) async {
        if self.uploading == true {
            return
        }
        self.uploading = true
        let result = await app.addReviewPic(token: auth.token, reviewId: self.fullReview.review.id, data: data)
        
        switch result {
        case .success():
            self.uploading = false
            self.path.removeLast()
        case .failure(_):
            self.uploading = false
            return
        }
    }
    
    func setPicTabView() {
        if let firstPic = self.fullReview.pics.first {
            self.selectedPhoto = firstPic.hashValue
        }
    }
    
    var body: some View {
        VStack {
            TabView(selection: self.$tabSelection) {
                VStack {
                    HStack{
                        Spacer()
                        ReviewStarsSelector(stars: $stars).padding()
                        Spacer()
                    }.padding()
                    VStack {
                        DeliveredToggle(delivered: self.$delivered)
                    }.padding()
                    VStack {
                        HStack {
                            TextField("Write a caption", text: $text, axis: .vertical).lineLimit(3...)
                        }.padding()
                    }.background(APP_BACKGROUND).cornerRadius(16.0)
                    HStack {
                        PrimaryButton(title: "Save", action: {
                            Task {
                                await self.saveReview()
                            }
                        })
                    }
                    Spacer()
                    VStack {
                        if self.fullReview.pics.count < 7 {
                            PrimaryButton(title: "Add Photo", action: {
                                self.tabSelection = 1
                            })
                        } else {
                            DisabledPrimaryButton(title: "Add Photo")
                        }
                        if self.fullReview.pics.count > 1 {
                            PrimaryButton(title: "Remove Photo", action: {
                                self.tabSelection = 2
                            })
                        } else {
                            DisabledPrimaryButton(title: "Remove Photo")
                        }
                    }
                }.tag(0).toolbar(.hidden, for: .tabBar)
                VStack {
                    VStack {
                        PrimaryButton(title: "Back to Edit", action: {
                            self.tabSelection = 0
                        })
                        if self.selectedPhotosToUpload.count > 0 {
                            PrimaryButton(title: "Upload Photo", action: {
                                Task {
                                    if let selectedImage = self.selectedPhotosToUpload.first {
                                        if let data = selectedImage.image.jpegData(compressionQuality: 0.9) {
                                            await self.addPic(data: data)
                                        }
                                    }
                                }
                            })
                        } else {
                            DisabledPrimaryButton(title: "Upload Photo")
                        }
                    }
                    ImageSelector(selectedImages: self.$selectedPhotosToUpload, maxImages: 1)
                }.tag(1).toolbar(.hidden, for: .tabBar)
                VStack {
                    PrimaryButton(title: "Back to Edit", action: {
                        self.tabSelection = 0
                    })
                    RemovePhotoView(path: self.$path, fullReview: self.fullReview)
                }.tag(2).toolbar(.hidden, for: .tabBar)
            }
        }.onAppear {
            self.text = self.fullReview.review.text
            self.stars = self.fullReview.review.stars
            self.delivered = self.fullReview.review.delivered
            self.setPicTabView()
        }.navigationTitle("Edit")
    }
    
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
