//
//  ProfileTabIcon.swift
//  bout
//
//  Created by Colton Lathrop on 12/7/22.
//

import Foundation
import SwiftUI

struct ProfileTabIcon: View {
    var icon: UIImage
    var size: CGSize = CGSize(width: 28, height: 28)

    var roundedIcon: UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        defer {
            // End context after returning to avoid memory leak
            UIGraphicsEndImageContext()
        }

        UIBezierPath(
            roundedRect: rect,
            cornerRadius: self.size.height
            ).addClip()
        icon.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }

    var body: some View {
        Image(uiImage: roundedIcon.withRenderingMode(.alwaysOriginal))
    }
}
