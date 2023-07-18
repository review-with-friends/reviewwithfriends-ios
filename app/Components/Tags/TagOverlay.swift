//
//  TagOverlay.swift
//  app
//
//  Created by Colton Lathrop on 7/14/23.
//

import Foundation
import SwiftUI

extension View {
    public func tagOverlay(_ tags: [Tag], path: Binding<NavigationPath>) -> some View {
        self.overlay(TagOverlay(path: path, tags: tags))
    }
}

struct TagOverlay: View {
    @Binding var path: NavigationPath
    var tags: [Tag]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(self.tags.indices) { index in
                    var tag = self.tags[index]
                    TagView(path: self.$path, userId: tag.userId)
                        .position(x: tag.x * geometry.size.width, y: geometry.size.height * tag.y)
                }
            }.frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}


struct TagOverlay_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            Image("angry").tagOverlay([Tag(id: "123", created: Date(), reviewId: "123", userId: "123", picId: "123", x: 0.5, y: 0.5),
                                       Tag(id: "127", created: Date(), reviewId: "123", userId: "123", picId: "123", x: 0.4, y: 0.6)], path: .constant(NavigationPath()))
        }.preferredColorScheme(.dark)
            .environmentObject(FriendsCache.generateDummyData())
            .environmentObject(UserCache())
            .environmentObject(Authentication.initPreview())
    }
}

//        .gesture(
//            DragGesture()
//                .onChanged { value in
//                    var newX = value.location.x / geometry.size.width
//                    var newY = value.location.y / geometry.size.height
//
//                    if newX >= 1.0 {
//                        newX = 1.0
//                    }
//
//                    if newX <= 0.0 {
//                        newX = 0.0
//                    }
//
//                    if newY >= 1.0 {
//                        newY = 1.0
//                    }
//
//                    if newY <= 0.0 {
//                        newY = 0.0
//                    }
//
//                    let newPosition = CGPoint(x: newX, y: newY)
//                    overlayPosition = newPosition
//                }
//        )
