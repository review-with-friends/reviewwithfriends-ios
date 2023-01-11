//
//  ReviewListItemSkeleton.swift
//  spotster
//
//  Created by Colton Lathrop on 1/5/23.
//

import Foundation
import SwiftUI

struct ReviewListItemSkeleton: View {
    var loading: Bool
    var body: some View {
        Rectangle().foregroundColor(.secondary).opacity(0.2).cornerRadius(16)
            .frame(height: 500).overlay {
                if loading {
                    ProgressView()
                }
            }
    }
}


struct ReviewListItemSkeleton_Preview: PreviewProvider {
    static var previews: some View {
        ReviewListItemSkeleton(loading: true).preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
    }
}
