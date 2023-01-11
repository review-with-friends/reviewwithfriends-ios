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
    
    var body: some View {
        Rectangle().foregroundColor(.secondary).opacity(0.2).cornerRadius(16)
            .frame(height: 300).overlay {
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
        ReviewPicSkeleton(loading: true).preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
    }
}
