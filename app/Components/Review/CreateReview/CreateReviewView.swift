//
//  CreateReviewView.swift
//  app
//
//  Created by Colton Lathrop on 1/2/23.
//

import Foundation
import SwiftUI
import PhotosUI

struct CreateReviewView: View {
    @Binding var path: NavigationPath
    
    @State var tabSelection: Int = 0
    
    var reviewLocation: UniqueLocationCreateReview
    
    @State var selectedImages: [ImageSelection] = []
    
    /// Image Data that will be uploaded.
    @State var dataToUpload: Data?
    /// Tracks if the uploading has started to prevent double input.
    @State var pending: Bool = false
    
    @StateObject var model = CreateReviewModel()
    
    @State var review: Review?
    
    @State var cancelAlertShowing: Bool = false
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var reloadCallback: ChildViewReloadCallback
    
    func showError(error: String) {
        self.model.showError = true
        self.model.errorText = error
    }
    
    func hideError() {
        self.model.showError = false
        self.model.errorText = ""
    }
    
    var cancelButton: some View {
        Button(action: {
            if self.selectedImages.count == 0 && self.model.text.isEmpty {
                self.path.removeLast()
            } else {
                self.cancelAlertShowing = true
            }
        }) {
            Text("Cancel").bold()
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                Text(self.reviewLocation.locationName).font(.title.bold())
            }
            TabView(selection: self.$tabSelection) {
                ScrollView {
                    ImageSelectorPhotoDisplay(imageSelection: self.$selectedImages)
                    ImageSelector(selectedImages: self.$selectedImages)
                    VStack {
                        if selectedImages.count == 0 {
                            DisabledPrimaryButton(title: "Continue")
                        }
                        else {
                            PrimaryButton(title: "Continue", action: {self.tabSelection = 1})
                        }
                    }
                }.tag(0).scrollIndicators(.hidden)
                VStack {
                    VStack {
                        PrimaryButton(title: "Change Photos", action: {
                            self.tabSelection = 0
                        })
                    }
                    ReviewDataEditor(model: self.model, postAction: {Task {
                        await self.postReview()
                    }})
                }.tag(1)
            }
        }.accentColor(.primary).overlay {
            if self.pending {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    Spacer()
                }.background(APP_BACKGROUND.opacity(0.5))
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: cancelButton)
        .alert(isPresented: self.$cancelAlertShowing) {
            Alert(
                title: Text("Are you sure you want to trash this review?"),
                message: Text("You'll need to recreate everything."),
                primaryButton: .default(
                    Text("Keep Going"),
                    action: {
                        self.cancelAlertShowing = false
                    }
                ),
                secondaryButton: .destructive(
                    Text("Trash Review"),
                    action: {
                        self.path.removeLast()
                    }
                )
            )
        }
    }
    
    func postReview() async {
        var dataToBeUploaded: Data
        
        if let selectedImage = self.selectedImages.first {
            if let data = selectedImage.image.jpegData(compressionQuality: 0.9) {
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
            let request = CreateReviewRequest(text: self.model.text,
                                              stars: self.model.stars,
                                              category: self.reviewLocation.category,
                                              location_name: self.reviewLocation.locationName,
                                              latitude: self.reviewLocation.latitude,
                                              longitude: self.reviewLocation.longitude,
                                              is_custom: false,
                                              pic: dataToBeUploaded.base64EncodedString(),
                                              post_date: Int64((self.model.date.timeIntervalSince1970 * 1000.0).rounded()))
            
            let reviewResult = await app.createReview(token: auth.token, reviewRequest: request)
            
            switch reviewResult {
            case .success(let review):
                for selectedImage in self.selectedImages {
                    if let data = selectedImage.image.jpegData(compressionQuality: 0.9) {
                        let _ = await app.addReviewPic(token: auth.token, reviewId: review.id, data: data)
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
}

struct CreateReviewView_Preview: PreviewProvider {
    static var previews: some View {
        CreateReviewView(path: .constant(NavigationPath()), reviewLocation: UniqueLocationCreateReview(locationName: "Taco Bell", category: "restaurant", latitude: -122.436734, longitude: 45.2384234)).preferredColorScheme(.dark)
    }
}
