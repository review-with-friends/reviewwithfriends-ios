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
    
    @State var fullReview: FullReview
    
    @State var text: String = ""
    @State var stars: Int = 0
    @State var selectedPhoto: Int = 0
    @State var selectedItem: PhotosPickerItem?
    
    @EnvironmentObject var auth: Authentication
    
    func saveReview() async {
        let result = await app.editReview(token: auth.token, editRequest: EditReviewRequest(review_id: self.fullReview.review.id, text: self.text, stars: self.stars))
        
        switch result {
        case .success():
            await refreshFullReview()
        case .failure(_):
            return
        }
    }
    
    func addPic(data: Data) async {
        let result = await app.addReviewPic(token: auth.token, reviewId: self.fullReview.review.id, data: data)
        
        switch result {
        case .success():
            await refreshFullReview()
        case .failure(_):
            return
        }
    }
    
    func removePic() async {
        if let pic = self.fullReview.pics.first(where: { $0.hashValue == self.selectedPhoto }) {
            let result = await app.removeReviewPic(token: auth.token, picId: pic.id, reviewId: self.fullReview.review.id)
            switch result {
            case .success():
                await refreshFullReview()
            case .failure(_):
                return
            }
        }
    }
    
    func refreshFullReview() async {
        let result = await getFullReviewById(token: auth.token, reviewId: self.fullReview.review.id)
        
        switch result {
        case .success(let fullReview):
            self.fullReview = fullReview
            self.setPicTabView()
        case .failure(_):
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
            HStack{
                Spacer()
                ReviewStarsSelector(stars: $stars).padding()
                Spacer()
            }.padding()
            HStack {
                TextField("Write a caption", text: $text, axis: .vertical).lineLimit(3...)
            }.padding()
            VStack {
                HStack {
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            VStack {
                                Text("Add Another Photo").foregroundColor(self.fullReview.pics.count >= 3 ? .secondary : .green)
                            }
                        }.onChange(of: selectedItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        let resizedImage = resizeImage(image: uiImage)
                                        
                                        if let data = resizedImage.jpegData(compressionQuality: 0.9) {
                                            await self.addPic(data: data)
                                        }
                                    }
                                }
                            }
                        }.foregroundColor(.primary).disabled(self.fullReview.pics.count >= 3)
                    Spacer()
                    Button("Remove Photo", role: .destructive) {
                        Task {
                            await self.removePic()
                        }
                    }.padding().disabled(self.fullReview.pics.count <= 1)
                }
                TabView(selection: $selectedPhoto) {
                    ForEach(self.fullReview.pics) { pic in
                        ReviewPicLoader(path: self.$path, pic: pic).tag(pic.hashValue)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(height: 250)
            Spacer()
        }.onAppear {
            self.text = self.fullReview.review.text
            self.stars = self.fullReview.review.stars
            self.setPicTabView()
        }.navigationTitle("Edit Review").toolbar {
            Button(action: {
                Task {
                    await self.saveReview()
                    self.path.removeLast()
                }
            }) {
                Text("Save")
            }
        }
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
