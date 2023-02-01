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
        ProgressView()
    }
}


struct ReviewListItemSkeleton_Preview: PreviewProvider {
    static var previews: some View {
        ReviewListItemSkeleton(loading: true).preferredColorScheme(.dark).environmentObject(Authentication.initPreview())
    }
}
