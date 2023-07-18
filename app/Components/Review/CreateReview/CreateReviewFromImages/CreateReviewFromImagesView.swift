//
//  CreateReviewFromImagesView.swift
//  app
//
//  Created by Colton Lathrop on 3/16/23.
//

import Foundation
import SwiftUI
import PhotosUI

struct CreateReviewFromImagesView: View {
    @Binding var path: NavigationPath
    
    @State var tabSelection: Int = 0
    
    @State var selectedImages: [ImageSelection] = []
    
    @State var selectedLocation: UniqueLocation?
    
    /// Image Data that will be uploaded.
    @State var dataToUpload: Data?
    
    /// Tracks if the uploading has started to prevent double input.
    @State var pending: Bool = false
    
    @State var uploadPhotos: Bool = false
    
    @StateObject var model = CreateReviewModel()
    
    @State var review: Review?
    
    @State var cancelAlertShowing: Bool = false
    
    @State var showPreviewSheet: Bool = false
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var reloadCallback: ChildViewReloadCallback
    @EnvironmentObject var feedRefreshManager: FeedRefreshManager
    
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
    
    var previewButton: some View {
        Button(action: {
            self.showPreviewSheet = true
        }) {
            Text("Preview Photos").bold()
        }.accentColor(self.selectedImages.count > 0 ? .primary : .secondary)
            .disabled(self.selectedImages.count > 0 ? false : true)
    }
    
    var body: some View {
        VStack {
            TabView(selection: self.$tabSelection) {
                VStack {
                    ImageSelector(selectedImages: self.$selectedImages, maxImages: 7)
                    VStack {
                        if selectedImages.count == 0 {
                            DisabledPrimaryButton(title: "Continue")
                        }
                        else {
                            PrimaryButton(title: "Continue", action: {self.tabSelection = 1})
                        }
                    }
                }.tag(0).scrollIndicators(.hidden).toolbar(.hidden, for: .tabBar)
                VStack {
                    ReviewImageLookup(selectedImages: self.$selectedImages, selectedLocation: self.$selectedLocation)
                    Spacer()
                    VStack {
                        if self.selectedLocation == nil {
                            DisabledPrimaryButton(title: "Continue")
                        }
                        else {
                            PrimaryButton(title: "Continue", action: {self.tabSelection = 2})
                        }
                    }
                }.tag(1).scrollIndicators(.hidden).toolbar(.hidden, for: .tabBar).ignoresSafeArea(.keyboard)
                VStack {
                    ScrollView {
                        VStack {
                            if let reviewLocation = self.selectedLocation {
                                Text(reviewLocation.locationName).font(.title.bold())
                            }
                        }.padding(.top)
                        VStack {
                            PrimaryButton(title: "Change Location", action: {
                                self.tabSelection = 1
                            })
                            PrimaryButton(title: "Change Photos", action: {
                                self.tabSelection = 0
                            })
                        }
                        VStack {
                            ReviewDataEditor(model: self.model, postAction: {Task {
                                await self.postReview()
                            }})
                        }
                    }.scrollDismissesKeyboard(.immediately)
                }.tag(2).scrollIndicators(.hidden).toolbar(.hidden, for: .tabBar)
            }.toolbar(.hidden, for: .tabBar)
        }.accentColor(.primary).overlay {
            VStack {
                if self.uploadPhotos {
                    if let createdReview = self.review {
                        AddImagesUploader(finishUploadCallback: self.finishPost, uploadPhoto: self.uploadPhoto, reviewId: createdReview.id, imagesToUpload: self.selectedImages)
                    }
                } else if self.pending {
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
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: cancelButton, trailing: previewButton)
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
        }.sheet(isPresented: self.$showPreviewSheet) {
            VStack {
                ImageSelectorPhotoDisplay(imageSelection: self.$selectedImages)
            }
        }
    }
    
    func postReview() async {
        guard let reviewLocation = self.selectedLocation else {
            return // Don't navigation to user location annotation
        }
        
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
                                              category: reviewLocation.category,
                                              location_name: reviewLocation.locationName,
                                              latitude: reviewLocation.latitude,
                                              longitude: reviewLocation.longitude,
                                              is_custom: false,
                                              pic: dataToBeUploaded.base64EncodedString(),
                                              post_date: Int64((self.model.date.timeIntervalSince1970 * 1000.0).rounded()),
                                              delivered: self.model.delivered)
            
            let reviewResult = await app.createReview(token: auth.token, reviewRequest: request)
            
            switch reviewResult {
            case .success(let review):
                self.review = review
                self.uploadPhotos = true
            case .failure(let err):
                self.showError(error: err.description)
            }
        }
        self.feedRefreshManager.pushHardReload()
        await self.reloadCallback.callIfExists()
        
        self.pending = false
    }
    
    func uploadPhoto(token: String, reviewId: String, data: Data) async -> Result<(), RequestError> {
        return await app.addReviewPic(token: token, reviewId: reviewId, data: data)
    }
    
    func finishPost() {
        self.path.removeLast()
        app.requestUserAppReview()
    }
}

struct CreateReviewFromImagesView_Preview: PreviewProvider {
    static var previews: some View {
        CreateReviewFromImagesView(path: .constant(NavigationPath())).preferredColorScheme(.dark)
    }
}
