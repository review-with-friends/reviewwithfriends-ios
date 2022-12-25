//
//  ReviewPicSkeleton.swift
//  bout
//
//  Created by Colton Lathrop on 12/21/22.
//

import Foundation
import SwiftUI

struct ReviewPicSkeleton: View {
    @State private var isRotating = 0.9
    
    var body: some View {
        Rectangle().foregroundColor(.secondary).opacity(0.2)
            .frame(height: 300).overlay {
                Image(systemName: "photo.circle")
                    .font(.system(size: 78)).foregroundColor(.secondary)
                    .scaleEffect(x: isRotating, y: isRotating)
                    .shadow(radius: 5)
                    .onAppear {
                        withAnimation(
                            .linear(duration: 1)
                            .speed(1)
                            .repeatForever(autoreverses: true)) {
                                isRotating = 1
                            }
                    }
        }
    }
}

struct ReviewPicSkeleton_Preview: PreviewProvider {
    static var previews: some View {
        ReviewPicSkeleton().preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
    }
}
