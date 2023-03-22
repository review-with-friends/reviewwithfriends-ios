//
//  SharedImageSelector.swift
//  belocal
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
    
    @State private var isPresented: Bool = false
    @State private var authStatus: PHAuthorizationStatus
    @State private var changeObserver = ImageSelectorPhotoLibraryChangeObserver()
    
    @StateObject var fetchResults: PHFetchResultManager = PHFetchResultManager()
    
    var imageManager = PHImageManager.default()
    
    init(selectedImages: Binding<[ImageSelection]>) {
        /// Set the binding. Parent will render the selected images.
        self._selectedImages = selectedImages
        
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
    
    /// As the user scrolls the image grid, we can call this to populate more thumbnails
    /// This controlls everything needed to stop loading more if they don't exist.
    func loadMoreForImageGrid() {
        DispatchQueue.main.async {
            fetchResults.loadMore()
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
        self.fetchResults.assignNewResults(results: PHAsset.fetchAssets(with: .image, options: nil))
    }
    
    /// Fetches the images asset, marks it as selected one done.
    /// This also manages NOT selecting something when full.
    func selectImage(asset: IdentifiablePHAsset) {
        /// If the image is already selected, lets remove it, set selected to false, and return.
        if self.selectedImages.contains(where: { selection in
            selection.id == asset.id
        }) {
            asset.selected = false
            self.selectedImages.removeAll { selection in
                selection.id == asset.id
            }
            return
        }
        
        /// Block selection to just 3 total.
        /// This may change later.
        if self.selectedImages.count >= 3 {
            return
        }
        
        /// This fetches the image data from the shared image manager.
        /// This need to contain the orientation metadata which also contains
        /// the potential latitude and longitude of where the image was taken.
        imageManager.requestImageDataAndOrientation(for: asset.asset, options: nil) { data, dataUTI, orientation, info  in
            if let data = data {
                if var image = UIImage(data: data) {
                    image = belocal.resizeImage(image: image)
                    asset.selected = true
                    if !self.selectedImages.contains(where: { existingSelection in
                        existingSelection.id == asset.id
                    }) {
                        self.selectedImages.append(ImageSelection(id: asset.id, image: image, exifData: asset.asset.location))
                    }
                } else {
                }
            }
        }
    }
    
    var selectLimitedPhotos: some View {
        SmallPrimaryButton(title: "Add Photos", action: {
            isPresented.toggle()
        })
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
                    ImageSelectorGridItem(identifiableAsset: identifiableAsset, selectImageCallback: self.selectImage)
                }
            }
            if self.fetchResults.finished == false {
                ProgressView().onAppear(perform: self.loadMoreForImageGrid)
            }
        }.frame(height: 240)
    }
    
    var body: some View {
        VStack {
            VStack {
                self.accessState
                LimitedPicker(isPresented: $isPresented)
                    .frame(width: 0, height: 0)
            }
            if self.shouldShowImageGrid() {
                self.imageGrid
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
        }
    }
}

struct ImageSelectorGridItem: View {
    @State public var identifiableAsset: IdentifiablePHAsset
    @State var thumbnail: UIImage?
    
    var selectImageCallback: (_: IdentifiablePHAsset) -> Void
    
    var imageManager = PHImageManager.default()
    
    var body: some View {
        VStack {
            if let thumbnail = self.thumbnail {
                Rectangle()
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        Button(action: {
                            self.selectImageCallback(self.identifiableAsset)
                        }){
                            Image(uiImage: thumbnail)
                                .resizable()
                                .scaledToFill()
                        }
                    }.overlay {
                        if self.identifiableAsset.selected {
                            VStack {
                                HStack {
                                    Spacer()
                                    ZStack {
                                        Circle().foregroundColor(.white).frame(width: 16)
                                        Image(systemName: "checkmark.circle.fill").foregroundColor(.blue).padding(2)
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
