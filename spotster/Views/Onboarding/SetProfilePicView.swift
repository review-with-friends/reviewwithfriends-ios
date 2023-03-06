//
//  SetProfilePicView.swift
//  spotster
//
//  Created by Colton Lathrop on 12/3/22.
//

import Foundation
import SwiftUI
import PhotosUI


struct SetProfilePicView: View {
    @Binding var path: NavigationPath
    
    /// Selected image from the photo picker.
    @State var selectedItem: PhotosPickerItem?
    /// Image data from the selected image.
    @State var selectedItemData: Data?
    /// Image Data that will be uploaded.
    @State var dataToUpload: Data?
    /// Tracks if the uploading has started to prevent double input.
    @State var pending: Bool = false
    
    @State var showError = false
    @State var errorText = ""
    
    @EnvironmentObject var auth: Authentication
    
    func moveToNextScreen() {
        self.path.append(ConfirmProfile())
    }
    
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
            Text("Choose a profile picture!").padding()
            Text("You can also change this whenever 😁").font(.caption).foregroundColor(.secondary)
            Spacer()
            if let selectedItemData,
               let uiImage = UIImage(data: selectedItemData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 256, height: 256)
                    .clipShape(Circle()).padding()
            } else {
                ProfilePicLoader(path: self.$path, userId: auth.user?.id ?? "", profilePicSize: .large, navigatable: false, ignoreCache: true)
            }
            if self.showError {
                Text(self.errorText).foregroundColor(.red)
            }
            Spacer()
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    PrimaryButton(title:"Pick From Library", action: {}).disabled(true)
                }.onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                let resizedImage = resizeImage(image: uiImage)
                                self.selectedItemData = resizedImage.jpegData(compressionQuality: 0.9)
                                await uploadImage()
                            }
                        }
                    }
                }.foregroundColor(.primary)
            PrimaryButton(title:"Continue", action: {
                self.moveToNextScreen()
            })
        }.toolbar {
            Button("Skip for now") {
                moveToNextScreen()
            }
        }
    }
    
    /// Uploads/Saves the newly selected image from what is currently selected.
    func uploadImage() async {
        self.hideError()
        
        if self.pending {
            return;
        } else {
            self.pending = true
        }
        
        if let data = self.dataToUpload {
            let result = await spotster.addProfilePic(token: self.auth.token, data: data)
            
            switch result {
            case .success():
                self.moveToNextScreen()
                break
            case.failure(let error):
                self.showError(error: error.description)
                break
            }
        } else {
            self.showError(error: "Select a pic!")
        }
        
        self.pending = false
    }
    
    /// Resizes the given UIImage to within the given size constraints and returns the new one.
    func resizeImage(image: UIImage) -> UIImage {
        let size = image.size
        var scale: CGFloat = 1
        
        var newSize = getSizeFromRatio(size: size, scale: scale)
        
        while newSize.height > 512 || newSize.width > 512 {
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

/// Calculates a size scaledown from a given scale factor.
func getSizeFromRatio(size: CGSize, scale: CGFloat) -> CGSize {
    let widthRatio  = (size.width / scale)  / size.width
    let heightRatio = (size.height / scale) / size.height
    return CGSize(width: size.width * widthRatio, height: size.height * heightRatio)
}

struct SetProfilePicView_Previews: PreviewProvider {
    static var previews: some View {
        SetProfilePicView(path: .constant(NavigationPath())).preferredColorScheme(.dark).environmentObject(Authentication.initPreview()).environmentObject(UserCache())
    }
}
