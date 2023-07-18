//
//  TaggedImage.swift
//  app
//
//  Created by Colton Lathrop on 7/14/23.
//

import Foundation
import SwiftUI

struct TaggedImageView: View {
    let photo: UIImage
    @State var overlayPosition: CGPoint
    
    var body: some View {
        Image(uiImage: photo)
            .resizable()
            .aspectRatio(contentMode: .fit).overlay {
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.red.opacity(0.5))
                        .frame(width: 50, height: 50)
                        .position(x: overlayPosition.x * geometry.size.width, y: overlayPosition.y * geometry.size.height)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    var newX = value.location.x / geometry.size.width
                                    var newY = value.location.y / geometry.size.height
                                    
                                    if newX >= 1.0 {
                                        newX = 1.0
                                    }
                                    
                                    if newX <= 0.0 {
                                        newX = 0.0
                                    }
                                    
                                    if newY >= 1.0 {
                                        newY = 1.0
                                    }
                                    
                                    if newY <= 0.0 {
                                        newY = 0.0
                                    }
                                    
                                    let newPosition = CGPoint(x: newX, y: newY)
                                    overlayPosition = newPosition
                                }
                        ).frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
    }
}

struct TaggedImageView_Preview: PreviewProvider {
    static var previews: some View {
        TaggedImageView(photo: UIImage(imageLiteralResourceName: "angry"), overlayPosition: CGPoint(x: 0.5, y: 0.5)).preferredColorScheme(.dark)
    }
}
