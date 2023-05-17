//
//  SharedImageSelector.swift
//  app
//
//  Created by Colton Lathrop on 3/16/23.
//

import Foundation
import SwiftUI
import UIKit
import PhotosUI

/// ImageSelector is responsible for render the image selection ui.
/// The bindings are the selected images.
struct ImageSelector: View {
    @Binding var selectedImages: [ImageSelection]
    
    var maxImages: Int32
    
    @State private var isLoading: Bool = true
    
    @State private var isPresented: Bool = false
    @State private var authStatus: PHAuthorizationStatus
    @State private var changeObserver = ImageSelectorPhotoLibraryChangeObserver()
    
    @State private var selectedAssetCollection: IdentifiablePHAssetCollection?
    
    @StateObject var fetchResults: PHFetchResultManager = PHFetchResultManager()
    
    var imageManager = PHImageManager.default()
    
    init(selectedImages: Binding<[ImageSelection]>, maxImages: Int32) {
        /// Set the binding. Parent will render the selected images.
        self._selectedImages = selectedImages
        self.maxImages = maxImages
        
        /// Grab authorization status before we render anything
        self.authStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        /// Register a callback object to reload shared assets if needed
        PHPhotoLibrary.shared().register(self.changeObserver)
    }
    
    /// For the current selection this is a straight forward ask.
    /// But future situations could come up where we want to
    /// display the library selection outside of just limited access.
    func shouldShowLibrarySelection() -> Bool {
        if self.authStatus == .limited {
            return true
        } else {
            return false
        }
    }
    
    /// Figures out if we should show the image grid.
    /// Specific auth statuses for the photo library may
    /// make this a complex decision.
    func shouldShowImageGrid() -> Bool {
        if self.authStatus == .limited || self.authStatus == .authorized {
            return true
        } else {
            return false
        }
    }
    
    /// Figures out if we should show the album select
    func shouldShowAlbumSelect() -> Bool {
        if self.authStatus == .authorized {
            return true
        } else {
            return false
        }
    }
    
    /// As the user scrolls the image grid, we can call this to populate more thumbnails
    /// This controlls everything needed to stop loading more if they don't exist.
    func loadMoreForImageGrid() {
        DispatchQueue.main.async {
            fetchResults.loadMore()
        }
    }
    
    /// Checks the thumbnail loader to see if it's done loading the asset array
    /// If we don't even have one, never render this...
    func shouldShowImageGridProgress() -> Bool {
        return !fetchResults.finished
    }
    
    /// Combined with a plist setting, this won't prompt.
    /// As-is just fetches what we should have access to
    /// and initializes the paginiation.
    func fetchAuthorizedImages() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        self.isLoading = true
        
        /// Kick off task to do the loading
        Task {
            if let identifiableAssetCollection = self.selectedAssetCollection {
                self.fetchResults.assignNewResults(results: PHAsset.fetchAssets(in: identifiableAssetCollection.assetCollection, options: fetchOptions))
            } else {
                self.fetchResults.assignNewResults(results: PHAsset.fetchAssets(with: .image, options: fetchOptions))
            }
            /// Send back the completion of the loading to the main queue
            DispatchQueue.main.async() {
                self.isLoading = false
            }
        }
    }
    
    /// Fetches the images asset, marks it as selected one done.
    /// This also manages NOT selecting something when full.
    func selectImage(asset: IdentifiablePHAsset) {
        /// If the image is already selected, lets remove it, set selected to false, and return.
        if self.selectedImages.contains(where: { selection in
            selection.id == asset.id
        }) {
            self.selectedImages.removeAll { selection in
                selection.id == asset.id
            }
            return
        }
        
        if self.selectedImages.count >= self.maxImages {
            return
        }
        
        let options = PHImageRequestOptions()
        options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true
        
        /// This fetches the image data from the shared image manager.
        /// This need to contain the orientation metadata which also contains
        /// the potential latitude and longitude of where the image was taken.
        imageManager.requestImageDataAndOrientation(for: asset.asset, options: options) { data, dataUTI, orientation, info  in
            if self.selectedImages.count >= self.maxImages {
                return
            }
            if let data = data {
                if var image = UIImage(data: data) {
                    image = app.resizeImage(image: image)
                    if !self.selectedImages.contains(where: { existingSelection in
                        existingSelection.id == asset.id
                    }) {
                        self.selectedImages.append(ImageSelection(id: asset.id, image: image, exifData: asset.asset.location))
                    }
                } else {
                }
            } else {
                print("no data")
            }
        }
    }
    
    var selectLimitedPhotos: some View {
        Button(action:{
            isPresented.toggle()
        }){
            Image(systemName: "photo.stack.fill")
        }.padding(.top, 1).accentColor(.primary)
    }
    
    var navigateToSettings: some View {
        SmallPrimaryButton(title: "Grant Access", action: {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
    }
    
    var accessState: some View {
        VStack {
            switch self.authStatus {
            case .notDetermined:
                HStack {
                    Text("Access Not Determined").foregroundColor(.red)
                    Spacer()
                    self.navigateToSettings
                }
            case .restricted:
                HStack {
                    Text("Restricted Photo Access").foregroundColor(.red)
                    Spacer()
                    self.navigateToSettings
                }
            case .denied:
                HStack {
                    Text("Denied Photo Access").foregroundColor(.red)
                    Spacer()
                    self.navigateToSettings
                }
            case .authorized:
                HStack {
                    Text("Full Photo Access").foregroundColor(.green)
                    Spacer()
                }
            case .limited:
                HStack {
                    Text("Limited Photo Access").foregroundColor(.yellow)
                    Spacer()
                    self.selectLimitedPhotos
                }
            @unknown default:
                HStack {
                    Text("Access Not Determined").foregroundColor(.red)
                    Spacer()
                    self.navigateToSettings
                }
            }
        }
    }
    
    var imageGrid: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem()]) {
                ForEach(self.fetchResults.assets) { identifiableAsset in
                    ImageSelectorGridItem(selectedImages: self.$selectedImages, identifiableAsset: identifiableAsset, selectImageCallback: self.selectImage)
                }
                if self.fetchResults.finished == false {
                    ProgressView().onAppear(perform: self.loadMoreForImageGrid)
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    self.accessState
                    if self.shouldShowAlbumSelect() {
                        ImageAlbumSelector(selectedAssetCollection: self.$selectedAssetCollection)
                    }
                    Button(action:{
                        self.selectedImages = []
                    }){
                        Image(systemName: "rectangle.on.rectangle.slash.fill")
                    }.padding(.top, 1).accentColor(.primary).disabled(self.selectedImages.count == 0).padding(.horizontal, 8.0)
                }.padding(.vertical, 8)
                LimitedPicker(isPresented: $isPresented)
                    .frame(width: 0, height: 0)
            }
            if self.isLoading {
                VStack {
                    Spacer()
                    if self.authStatus == .denied {
                        Image("disobey")
                            .resizable()
                            .scaledToFit()
                            .overlay {
                                VStack {
                                    Spacer()
                                    VStack {
                                        HStack {
                                            HStack {
                                                Text("We don't have access to your Photos.").font(.title2.bold()).padding().foregroundColor(.primary)
                                            }.background(.blue).cornerRadius(25)
                                            Spacer()
                                        }.padding(.horizontal)
                                        HStack {
                                            Spacer()
                                            HStack {
                                                Text("Don't worry, I don't trust me either.").font(.title2.bold()).padding().foregroundColor(.black)
                                            }.background(.yellow).cornerRadius(25)
                                        }.padding(.horizontal)
                                        HStack {
                                            HStack {
                                                Text("Try the Limited Access option and only give us access to what you want to post.").font(.title2.bold()).padding().foregroundColor(.primary)
                                            }.background(.red).cornerRadius(25)
                                            Spacer()
                                        }.padding(.horizontal.union(.bottom))
                                    }
                                }.shadow(radius: 5)
                            }.unsplashToolTip(URL(string: "https://unsplash.com/@bfigas")!).cornerRadius(16)
                    } else {
                        ProgressView()
                    }
                    Spacer()
                }
            } else {
                if self.shouldShowImageGrid() {
                    self.imageGrid
                }
            }
        }.onAppear {
            /// Set an escaping callback to respond to users changing shared images
            self.changeObserver.callback = self.fetchAuthorizedImages
            
            switch self.authStatus {
            case .notDetermined:
                /// if not determined yet, ask and set it on callback.
                /// also fetch the images for the grid.
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    self.authStatus = status
                    if self.shouldShowImageGrid() {
                        self.fetchAuthorizedImages()
                    }
                }
            default:
                break
            }
            
            if self.shouldShowImageGrid() {
                self.fetchAuthorizedImages()
            }
        }.onChange(of: self.selectedAssetCollection) { identifiableAssetCollection in
            self.fetchAuthorizedImages()
        }
    }
}

struct ImageSelectorGridItem: View {
    @Binding var selectedImages: [ImageSelection]
    @State public var identifiableAsset: IdentifiablePHAsset
    @State var thumbnail: UIImage?
    
    var selectImageCallback: (_: IdentifiablePHAsset) -> Void
    
    var imageManager = PHImageManager.default()
    
    func select() {
        self.selectImageCallback(self.identifiableAsset)
    }
    
    func getPosition() -> Int {
        let index = selectedImages.firstIndex { selection in
            return selection.id == identifiableAsset.id
        }
        
        if let foundIndex = index {
            return foundIndex + 1
        } else {
            return 1
        }
    }
    
    var body: some View {
        VStack {
            if let thumbnail = self.thumbnail {
                Rectangle()
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        Button(action: {
                            self.select()
                        }){
                            Image(uiImage: thumbnail)
                                .resizable()
                                .scaledToFill()
                        }
                    }.overlay {
                        if self.selectedImages.contains(where: { selectedImage in
                            selectedImage.id == identifiableAsset.id
                        }) {
                            VStack {
                                HStack {
                                    Spacer()
                                    ZStack {
                                        Image(systemName: "circle.fill").foregroundColor(.blue).padding(2)
                                        Text("\(self.getPosition())").foregroundColor(.white).font(.caption).bold()
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                    .clipShape(Rectangle())
                
            }
        }.onAppear {
            imageManager.requestImage(for: identifiableAsset.asset, targetSize: CGSize(width: 180, height: 180), contentMode: .aspectFill, options: nil, resultHandler: { image, r in
                self.thumbnail = image
            })
        }
    }
}

struct ImageSelection: Identifiable {
    var id: String
    var image: UIImage
    var exifData: CLLocation?
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
