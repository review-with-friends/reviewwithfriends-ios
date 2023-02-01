//
//  ReviewPicSkeleton.swift
//  spotster
//
//  Created by Colton Lathrop on 12/21/22.
//

import Foundation
import SwiftUI

struct ReviewPicSkeleton: View {
    var loading: Bool
    var error = false
    
    var width: Int
    var height: Int
    
    var body: some View {
            Image(uiImage: UIColor.gray.image(CGSize(width: width, height: height)))
                .resizable()
                .scaledToFit()
                .opacity(0.2)
                .cornerRadius(16)
                .overlay {
                    if loading {
                        ProgressView()
                    }
                    if error {
                        VStack {
                            Image(systemName: "exclamationmark.triangle").padding(.bottom, 4)
                            Text("Tap to retry").font(.caption)
                        }
                    }
                }
    }
}


struct ReviewPicSkeleton_Preview: PreviewProvider {
    static var previews: some View {
        ReviewPicSkeleton(loading: true, width: 900, height: 1600).preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
    }
}
