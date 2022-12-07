//
//  SetProfilePicView.swift
//  bout
//
//  Created by Colton Lathrop on 12/3/22.
//

import Foundation
import SwiftUI
import PhotosUI


struct SetProfilePicView: View {
    /// Selected image from the photo picker.
    @State var selectedItem: PhotosPickerItem?
    /// Image data from the selected image.
    @State var selectedItemData: Data?
    /// Image Data that will be uploaded.
    @State var dataToUpload: Data?
    /// Tracks if the uploading has started to prevent double input.
    @State var pending: Bool = false
    
    @Binding var phase: OnboardingPhase
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var errorDisplay: ErrorDisplay
    
    var body: some View {
        VStack {
            HStack{
                Button(action: {
                    withAnimation(.spring().speed(2.0)){
                        self.phase = .SetNames
                    }
                }){
                    Text("Back")
                        .font(.caption.bold())
                        .padding()
                }.foregroundColor(.primary).disabled(false)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring().speed(2.0)){
                        self.phase = .GetStarted
                    }
                }){
                    Text("Skip")
                        .font(.caption.bold())
                        .padding()
                }.foregroundColor(.primary).disabled(false)
            }
            
            Spacer()
            
            Text("Set a profile pic")
                .font(.title.bold())
            
            Text("You can update this anytime.")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom)
            
            if let selectedItemData,
               let uiImage = UIImage(data: selectedItemData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 256, height: 256)
                    .clipShape(Circle())
            } else {
                ProfilePicLoader(token: auth.token, userId: auth.user?.id ?? "") { image in
                    ProfilePic(image: image, profilePicSize: .large)
                } placeholder: {
                    ProfilePic(image: UIImage(named: "default")!, profilePicSize: .large)
                }
            }
            
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    Text("Select a pic")
                        .font(.title2.bold())
                        .padding()
                }.onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                let resizedImage = resizeImage(image: uiImage)
                                self.selectedItemData = resizedImage.jpegData(compressionQuality: 0.9)
                            }
                        }
                    }
                }.foregroundColor(.primary)
            
            Button(action: {
                Task {
                    await uploadImage()
                }
            }){
                Text("Save pic")
                    .font(.title2.bold())
                    .padding()
            }.foregroundColor(self.dataToUpload == nil ? .secondary : .primary).disabled(self.dataToUpload == nil  ? true : false)
            
            Spacer()
        }
    }
    
    /// Uploads/Saves the newly selected image from what is currently selected.
    func uploadImage() async {
        errorDisplay.closeError()
        
        if self.pending {
            return;
        } else {
            self.pending = true
        }
        
        if let data = self.dataToUpload {
            let result = await bout.addProfilePic(token: self.auth.token, data: data)
            
            switch result {
            case .success():
                self.phase = .GetStarted
            case.failure(let error):
                self.errorDisplay.showError(message: error.description)
            }
        } else {
            self.errorDisplay.showError(message: "select a pic!")
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
        SetProfilePicView(phase: .constant(OnboardingPhase.SetProfilePic)).preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
    }
}
