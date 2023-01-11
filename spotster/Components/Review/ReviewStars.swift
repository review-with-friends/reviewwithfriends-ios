//
//  ReviewStars.swift
//  spotster
//
//  Created by Colton Lathrop on 12/20/22.
//

import Foundation
import SwiftUI

struct ReviewStars: View {
    var stars: Int
    var body: some View {
        HStack(spacing: 2) {
            ForEach((1...5), id: \.self) {
                if $0 <= self.stars {
                    Image(systemName:"star.fill").resizable()
                        .scaledToFill().frame(width: 14, height: 14)
                } else {
                    Image(systemName:"star").resizable()
                        .scaledToFill().frame(width: 14, height: 14)
                }
            }
        }
    }
}

struct ReviewStars_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            ReviewStars(stars: 0).preferredColorScheme(.dark)
            ReviewStars(stars: 1).preferredColorScheme(.dark)
            ReviewStars(stars: 2).preferredColorScheme(.dark)
            ReviewStars(stars: 3).preferredColorScheme(.dark)
            ReviewStars(stars: 4).preferredColorScheme(.dark)
            ReviewStars(stars: 5).preferredColorScheme(.dark)
        }
    }
}
