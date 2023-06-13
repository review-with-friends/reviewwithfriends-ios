//
//  LikeButton.swift
//  app
//
//  Created by Colton Lathrop on 6/6/23.
//

import Foundation
import SwiftUI

struct LikeButton: View {
    /// Whether this should signal already liked.
    var liked: Bool
    
    /// An escaping callback for when action is triggered.
    var callback: () async -> Void
    
    @State var location: CGRect?
    
    var body: some View {
            GeometryReader { geo in
                let location = geo.frame(in: .global)
                Button(action: {
//                    Task {
//                        await self.callback()
//                    }
                }){
                    if liked {
                        Image(systemName: "heart.fill").foregroundColor(.red).font(.system(size: 28))
                    } else {
                        Image(systemName: "heart").foregroundColor(.primary).font(.system(size: 28))
                    }
                }.onAppear {
                    self.location = location
                }
            }.frame(width: 28.0, height: 28.0, alignment: .center)
//            .overlay {
//                Circle().frame(height:28).position(x: self.location.midX, y: self.location.midY)
//            }
    }
}

struct LikeButton_Preview: PreviewProvider {
    static func callback() async {}
    
    static var previews: some View {
        VStack {
            LikeButton(liked: true, callback: callback)
            LikeButton(liked: false, callback: callback)
        }.preferredColorScheme(.dark)
    }
}
