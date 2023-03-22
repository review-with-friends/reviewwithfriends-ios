//
//  ImageSelectorPhotoLibraryChangeObserver.swift
//  belocal
//
//  Created by Colton Lathrop on 3/19/23.
//

import Foundation
import PhotosUI

class ImageSelectorPhotoLibraryChangeObserver: NSObject, PHPhotoLibraryChangeObserver {
    public var callback: (() -> Void)?
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        if let callback = self.callback {
            callback()
        }
    }
}
