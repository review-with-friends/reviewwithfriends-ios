//
//  PhotoPreviewData.swift
//  belocal
//
//  Created by Colton Lathrop on 2/12/23.
//

import Foundation
import SwiftUI

func generateArrayOfImages() -> [UIImage] {
    var images: [UIImage] = []
    
    images.append(UIImage(named: "Image1")!)
    images.append(UIImage(named: "Image2")!)
    images.append(UIImage(named: "Image3")!)
    
    return images
}
